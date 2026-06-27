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

- `https://167guild.io/login/callback`

If additional domains or subdomains are introduced later, add each exact callback URL explicitly in Google Cloud Console.

`deploy/scripts/validate-env.sh` fails fast with actionable errors if required values are missing or still placeholders.

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
task deploy:production
```

`task deploy` is kept as a stable top-level entrypoint and currently delegates to `deploy:production`.

This performs:

1. Environment validation
2. Compose validation
3. Build/recreate containers with production overrides
4. Post-deploy runtime health checks (`task health`)

Useful operations:

```bash
task status
task logs
task restart
task stop
task health
```

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
task logs
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
- [ ] Caddy container is running (`task status`)
- [ ] Wiki.js container is running (`task status`)
- [ ] PostgreSQL container is healthy (`task status`)
- [ ] Caddy endpoint responds over HTTP and HTTPS (`task health`)
- [ ] Wiki.js startup and health endpoint checks succeed (`task health`)
- [ ] PostgreSQL readiness check succeeds (`task health`)
- [ ] Google OAuth login flow succeeds in browser
- [ ] Backup/restore workflow is validated against the current runbook scope and documented
- [ ] Wiki.js role permissions are validated for Administrators, Dungeon Master, Player, and Viewer

## Health Verification Details

- **Caddy**: `curl -I https://$DOMAIN` should return a valid HTTP response.
- **Wiki.js**: `task health` checks `http://localhost:3000/healthz` inside the container and falls back to `/` if needed.
- The primary `/healthz` endpoint matches this repository's Docker Compose healthcheck.
- **PostgreSQL**: `task health` runs `pg_isready`.
- **Authentication**: perform a test Google OAuth login in the deployed wiki.
- **Backups**: verify backup artifact and restore validation by running a restore drill in non-production.

## Remaining Assumptions and Risks

- Initial production release assumes a single Ubuntu LTS VM and Docker Compose runtime; high-availability failover is out of scope for this cut.
- Role assignment still requires manual verification in Wiki.js Admin after first OAuth sign-in for each user.

## GitHub Actions Scaffold

See `.github/workflows/deploy-production.yml` for an optional manual deployment scaffold.
It intentionally uses placeholders and does **not** configure production secrets.
