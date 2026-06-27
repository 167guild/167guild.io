# 🪞 Reflector Sync — Repository Readiness Audit

**Date:** 2026-06-27
**Auditor:** Copilot (GitHub Copilot Coding Agent)
**Repository:** 167guild/167guild.io
**Target Release:** v0.1.0
**Audit Type:** Pre-production readiness review

---

## Executive Summary

The 167 Guild Wiki repository is a well-structured, specification-driven project that provisions a self-hosted Dungeons & Dragons knowledge portal using Wiki.js, PostgreSQL, and Caddy. The infrastructure is expressed through Docker Compose with a production overlay. The repository demonstrates strong discipline: all secrets are externalized, specifications precede implementation, and deployment is guarded by validation scripts.

The majority of Phase 0 and Phase 1 work is marked complete in `ROADMAP.md`. However, several areas remain incomplete or undocumented before a safe v0.1.0 production release. The most significant blockers are:

1. **Backup and restore scripts are stubs.** All four backup functions are commented-out TODOs. No data protection exists in the current codebase.
2. **Core Taskfile developer tasks are scaffolds.** `task init`, `task up`, `task down`, `task lint`, and `task format` all print TODO messages and perform no real work.
3. **Wiki.js is not configured to activate Google OAuth.** Environment variables are passed to the container, but Wiki.js 2.x does not automatically activate OAuth providers from environment variables. Manual in-UI configuration or a provider configuration YAML is required.
4. **`config/wikijs/config.yml` is a placeholder** with no actual Wiki.js configuration.
5. **`docs/architecture.md` is referenced in `README.md` but does not exist**, producing a broken documentation link.
6. **The GitHub Actions deploy workflow is a scaffold** that validates configuration but does not perform actual deployment.

Addressing these six issues is the minimum requirement before v0.1.0 can be considered production-ready.

---

## Strengths

The repository exhibits several practices worth recognizing:

- **Specification-driven development.** Every major component has a specification in `.github/specs/`. Specs guide GitHub issues, which guide pull requests. This produces a traceable change history.
- **Environment variable discipline.** Secrets are externalized. The `.env.example` and `.env.production.example` templates clearly document every required variable. The `validate-env.sh` script actively rejects placeholder values and unsafe configurations before deployment.
- **Defense-in-depth networking.** Only Caddy publishes host ports. Wiki.js and PostgreSQL communicate exclusively over the internal Docker network. This is correct and well-reasoned.
- **Health checks on every service.** Caddy, Wiki.js, and PostgreSQL all define health checks in `docker-compose.yml`. Services depend on one another via health conditions.
- **Authorization model is production-ready.** The RBAC design in `docs/authorization.md` is thorough, with namespace-level rules and an idempotent SQL seed script for bootstrapping groups.
- **Release automation is configured.** Release Please, Conventional Commits enforcement, and automated changelog generation are fully wired.
- **Design system is comprehensive.** Design tokens, CSS variables, typography, and component guidelines are all defined and organized.
- **Deployment documentation is detailed.** `deploy/README.md` covers prerequisites, DNS, environment management, rollback, health verification, and security hardening checklists.
- **Security headers are present.** The Caddyfile applies HSTS, X-Content-Type-Options, X-Frame-Options, and Permissions-Policy globally.

---

## Risks

The following risks are ordered by severity.

### Critical

| # | Risk | File(s) | Impact |
|---|------|---------|--------|
| C1 | Backup scripts are TODO stubs. No data is backed up in production. | `scripts/backup/backup.sh`, `scripts/restore/restore.sh` | Data loss on server failure with no recovery path. |
| C2 | Wiki.js Google OAuth is not activated. Env vars do not configure the provider automatically in Wiki.js 2.x. Manual in-UI setup or a provider YAML is required. | `config/wikijs/config.yml`, `docker-compose.yml` | Authentication will fail on first production boot. |

### High

| # | Risk | File(s) | Impact |
|---|------|---------|--------|
| H1 | `config/wikijs/config.yml` is a placeholder with no configuration. Wiki.js may not boot with its expected settings. | `config/wikijs/config.yml` | Unpredictable Wiki.js startup behavior. |
| H2 | GitHub Actions deploy workflow does not perform SSH deployment. Only validation runs. | `.github/workflows/deploy-production.yml` | No automated deployment path exists. Manual deploy is required. |
| H3 | `.env.production` is not explicitly excluded in `.gitignore`. The file is excluded by the `.env` pattern but this is implicit, not explicit. | `.gitignore` | Risk of accidentally committing production credentials if the `.env` pattern is ever modified. |
| H4 | Player ownership enforcement is not technical. All Players can write to `/characters/` and `/journals/`. The spec acknowledges this but it creates a trust-dependency. | `docs/authorization.md`, `scripts/bootstrap/seed-groups.sql` | Players can overwrite each other's pages without additional safeguards. |

### Medium

| # | Risk | File(s) | Impact |
|---|------|---------|--------|
| M1 | `docs/architecture.md` is referenced in `README.md` but does not exist. | `README.md` | Broken documentation link. New contributors receive a 404. |
| M2 | Taskfile developer tasks (`init`, `up`, `down`, `lint`, `format`) are placeholder stubs. Contributors cannot start a local development environment. | `Taskfile.yml` | Developer experience is broken for local development. |
| M3 | `scripts/deploy/` and `docker/` directories exist but contain only `.gitkeep`. They suggest planned functionality that has not arrived. | `scripts/deploy/.gitkeep`, `docker/.gitkeep` | Confuses new contributors about where deploy scripts and custom Docker files should live. |
| M4 | No log rotation or centralized logging strategy is documented. | `deploy/README.md`, `ROADMAP.md` | Log accumulation may exhaust disk in long-running production. |
| M5 | No monitoring or alerting is configured. | `ROADMAP.md` | Outages may go undetected. |
| M6 | Caddy health check runs `caddy validate` which tests configuration syntax, not service availability. | `docker-compose.yml` | A running but misconfigured Caddy may pass its own health check. |
| M7 | Wiki.js healthcheck uses `/healthz` but this endpoint may not be available on all Wiki.js 2.x versions. | `docker-compose.yml`, `deploy/scripts/health-check.sh` | Health check may fail silently or fall back inconsistently. |
| M8 | The `design/` directory contains prompts and templates but no pipeline. The `docs/context/prompt-generation.md` describes a planned architecture that is not implemented. | `design/`, `docs/context/prompt-generation.md` | The AI pipeline is architecture-only; no tooling exists. |

### Low

| # | Risk | File(s) | Impact |
|---|------|---------|--------|
| L1 | `SECURITY.md` contains only two sentences. It does not describe the security policy, threat model, or vulnerability reporting process. | `SECURITY.md` | Security reporters may not know how to disclose vulnerabilities. |
| L2 | Placeholder emails in `seed-groups.sql` and `docs/authorization.md` may be committed to production unchanged. | `scripts/bootstrap/seed-groups.sql`, `docs/authorization.md` | Wrong users receive DM-level or Player-level access. |
| L3 | `CHANGELOG.md` has a placeholder entry dated `2025-01-01` for `0.1.0`. This entry is fictional and will confuse users post-release. | `CHANGELOG.md` | Misleading release history. |
| L4 | `backups/.gitignore` presumably excludes backup files, but no retention policy is enforced. | `backups/.gitignore` | Backups could accumulate indefinitely once implemented. |
| L5 | No `SUPPORT.md` file exists. The contributing guidelines reference GitHub Discussions but there is no formal support policy. | (missing) | New users have no clear escalation path. |
| L6 | `CODE_OF_CONDUCT.md` exists but is not listed in the README community files table. | `README.md` | Community standards may be overlooked. |

---

## Missing Configuration

| Item | Where Expected | Current State |
|------|---------------|---------------|
| Wiki.js OAuth provider configuration | `config/wikijs/config.yml` | File is a placeholder comment |
| Wiki.js YAML `db:` block | `config/wikijs/config.yml` | Not present; DB config is via env vars only |
| Taskfile `task up` / `task down` implementation | `Taskfile.yml` | Echoes TODO |
| Taskfile `task init` implementation | `Taskfile.yml` | Echoes TODO |
| Taskfile `task lint` implementation | `Taskfile.yml` | Echoes TODO |
| Taskfile `task format` implementation | `Taskfile.yml` | Echoes TODO |
| Architecture documentation | `docs/architecture.md` | File does not exist |
| Backup automation | `scripts/backup/backup.sh` | All functions are TODO stubs |
| Restore automation | `scripts/restore/restore.sh` | All functions are TODO stubs |
| SSH deployment step | `.github/workflows/deploy-production.yml` | Scaffold comment only |
| SUPPORT.md | Repository root | Missing |

---

## Required Secrets

The following secrets must be provisioned before production deployment. None should ever be committed to source control.

| Secret | Variable | Example | Notes |
|--------|----------|---------|-------|
| PostgreSQL password | `POSTGRES_PASSWORD` | ≥ 32 random characters | Use a password manager or `openssl rand -base64 32` |
| Google OAuth Client ID | `GOOGLE_OAUTH_CLIENT_ID` | `1234567890-abc...apps.googleusercontent.com` | From Google Cloud Console |
| Google OAuth Client Secret | `GOOGLE_OAUTH_CLIENT_SECRET` | `GOCSPX-...` | From Google Cloud Console |
| GitHub Actions secret (optional) | `PRODUCTION_ENV_FILE` | Full contents of `.env.production` | Required only if using the Actions deploy workflow |

The following values are required but are not secrets:

| Variable | Value | Notes |
|----------|-------|-------|
| `DOMAIN` | `167guild.io` | Pre-configured in `deploy/examples/.env.production.example` |
| `EMAIL` | Admin's email address | Used for ACME TLS certificate notifications |
| `WIKI_BASE_URL` | `https://167guild.io` | Pre-configured in template |
| `GOOGLE_OAUTH_CALLBACK_URL` | `https://167guild.io/login/callback` | Pre-configured in template |

---

## Required Accounts

Before production deployment, the following accounts and services must be configured:

| Account / Service | Purpose | Required Before Deploy |
|---|---|---|
| **Google Cloud Project** | OAuth application for authentication | Yes |
| **Google OAuth Consent Screen** | Configures the login UI users see | Yes |
| **Google OAuth 2.0 Web Application Client** | Issues client ID and secret | Yes |
| **Domain Registrar** (for `167guild.io`) | Controls DNS records | Yes |
| **Production VM / VPS** | Ubuntu LTS host for Docker Compose deployment | Yes |
| **Email address** | ACME notification address for TLS cert lifecycle | Yes |
| **GitHub Repository Secrets** (optional) | Stores `PRODUCTION_ENV_FILE` for Actions workflow | Only if using Actions deploy |

---

## Deployment Checklist

A new engineer following this checklist should be able to deploy from scratch:

### Pre-deployment

- [ ] Provision Ubuntu LTS server with public IPv4 address
- [ ] Install Docker Engine and Docker Compose plugin on the server
- [ ] Install `task` (Taskfile) on the server
- [ ] Open inbound ports `80` and `443` on the server firewall
- [ ] Confirm outbound internet access for container pulls and TLS provisioning
- [ ] Clone repository on the server: `git clone https://github.com/167guild/167guild.io.git`

### DNS

- [ ] Create `A` record for `167guild.io` pointing to the server IPv4 address
- [ ] Optionally create `AAAA` record if IPv6 is available
- [ ] Optionally create `CNAME www` → `167guild.io`
- [ ] Confirm DNS propagation: `dig 167guild.io A`
- [ ] Lower TTL before cutover if migrating from another host

### Google Cloud

- [ ] Create or select a Google Cloud project
- [ ] Configure the OAuth consent screen (Application name: `167 Guild Wiki`; Authorized domain: `167guild.io`)
- [ ] Create an OAuth 2.0 Web Application client
- [ ] Add authorized JavaScript origin: `https://167guild.io`
- [ ] Add authorized redirect URI: `https://167guild.io/login/callback`
- [ ] Copy Client ID and Client Secret

### Environment File

- [ ] Copy template: `cp deploy/examples/.env.production.example .env.production`
- [ ] Set `EMAIL` to a real monitored email address
- [ ] Set `POSTGRES_PASSWORD` to a strong unique password (≥ 32 characters)
- [ ] Set `GOOGLE_OAUTH_CLIENT_ID` to the value from Google Cloud Console
- [ ] Set `GOOGLE_OAUTH_CLIENT_SECRET` to the value from Google Cloud Console
- [ ] Run validation: `bash deploy/scripts/validate-env.sh .env.production`

### Wiki.js OAuth Configuration

- [ ] Verify that `config/wikijs/config.yml` contains Google OAuth provider configuration, OR plan to configure OAuth manually through the Wiki.js Admin UI after first boot
- [ ] Document which configuration approach will be used (YAML vs. UI)

### Deployment

- [ ] Run: `task deploy:production`
- [ ] Confirm all containers start: `task status`
- [ ] Run health checks: `task health`
- [ ] Confirm HTTPS: `curl -I https://167guild.io`
- [ ] Confirm HTTP → HTTPS redirect: `curl -I http://167guild.io`

### Post-deployment

- [ ] Sign in with Google OAuth and confirm login flow works
- [ ] Run group seed script: `docker compose exec -T postgres psql -U wikijs -d wikidb < scripts/bootstrap/seed-groups.sql`
- [ ] Assign Alan (`szmyty@gmail.com`) to the `Administrators` group in Wiki.js Admin → Users
- [ ] Assign Dungeon Master to `Dungeon Master` group (replace placeholder email with real account)
- [ ] Assign Players to `Player` group (replace placeholder emails with real accounts)
- [ ] Verify `/dm/` namespace is inaccessible to Players and Viewers
- [ ] Verify Players can edit `/characters/` pages
- [ ] Validate backup workflow: `task backup`

---

## Production Checklist

This checklist confirms the deployment is hardened for production use:

### Networking

- [ ] Only Caddy binds ports 80 and 443
- [ ] PostgreSQL has no exposed host ports
- [ ] Wiki.js has no exposed host ports
- [ ] Docker `internal: true` network confirmed for wiki/postgres services

### TLS

- [ ] HTTPS resolves correctly for `167guild.io`
- [ ] HSTS header present in response
- [ ] Certificate auto-renewal confirmed (Caddy manages this automatically)
- [ ] `EMAIL` is set to a monitored mailbox for ACME notifications

### Authentication

- [ ] Google OAuth login flow tested end-to-end
- [ ] Callback URL matches exactly: `https://167guild.io/login/callback`
- [ ] Anonymous (Guest) Wiki.js group has no permissions

### Authorization

- [ ] `Administrators` group has unrestricted access
- [ ] `Dungeon Master` group has access to `/dm/` namespace
- [ ] `Player` group is denied `/dm/` namespace
- [ ] `Viewer` group is denied `/dm/` namespace
- [ ] Page rules confirmed in Wiki.js Admin → Groups

### Backups

- [ ] Backup scripts are implemented (currently stubs — see Risk C1)
- [ ] At least one manual backup has been successfully created
- [ ] Restore procedure has been tested on a clean environment
- [ ] Backup artifacts are stored outside the repository root

### Secrets

- [ ] `.env.production` is not tracked in Git
- [ ] No secrets appear in `git log` or `git diff`
- [ ] Google OAuth credentials are scoped to `167guild.io` only

---

## Recommendations

The following improvements are recommended before or shortly after v0.1.0:

### Immediate (before v0.1.0)

1. **Implement backup scripts.** The four TODO stubs in `backup.sh` must be implemented. PostgreSQL dumps via `pg_dump` and volume backups via `docker run + tar` are documented in the spec and the script comments. This is a critical data protection gap.

2. **Document or implement Wiki.js OAuth configuration.** Either add a Google OAuth provider block to `config/wikijs/config.yml` (Wiki.js supports YAML-based provider config), or explicitly document the required in-UI steps as part of the post-deployment checklist. Without this, authentication will not work on first boot.

3. **Create `docs/architecture.md`.** The `README.md` references this file. It should at minimum contain the architecture table already in `README.md` plus a service interaction diagram. A text-based ASCII diagram would suffice.

4. **Implement core Taskfile tasks.** `task up` and `task down` should invoke `docker compose up -d` and `docker compose down`. `task init` should copy `.env.example` to `.env` if it doesn't already exist. These are straightforward one-liners.

5. **Expand `SECURITY.md`.** Add: supported versions, vulnerability reporting instructions, expected response time, and what qualifies as in-scope (e.g., production OAuth credential exposure, data leaks).

6. **Add `SUPPORT.md`.** Document how users can get help: GitHub Discussions, filing issues, and who to contact for production incidents.

### Short-term (before v0.2.0)

7. **Add monitoring.** At minimum, configure Caddy's access log JSON output and document how to tail it. Consider Uptime Robot or a simple cron-based health check as a first alerting layer.

8. **Implement SSH deployment in the GitHub Actions workflow.** The `deploy-production.yml` workflow validates configuration but doesn't deploy. Wire in an SSH step using a deploy key stored in GitHub Actions secrets.

9. **Add log rotation.** Document or configure Docker's `json-file` log driver with `max-size` and `max-file` limits to prevent disk exhaustion.

10. **Remove or repurpose empty directories.** `scripts/deploy/` and `docker/` contain only `.gitkeep`. Either document their intended use, populate them, or remove them to avoid confusion.

11. **Add `.env.production` as an explicit `.gitignore` entry.** The current implicit exclusion via `.env` works but is fragile.

---

## Future Opportunities

The following opportunities align with the project's long-term vision as a reusable OSS template:

### Content

- Populate the world: characters, NPCs, locations, organizations, factions, sessions
- Implement missing wiki templates: Spell and Journal
- Implement sidebar navigation and cross-linking strategy

### AI Pipeline

- Implement the prompt generation pipeline architecture (currently documented, not implemented)
- Build context export pipeline
- Create artwork generation workflows for characters, NPCs, and banners

### Infrastructure

- Scheduled backups via cron or GitHub Actions
- Offsite backup storage (S3-compatible)
- Backup encryption (GPG)
- Backup retention policy
- Prometheus + Grafana + Loki observability stack

### Open Source Extraction (Phase 7)

- Audit and remove campaign-specific assets
- Generalize templates and configuration
- Package the Wiki.js custom theme as a standalone installable
- Package the prompt generation pipeline
- Create a demo world

### Platform

- Interactive world map
- Character relationship graph
- Timeline visualization
- Multi-campaign support
- AI-powered lore assistant with RAG

---

## Appendix A — Complete Environment Variable Inventory

| Variable | Purpose | Required | Secret | Example Value | Consumed By |
|---|---|---|---|---|---|
| `APP_ENV` | Application environment mode | Required | No | `production` | `wikijs` container, `validate-env.sh` |
| `PROJECT_NAME` | Docker Compose project name | Optional | No | `167guild-wiki` | `docker-compose.yml` |
| `DOMAIN` | Public hostname (no scheme or path) | Required | No | `167guild.io` | `caddy` container (Caddyfile), `validate-env.sh`, `health-check.sh` |
| `EMAIL` | ACME notification address for TLS lifecycle | Required | No | `ops@example.com` | `caddy` container (Caddyfile global options) |
| `WIKI_BASE_URL` | Public base URL for the wiki | Required | No | `https://167guild.io` | `wikijs` container |
| `WIKI_UPSTREAM` | Internal upstream address for Caddy | Optional | No | `wikijs:3000` | `caddy` container (Caddyfile snippet) |
| `POSTGRES_DB` | PostgreSQL database name | Required | No | `wikidb` | `postgres` container, `wikijs` container |
| `POSTGRES_USER` | PostgreSQL username | Required | No | `wikijs` | `postgres` container, `wikijs` container |
| `POSTGRES_PASSWORD` | PostgreSQL password | Required | **Yes** | (32+ random chars) | `postgres` container, `wikijs` container |
| `DB_HOST` | Database service hostname | Optional | No | `postgres` | `wikijs` container |
| `DB_PORT` | Database port | Optional | No | `5432` | `wikijs` container |
| `GOOGLE_OAUTH_CLIENT_ID` | Google OAuth application client ID | Required | **Yes** | `1234.apps.googleusercontent.com` | `wikijs` container |
| `GOOGLE_OAUTH_CLIENT_SECRET` | Google OAuth application client secret | Required | **Yes** | `GOCSPX-...` | `wikijs` container |
| `GOOGLE_OAUTH_CALLBACK_URL` | OAuth redirect URI | Required | No | `https://167guild.io/login/callback` | `wikijs` container, `validate-env.sh` |

---

## Appendix B — Required DNS Records

| Type | Name | Expected Value | Required | Purpose |
|---|---|---|---|---|
| `A` | `@` (apex) | Server IPv4 address | Yes | Routes `167guild.io` to the production server |
| `AAAA` | `@` (apex) | Server IPv6 address | Optional | IPv6 access if server supports it |
| `CNAME` | `www` | `167guild.io` | Optional | www alias for convenience |
| `CNAME` | `wiki` | `167guild.io` | Optional | Future-friendly alias if wiki moves to subdomain |

Note: if your DNS provider does not support CNAME flattening at the apex, keep only `A`/`AAAA` at the root and use `CNAME` only for subdomains.

---

## Appendix C — Required Google Cloud Resources

| Resource | Configuration | Required |
|---|---|---|
| Google Cloud Project | Any project with OAuth APIs enabled | Yes |
| OAuth Consent Screen | Application name: `167 Guild Wiki`; User type: Internal (recommended) or External with domain restriction to `167guild.io`; Authorized domain: `167guild.io` | Yes |
| OAuth 2.0 Client (Web Application) | Authorized JavaScript origin: `https://167guild.io`; Authorized redirect URI: `https://167guild.io/login/callback` | Yes |

---

## Related Audit Documents

| Document | Focus |
|---|---|
| [`audits/production/production-readiness.md`](production/production-readiness.md) | Deployment blockers and production hardening |
| [`audits/security/security-review.md`](security/security-review.md) | Secrets, permissions, authentication, and threat surface |
| [`audits/architecture/architecture-review.md`](architecture/architecture-review.md) | Service design, configuration, and architectural gaps |
| [`audits/developer-experience/dx-review.md`](developer-experience/dx-review.md) | Local development, tooling, and onboarding friction |
| [`audits/oss/oss-readiness.md`](oss/oss-readiness.md) | Open source extraction opportunities |
