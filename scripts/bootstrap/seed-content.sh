#!/usr/bin/env bash
# =============================================================================
# seed-content.sh — Seed initial wiki pages via the Wiki.js GraphQL API.
# =============================================================================
#
# Authenticates with the Wiki.js local strategy, then creates a starter set of
# pages from the wiki/ templates in the repository.
# Skips pages that already exist (idempotent).
#
# Usage:
#   bash scripts/bootstrap/seed-content.sh [--url URL] [--email EMAIL] [--password PASSWORD]
#
# Environment variables:
#   WIKI_BASE_URL         Wiki.js base URL (default: http://localhost:3000)
#   WIKI_ADMIN_EMAIL      Admin email set during the setup wizard
#   WIKI_ADMIN_PASSWORD   Admin password set during the setup wizard
#
# Arguments (override environment variables):
#   --url URL           Wiki.js base URL
#   --email EMAIL       Admin email
#   --password PASSWORD Admin password
#
# Dependencies:
#   curl, python3 (both available by default on Ubuntu LTS)
#
# Example:
#   WIKI_ADMIN_EMAIL=admin@167guild.io \
#   WIKI_ADMIN_PASSWORD=secret \
#   bash scripts/bootstrap/seed-content.sh
# =============================================================================

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
# shellcheck source=scripts/common/lib.sh
source "${SCRIPT_DIR}/../common/lib.sh"

# --------------------------------------------------------------------------- #
# Defaults
# --------------------------------------------------------------------------- #
WIKIJS_URL="${WIKI_BASE_URL:-http://localhost:3000}"
ADMIN_EMAIL="${WIKI_ADMIN_EMAIL:-}"
ADMIN_PASSWORD="${WIKI_ADMIN_PASSWORD:-}"

# --------------------------------------------------------------------------- #
# Argument parsing
# --------------------------------------------------------------------------- #
while [[ $# -gt 0 ]]; do
  case "$1" in
    --url)      WIKIJS_URL="$2";     shift 2 ;;
    --email)    ADMIN_EMAIL="$2";    shift 2 ;;
    --password) ADMIN_PASSWORD="$2"; shift 2 ;;
    --) shift; break ;;
    *) die "Unknown argument: $1" ;;
  esac
done

# --------------------------------------------------------------------------- #
# Prerequisite checks
# --------------------------------------------------------------------------- #
check_prerequisites() {
  require_cmd curl
  require_cmd python3
  require_value "Admin email (WIKI_ADMIN_EMAIL or --email)" "${ADMIN_EMAIL}"
  require_value "Admin password (WIKI_ADMIN_PASSWORD or --password)" "${ADMIN_PASSWORD}"
}

# --------------------------------------------------------------------------- #
# graphql_query — POST a GraphQL request; prints the raw JSON response.
#
# Arguments:
#   $1  GraphQL query/mutation string
#   $2  JWT token (optional)
# --------------------------------------------------------------------------- #
graphql_query() {
  local query="$1"
  local token="${2:-}"

  # Build the JSON payload with Python so special characters are escaped.
  local payload
  payload="$(python3 -c "
import json, sys
print(json.dumps({'query': sys.argv[1]}))
" "${query}")"

  if [[ -n "${token}" ]]; then
    curl -sf \
      -X POST \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${token}" \
      -d "${payload}" \
      "${WIKIJS_URL}/graphql"
  else
    curl -sf \
      -X POST \
      -H "Content-Type: application/json" \
      -d "${payload}" \
      "${WIKIJS_URL}/graphql"
  fi
}

# --------------------------------------------------------------------------- #
# graphql_mutation — POST a GraphQL mutation with variables; prints JSON.
#
# Arguments:
#   $1  Mutation string (variables referenced as $varName)
#   $2  JSON variables object string  e.g. '{"title":"My Page"}'
#   $3  JWT token (optional)
# --------------------------------------------------------------------------- #
graphql_mutation() {
  local mutation="$1"
  local variables="$2"
  local token="${3:-}"

  local payload
  payload="$(python3 -c "
import json, sys
mutation = sys.argv[1]
variables = json.loads(sys.argv[2])
print(json.dumps({'query': mutation, 'variables': variables}))
" "${mutation}" "${variables}")"

  if [[ -n "${token}" ]]; then
    curl -sf \
      -X POST \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${token}" \
      -d "${payload}" \
      "${WIKIJS_URL}/graphql"
  else
    curl -sf \
      -X POST \
      -H "Content-Type: application/json" \
      -d "${payload}" \
      "${WIKIJS_URL}/graphql"
  fi
}

# --------------------------------------------------------------------------- #
# json_get — Extract a value from a JSON string using Python.
#
# Arguments:
#   $1  JSON string
#   $2  Python expression that returns the value, with 'data' as the parsed root
# --------------------------------------------------------------------------- #
json_get() {
  local json="$1"
  local expr="$2"
  python3 -c "
import json, sys
data = json.loads(sys.argv[1])
print(${expr})
" "${json}"
}

# --------------------------------------------------------------------------- #
# Authenticate and return the JWT token.
# --------------------------------------------------------------------------- #
get_token() {
  local mutation='
mutation Login($username: String!, $password: String!, $strategy: String!) {
  authentication {
    login(username: $username, password: $password, strategy: $strategy) {
      responseResult { succeeded errorCode message }
      jwt
    }
  }
}'

  local variables
  variables="$(python3 -c "
import json, sys
print(json.dumps({
    'username': sys.argv[1],
    'password': sys.argv[2],
    'strategy': 'local'
}))
" "${ADMIN_EMAIL}" "${ADMIN_PASSWORD}")"

  local response
  response="$(graphql_mutation "${mutation}" "${variables}")"

  local succeeded
  succeeded="$(json_get "${response}" "data['data']['authentication']['login']['responseResult']['succeeded']")"

  if [[ "${succeeded}" != "True" ]]; then
    local message
    message="$(json_get "${response}" "data['data']['authentication']['login']['responseResult']['message']")"
    die "Authentication failed: ${message}"
  fi

  json_get "${response}" "data['data']['authentication']['login']['jwt']"
}

# --------------------------------------------------------------------------- #
# page_exists — Returns 0 if the page exists, 1 otherwise.
# --------------------------------------------------------------------------- #
page_exists() {
  local path="$1"
  local token="$2"

  local response
  response="$(graphql_query "
{
  pages {
    singleByPath(path: \"${path}\", locale: \"en\") {
      id
    }
  }
}" "${token}" 2>/dev/null || echo '{}')"

  python3 -c "
import json, sys
try:
    data = json.loads(sys.argv[1])
    page = (data.get('data') or {}).get('pages', {}).get('singleByPath')
    sys.exit(0 if page is not None else 1)
except Exception:
    sys.exit(1)
" "${response}"
}

# --------------------------------------------------------------------------- #
# create_page — Create a page; skip if it already exists.
# --------------------------------------------------------------------------- #
create_page() {
  local title="$1"
  local path="$2"
  local content="$3"
  local description="$4"
  local token="$5"

  if page_exists "${path}" "${token}"; then
    log_info "Page already exists, skipping: /${path}"
    return 0
  fi

  log_info "Creating page: /${path}"

  local mutation='
mutation CreatePage(
  $content: String!
  $description: String!
  $path: String!
  $title: String!
) {
  pages {
    create(
      content: $content
      description: $description
      editor: "markdown"
      isPublished: true
      isPrivate: false
      locale: "en"
      path: $path
      tags: []
      title: $title
    ) {
      responseResult { succeeded errorCode message }
      page { id path title }
    }
  }
}'

  local variables
  variables="$(python3 -c "
import json, sys
print(json.dumps({
    'content':     sys.argv[1],
    'description': sys.argv[2],
    'path':        sys.argv[3],
    'title':       sys.argv[4],
}))
" "${content}" "${description}" "${path}" "${title}")"

  local response
  response="$(graphql_mutation "${mutation}" "${variables}" "${token}")"

  local succeeded
  succeeded="$(json_get "${response}" "data['data']['pages']['create']['responseResult']['succeeded']")"

  if [[ "${succeeded}" == "True" ]]; then
    log_success "Created page: /${path}"
  else
    local message
    message="$(json_get "${response}" "data['data']['pages']['create']['responseResult']['message']")"
    log_warn "Failed to create page /${path}: ${message}"
  fi
}

# --------------------------------------------------------------------------- #
# Home page content (loaded from wiki/home.md if it exists).
# --------------------------------------------------------------------------- #
home_content() {
  local file="${REPO_ROOT}/wiki/home.md"
  if [[ -f "${file}" ]]; then
    cat "${file}"
  else
    printf '# 167 Guild Wiki\n\nWelcome to the 167 Guild campaign wiki.\n'
  fi
}

# --------------------------------------------------------------------------- #
# Seed all initial wiki pages.
# --------------------------------------------------------------------------- #
seed_content() {
  local token="$1"

  # Home page — loaded from wiki/home.md
  create_page \
    "167 Guild Wiki" \
    "home" \
    "$(home_content)" \
    "The 167 Guild campaign wiki — Chronicles of Ash, Oath, and Moonlight." \
    "${token}"

  # Getting Started
  create_page \
    "Getting Started" \
    "getting-started" \
    "# Getting Started

Welcome to the 167 Guild Wiki.

## Browse

Use the sidebar to navigate:

- **World** — Geography, history, and cosmology
- **Characters** — Player characters and their stories
- **NPCs** — Allies, rivals, and recurring figures
- **Locations** — Cities, dungeons, and landmarks
- **Factions** — Political and ideological powers
- **Campaign** — Sessions, timeline, and active arcs

## Contributing

Guild members can contribute pages. Contact the Dungeon Master or Platform Administrator for access." \
    "Guide for new visitors to the 167 Guild Wiki." \
    "${token}"

  # World hub
  create_page \
    "World" \
    "world" \
    "# The World

A fractured realm of old empires, haunted frontiers, and forgotten roads.

## Explore

- [Locations](/lore/locations) — Cities, dungeons, and landmarks
- [Organizations](/lore/organizations) — Guilds, houses, and institutions
- [Factions](/lore/factions) — Political and ideological powers
- [Timeline](/campaign/timeline) — Major world events in chronological order" \
    "World overview — geography, history, and cosmology." \
    "${token}"

  # Characters hub
  create_page \
    "Characters" \
    "characters" \
    "# Characters

Player character biographies, journals, and key relationships.

## Party Members

Character profiles will appear here as they are added.

## Contributing

Each player is encouraged to maintain their character page with notes, backstory, and campaign milestones.

*See [Getting Started](/getting-started) for access instructions.*" \
    "Player character hub — biographies, journals, and relationships." \
    "${token}"

  # Campaign hub
  create_page \
    "Campaign" \
    "campaign" \
    "# Campaign

Active story arcs, session records, and campaign milestones.

## Sessions

Session summaries will appear here as they are recorded.

## Timeline

See the [Campaign Timeline](/campaign/timeline) for major world events in chronological order.

## Active Arcs

Campaign arc summaries will appear here as the story develops." \
    "Campaign hub — sessions, timeline, and active story arcs." \
    "${token}"

  # Lore hub
  create_page \
    "Lore" \
    "lore" \
    "# Lore

The accumulated knowledge of the 167 Guild world.

## Categories

- [NPCs](/lore/npcs) — Allies, rivals, and recurring figures
- [Locations](/lore/locations) — Cities, dungeons, and landmarks
- [Organizations](/lore/organizations) — Guilds, houses, and institutions
- [Factions](/lore/factions) — Political and ideological powers
- [Items](/lore/items) — Significant artifacts and equipment" \
    "Lore index — NPCs, locations, factions, and world knowledge." \
    "${token}"

  # DM private notes
  create_page \
    "DM Notes" \
    "dm" \
    "# DM Notes

This section is restricted to the Dungeon Master and Platform Administrator.

## Purpose

Use this area for campaign planning notes, NPC secrets, unrevealed plot threads, and session preparation materials.

## Access

Access to this namespace is controlled by RBAC rules.
See **Administration → Groups** for current permission configuration." \
    "DM-only planning area — restricted to Dungeon Master and Administrator." \
    "${token}"
}

# --------------------------------------------------------------------------- #
# Main
# --------------------------------------------------------------------------- #
main() {
  check_prerequisites

  log_info "Authenticating with Wiki.js at ${WIKIJS_URL}..."
  local token
  token="$(get_token)"
  log_success "Authenticated."

  log_info "Seeding initial wiki content..."
  seed_content "${token}"
  log_success "Content seeding complete."

  echo ""
  echo "  ✓ Home page"
  echo "  ✓ Getting Started"
  echo "  ✓ World hub"
  echo "  ✓ Characters hub"
  echo "  ✓ Campaign hub"
  echo "  ✓ Lore hub"
  echo "  ✓ DM notes section"
  echo ""
  log_info "Run seed-groups.sql to create Dungeon Master, Player, and Viewer groups:"
  echo "  docker compose --env-file .env.production -f docker-compose.yml \\"
  echo "    -f deploy/production/docker-compose.production.yml \\"
  echo "    exec -T postgres psql -U \"\${POSTGRES_USER}\" -d \"\${POSTGRES_DB}\" \\"
  echo "    < scripts/bootstrap/seed-groups.sql"
}

main "$@"
