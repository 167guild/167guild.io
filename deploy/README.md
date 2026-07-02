# 🚀 Production Deployment

This directory defines the production deployment workflow for the 167 Guild Wiki.

The process is environment-driven and uses Docker Compose as the source of truth.

The initial public production target is the apex domain `167guild.io`.

## Directory Layout

```text
deploy/
├── README.md
├── production/
│   └── docker-compose.production.yml
├── scripts/
│   ├── health-check.sh
│   └── validate-env.sh
└── examples/
    └── .env.production.example
```

## Prerequisites

- Ubuntu LTS server (single VM target)
- Docker Engine + Docker Compose plugin installed
- Repository cloned on server
- `task` installed (recommended)
- A configured `.env.production` file (never commit)

## Server Requirements

- Inbound ports `80` and `443` open to the server
- Sufficient persistent storage for:
  - PostgreSQL data
  - Wiki.js uploads/assets
  - Caddy state/config
- Outbound internet access for container pulls and TLS provisioning

## Domain Ownership and Deployment Assumptions

- The production deployment assumes the 167 Guild team controls the registrar and DNS zone for `167guild.io`.
- The initial hosting target is one Ubuntu LTS virtual machine with a public IPv4 address. IPv6 is optional but recommended if available.
- Caddy is the only public-facing service and should be the only service bound to ports `80` and `443`.
- PostgreSQL must remain private on the internal Docker network.
- Use placeholders for values that are not yet known, such as the ACME notification email address, server IP addresses, and Google OAuth client credentials.

## Expected DNS Records

Create DNS records that direct the public domain to the production server before running the first HTTPS deployment.

| Type | Name | Value | Required | Notes |
| --- | --- | --- | --- | --- |
| `A` | `@` | `YOUR_SERVER_IPV4` | Yes | Primary apex record for `167guild.io`. |
| `AAAA` | `@` | `YOUR_SERVER_IPV6` | Optional | Add only if the server is reachable over IPv6. |
| `CNAME` | `www` | `167guild.io` | Optional | Convenience DNS alias if `www` will be supported later. |
| `CNAME` | `wiki` | `167guild.io` | Optional | Future-friendly DNS alias if the wiki is moved to a subdomain later. |

If your DNS provider does not allow `CNAME` records at the apex, keep the apex on `A`/`AAAA` records and use aliases only for subdomains.

## Environment Setup

1. Copy the production template:

   ```bash
   cp deploy/examples/.env.production.example .env.production
   ```

2. Replace placeholders with real production values.

### Environment Management Philosophy

- Keep local development in `.env` copied from `.env.example`.
- Keep production configuration in `.env.production` copied from `deploy/examples/.env.production.example`.
- Commit templates only; never commit populated environment files.
- Treat the environment files as the source of truth for domain, database, and OAuth configuration so production stays fully environment-driven.

### Wiki.js Configuration Strategy (v0.1.0)

Production uses a hybrid strategy:

- **Environment variables** provide runtime settings and OAuth secrets (`.env.production`).
- **Wiki.js Admin UI** is the source of truth for enabling Google auth strategy, first administrator bootstrap, and RBAC assignments.

This is intentional because Wiki.js persists provider enablement, group memberships, and page rules in PostgreSQL after first boot.

### Required Variables

- `DOMAIN`
- `EMAIL`
- `WIKI_BASE_URL`
- `WIKI_UPSTREAM`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `DB_HOST`
- `DB_PORT`
- `GOOGLE_OAUTH_CLIENT_ID`
- `GOOGLE_OAUTH_CLIENT_SECRET`
- `GOOGLE_OAUTH_CALLBACK_URL`

### Production Domain Values

The production template is already wired for the primary public domain:

- `DOMAIN=167guild.io`
- `WIKI_BASE_URL=https://167guild.io`
- `GOOGLE_OAUTH_CALLBACK_URL=https://167guild.io/login/callback`

Replace only the remaining placeholders (email address, database password, and OAuth credentials) before deployment.

### Caddy and Reverse Proxy Configuration

- `config/caddy/Caddyfile` stays generic and reads `DOMAIN`, `EMAIL`, and `WIKI_UPSTREAM` from the environment.
- In production, Caddy should terminate TLS for `167guild.io`, redirect HTTP to HTTPS automatically, and proxy traffic to `wikijs:3000`.
- `WIKI_UPSTREAM` should remain on the internal Docker network so Wiki.js is not exposed directly to the internet.
- If the public domain ever changes, update `.env.production`, DNS, and Google OAuth callback settings together.

### Google OAuth Callback URLs

Configure the Google OAuth client as a **Web application** and authorize the exact production callback URL:

- Authorized JavaScript origin: `https://167guild.io`
- `https://167guild.io/login/callback`

If additional domains or subdomains are introduced later, add each exact callback URL explicitly in Google Cloud Console.

`deploy/scripts/validate-env.sh` fails fast with actionable errors if required values are missing or still placeholders.

## First Boot and Administrator Bootstrap

After the first successful `task deploy:production`:

1. Open `https://167guild.io` and complete the Wiki.js setup wizard.
2. Create an emergency admin account for break-glass access.
3. In Wiki.js Admin, configure and enable Google auth using:
   - `GOOGLE_OAUTH_CLIENT_ID`
   - `GOOGLE_OAUTH_CLIENT_SECRET`
   - `GOOGLE_OAUTH_CALLBACK_URL`
4. Sign in with `szmyty@gmail.com` through Google.
5. Assign `szmyty@gmail.com` to the built-in **Administrators** group.
6. Verify `szmyty@gmail.com` can access **Administration**.

Platform Administrator responsibilities:

- Own authentication configuration.
- Own user/group assignments and RBAC reviews.
- Own operational maintenance and recovery tasks.

## Group Bootstrap and Onboarding

Seed custom groups after first boot initializes Wiki.js schema:

```bash
docker compose exec -T postgres psql \
  -U "${POSTGRES_USER}" \
  -d "${POSTGRES_DB}" \
  < scripts/bootstrap/seed-groups.sql
```

Initial role assignment targets:

- **Platform Administrator**: `szmyty@gmail.com`
- **Dungeon Master**: placeholder DM account listed in `docs/authorization.md#placeholder-accounts` (replace with final DM email)
- **Players**: Alan (Starwhisper), Kevin, Christian, and Tom using accounts listed in `docs/authorization.md#placeholder-accounts`

Dungeon Master responsibilities:

- Manage hidden `/dm/` planning content.
- Maintain lore and campaign materials.
- Review and curate player-submitted content.

## HTTPS and SSL Lifecycle

- Caddy provisions and renews certificates automatically after `167guild.io` resolves to the production server and ports `80` and `443` are reachable.
- The ACME account email is supplied through `EMAIL`; replace the example placeholder with a real monitored mailbox before the first production deployment.
- Certificates and ACME state are stored in the `caddy_data` volume, while runtime config is cached in `caddy_config`.
- On first deploy, expect certificate issuance to happen during Caddy startup; repeated restarts should reuse stored state unless volumes are removed.

## DNS Propagation Considerations

- DNS changes may take time to propagate based on provider TTLs and resolver caches.
- Do not treat an immediate TLS failure as an application failure until you confirm `167guild.io` resolves to the correct server from the deployment host and from an external resolver.
- If DNS has not propagated yet, `deploy/scripts/health-check.sh` may skip the public HTTPS check for the domain.
- Lower DNS TTL values ahead of cutover when possible to reduce propagation delay during the first production switch.

## Deployment Lifecycle

From the repository root:

```bash
git pull
./guild deploy
```

`guild deploy` handles the complete remote deployment lifecycle automatically:

1. Connects to the production VM via `gcloud compute ssh`.
2. Creates `/opt/167guild.io` and clones the repository if not present (first-run bootstrap).
3. Synchronizes the repository (`git fetch`, `git checkout main`, `git pull --ff-only`) on all subsequent runs.
4. Uploads `.env.production` from local if not already present on the remote.
5. Executes `task deploy:production` on the remote VM (validates env, builds/recreates containers).
6. Runs `task health` on the remote VM for post-deploy health checks.
7. Prints a deployment summary.

No manual SSH session is required for standard production deployments.

`task deploy` and `task deploy:production` remain as stable entrypoints for running the deployment directly on the server (e.g., from a GitHub Actions workflow or an active SSH session).

## Bootstrap vs Runtime Lifecycle

Deployment operates in two distinct phases.

### Bootstrap Phase

On first deployment Wiki.js initializes PostgreSQL and launches the setup wizard before the application becomes fully operational. During this phase Caddy must be able to start and proxy the setup wizard so it is reachable externally.

```text
PostgreSQL starts

↓

Wiki.js starts (setup wizard running)

↓

Caddy starts (proxies setup wizard)

↓

Administrator completes setup wizard
```

Caddy declares `condition: service_started` on `wikijs` so it starts as soon as the Wiki.js container is running, without waiting for the full health check to pass. This allows the setup wizard to be externally accessible on first deployment.

### Runtime Phase

After the administrator completes setup, Wiki.js becomes fully operational and its health check passes on every subsequent start.

```text
PostgreSQL healthy

↓

Wiki.js healthy

↓

Caddy starts
```

Runtime health checks remain active on all services. Docker will mark Wiki.js as unhealthy if the application stops responding after setup is complete.

## Reset Workflow

`guild reset` safely removes all project containers, networks, and volumes on the production VM while preserving the Git repository and `.env.production`.

```bash
guild reset
```

This is useful when:

- recovering from a failed first deployment
- clearing state before a clean redeploy
- removing all application data for a fresh start

The equivalent Taskfile command (run directly on the server):

```bash
task deploy:reset
```

## Redeploy Workflow

`guild redeploy` performs a reset followed by a clean deployment in a single step:

```bash
guild redeploy
```

Workflow:

```text
guild reset

↓

guild deploy
```

The equivalent Taskfile command (run directly on the server):

```bash
task deploy:redeploy
```

Use `guild redeploy` for first deployments where the previous state may be inconsistent, or when recovering from a broken stack.

## Upgrade Procedure

1. Pull latest source.
2. Review release notes and `.env.production` changes.
3. Run deployment:

   ```bash
   task deploy:production
   ```

4. Run health checks:

   ```bash
   task health
   ```

## Rollback Strategy

If deployment fails:

1. Revert to previous known-good commit.
2. Redeploy previous commit with the same `.env.production`.
3. Restore data if needed with existing restore workflow:

   ```bash
   bash scripts/restore/restore.sh ./backups/YYYY-MM-DDTHH-MM-SS .env.production
   ```

Persistent volumes are externalized in Docker volumes, so container rollback does not discard data.

## Backup and Disaster Recovery

- Backup command: `bash scripts/backup/backup.sh .env.production`
- Restore command: `bash scripts/restore/restore.sh ./backups/<timestamp> .env.production`
- Restore order: configuration → Wiki.js data volume → PostgreSQL
- Backup manifest checksums are verified automatically during restore

Recommended production cadence:

- Daily scheduled backup
- Pre-deploy backup
- Additional backup before risky maintenance

For full disaster recovery flow, see `docs/backup.md`.

## Production Logging and Rotation

Production services use Docker `json-file` logging with rotation:

- `max-size=10m`
- `max-file=5`

Configured in `deploy/production/docker-compose.production.yml` for:

- `caddy`
- `wikijs`
- `postgres`

View logs with:

```bash
guild logs             # tail all services
guild logs caddy       # tail caddy only
guild logs wikijs      # tail wikijs only
guild logs postgres    # tail postgres only
```

## Container Version Pinning Strategy

Production uses fixed image tags in `deploy/production/docker-compose.production.yml`:

- `caddy:2.10.2-alpine`
- `ghcr.io/requarks/wiki:2.5.306`
- `postgres:16.9-alpine`

Version updates should be explicit and reviewed in pull requests to keep deployments reproducible.

## Security Hardening Checklist

- [ ] Exposed ports reviewed: only Caddy publishes host ports (`80`, `443`)
- [ ] Docker networking reviewed: Wiki.js and PostgreSQL are private on the internal network
- [ ] Restart policies reviewed: all production services use `unless-stopped`
- [ ] Health checks reviewed for Caddy, Wiki.js, and PostgreSQL
- [ ] Environment handling reviewed: `.env.production` is required and validated before deploy
- [ ] Secrets handling reviewed: production credentials are never committed and placeholders are rejected
- [ ] Backup and restore procedures reviewed and tested end-to-end
- [ ] Authentication flow reviewed: Google OAuth callback URL is exact and HTTPS
- [ ] Role configuration reviewed in Wiki.js (Administrators, Dungeon Master, Player, Viewer)

## Release Checklist

- [ ] Domain ownership and DNS zone access are confirmed for `167guild.io`
- [ ] Apex `A` record for `167guild.io` points to the production server
- [ ] Optional `AAAA`/alias records are configured if they will be used
- [ ] `.env.production` is created from `deploy/examples/.env.production.example`
- [ ] Placeholder values are replaced for `EMAIL`, `POSTGRES_PASSWORD`, `GOOGLE_OAUTH_CLIENT_ID`, and `GOOGLE_OAUTH_CLIENT_SECRET`
- [ ] Google OAuth client is configured with `https://167guild.io/login/callback`
- [ ] Caddy container is running (`guild status`)
- [ ] Wiki.js container is running (`guild status`)
- [ ] PostgreSQL container is healthy (`guild status`)
- [ ] Caddy endpoint responds over HTTP and HTTPS (`guild health`)
- [ ] Wiki.js startup and health endpoint checks succeed (`guild health`)
- [ ] PostgreSQL readiness check succeeds (`guild health`)
- [ ] Google OAuth login flow succeeds in browser
- [ ] Google OAuth failure path is tested (`redirect_uri_mismatch` and disabled strategy checks)
- [ ] Platform Administrator bootstrap is verified for `szmyty@gmail.com`
- [ ] Dungeon Master bootstrap is verified for the account listed in `docs/authorization.md#placeholder-accounts`
- [ ] Player bootstrap is verified for Alan (Starwhisper), Kevin, Christian, and Tom accounts from `docs/authorization.md#placeholder-accounts`
- [ ] Group membership is verified for Administrators, Dungeon Master, Player, and Viewer
- [ ] Namespace permissions are verified (`/dm/`, `/characters/`, `/journals/`, `/lore/`)
- [ ] First content pages are created and validated for expected role visibility
- [ ] Backup/restore workflow is validated against the current runbook scope and documented
- [ ] Wiki.js role permissions are validated for Administrators, Dungeon Master, Player, and Viewer

## Health Verification Details

- **Caddy**: `curl -I https://$DOMAIN` should return a valid HTTP response.
- **Wiki.js**: `guild health` checks `http://localhost:3000/healthz` inside the container and falls back to `/` if needed.
- The primary `/healthz` endpoint matches this repository's Docker Compose healthcheck.
- **PostgreSQL**: `guild health` runs `pg_isready`.
- **Authentication**: perform a test Google OAuth login in the deployed wiki.
- **Groups/RBAC**: verify `Administrators`, `Dungeon Master`, `Player`, and `Viewer` exist and contain expected users.
- **Namespaces**:
  - `Administrators`: full access everywhere.
  - `Dungeon Master`: read/write including `/dm/`.
  - `Player`: no access to `/dm/`; write access under `/characters/` and `/journals/`.
  - `Viewer`: read-only access to non-DM namespaces.
- **First content creation**: publish at least one page in `/lore/`, `/characters/`, `/journals/`, and `/dm/` and verify visibility by role.
- **Troubleshooting**:
  - Google button missing: strategy not enabled in Wiki.js Admin.
  - OAuth callback error: Google redirect URI does not exactly match `.env.production`.
  - Access denied after login: user not assigned to the expected group.
- **Backups**: verify backup artifact and restore validation by running a restore drill in non-production.

## v0.1.0 Production Deployment Record

Date: 2026-06-28

- [x] Production VM baseline verified (Docker Engine, Docker Compose, Task, Git, required OS packages)
- [x] Production `.env.production` validated with `bash deploy/scripts/validate-env.sh .env.production`
- [x] Google OAuth configured (client, secret, origins, redirect URI, consent screen)
- [x] DNS cutover completed for `167guild.io` with successful HTTPS certificate issuance
- [x] Production stack deployed with `task deploy:production` (Caddy, Wiki.js, PostgreSQL healthy)
- [x] Authentication verified for Platform Administrator, Dungeon Master, and Player accounts
- [x] Authorization verified for Administrators, Dungeon Master, Player, and Viewer permissions
- [x] Backup workflow executed and restore drill completed
- [x] Health checks passed with `task health`
- [x] First production release tagged as `v0.1.0`

### Manual Steps Captured for Future Automation

- Wiki.js initial setup wizard completion and emergency admin bootstrap
- First-login group assignment/verification in Wiki.js Admin
- Google OAuth provider enablement/validation in Wiki.js Admin
- Post-deploy role-based namespace verification (`/dm/`, `/characters/`, `/journals/`, `/lore/`)
- Final release sign-off checklist and GitHub Release confirmation

## Remaining Assumptions and Risks

- Initial production release assumes a single Ubuntu LTS VM and Docker Compose runtime; high-availability failover is out of scope for this cut.
- Role assignment still requires manual verification in Wiki.js Admin after first OAuth sign-in for each user.

## GitHub Actions Deployment

The deployment workflow is defined in `.github/workflows/deploy-production.yml`.

### Triggers

- **Manual** (`workflow_dispatch`): Trigger a deployment from the GitHub Actions UI. An optional `ref` input allows deploying a specific branch or tag (default: `main`).
- **Automated** (`release` event): Automatically deploys the tagged release commit when a GitHub Release is published.

### Required Secrets

Configure these in the `production` environment under **Settings → Environments → production**:

| Secret | Description |
|---|---|
| `PRODUCTION_HOST` | Production server hostname or IP |
| `PRODUCTION_USER` | SSH username (e.g. `ubuntu`) |
| `PRODUCTION_SSH_KEY` | SSH private key for the deployment user |

Application secrets remain on the server in `.env.production` and are not managed by GitHub.

### How It Works

The workflow SSHes into the production server and runs:

```bash
git fetch --tags origin
git checkout <ref>
git pull origin <ref> --ff-only   # for branches
task deploy:production             # validate → build → deploy
task health                        # post-deploy health checks
```

### Manual Deployment via GitHub Actions

1. Go to **Actions → Deploy Production** in the repository.
2. Click **Run workflow**.
3. Optionally specify a branch or tag (default: `main`).
4. Click **Run workflow** to confirm.

### Setup

See `docs/setup/github-secrets.md` for SSH key setup instructions and full GitHub repository configuration requirements.
