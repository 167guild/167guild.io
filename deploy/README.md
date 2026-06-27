# 🚀 Production Deployment

This directory defines the production deployment workflow for the 167 Guild Wiki.

The process is environment-driven and uses Docker Compose as the source of truth.

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

## Environment Setup

1. Copy the production template:

   ```bash
   cp deploy/examples/.env.production.example .env.production
   ```

2. Replace placeholders with real production values.

### Required Variables

- `DOMAIN`
- `EMAIL`
- `WIKI_BASE_URL`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `GOOGLE_OAUTH_CLIENT_ID`
- `GOOGLE_OAUTH_CLIENT_SECRET`
- `GOOGLE_OAUTH_CALLBACK_URL`

`deploy/scripts/validate-env.sh` fails fast with actionable errors if required values are missing or still placeholders.

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
   task restore
   ```

Persistent volumes are externalized in Docker volumes, so container rollback does not discard data.

## Verification Checklist

- [ ] Caddy container is running (`task status`)
- [ ] Wiki.js container is running (`task status`)
- [ ] PostgreSQL container is healthy (`task status`)
- [ ] Public endpoint responds through Caddy
- [ ] Wiki.js health endpoint responds
- [ ] Database readiness check succeeds
- [ ] Google OAuth login flow succeeds
- [ ] Latest backup exists and restore path is documented

## Health Verification Details

- **Caddy**: `curl -I https://$DOMAIN` should return a valid HTTP response.
- **Wiki.js**: `task health` checks `http://localhost:3000/healthz` inside the container.
- The `/healthz` endpoint is the same endpoint configured in this repository's Docker Compose healthcheck.
- **PostgreSQL**: `task health` runs `pg_isready`.
- **Authentication**: perform a test Google OAuth login in the deployed wiki.
- **Backups**: run `task backup` and confirm backup artifacts are created under `backups/`.

## GitHub Actions Scaffold

See `.github/workflows/deploy-production.yml` for an optional manual deployment scaffold.
It intentionally uses placeholders and does **not** configure production secrets.
