# Production Readiness Review

**Date:** 2026-06-27
**Scope:** Deployment workflow, environment configuration, service configuration, operational procedures
**Target:** v0.1.0 production release at `167guild.io`

---

## Summary

The production infrastructure is largely well-designed. The Docker Compose stack, validation script, health check script, and deployment documentation are all present and functional. However, several gaps prevent a confident first production deployment.

---

## Blockers

The following items must be resolved before v0.1.0 is considered production-ready.

### BLOCKER-1: Backup scripts are stubs

**File:** `scripts/backup/backup.sh`

All four backup functions are commented-out TODO stubs. Running `task backup` creates a timestamped directory but writes nothing into it.

```
backup_postgres      → TODO
backup_wikijs_data   → TODO
backup_config        → TODO
backup_env_template  → TODO
```

**Impact:** If the production server fails, all wiki data (pages, users, permissions, uploads) is unrecoverable.

**Resolution:** Implement each function using the code documented in the script comments. The PostgreSQL dump is one `pg_dump` command. The volume backups use `docker run` with a temporary Alpine container. The configuration backup is a `tar` archive.

---

### BLOCKER-2: Wiki.js OAuth provider is not configured

**File:** `config/wikijs/config.yml`

The file currently contains only:
```yaml
# Placeholder Wiki.js configuration.
# Application-specific configuration is intentionally deferred.
```

Wiki.js 2.x does not automatically activate OAuth providers from container environment variables (`GOOGLE_OAUTH_CLIENT_ID`, etc.). These environment variables are made available to the container but Wiki.js must be instructed—either through its YAML configuration or through the Admin UI—to use Google as an authentication strategy.

**Impact:** On first boot, the Wiki.js authentication page will not offer Google login. Users will be unable to sign in.

**Resolution (Option A — YAML configuration):** Add a Google OAuth provider block to `config/wikijs/config.yml`. Example:
```yaml
authentication:
  defaultStrategy: google
  strategies:
    - id: google
      isEnabled: true
      displayName: Google
      selfRegistration: false
      config:
        clientId: ${GOOGLE_OAUTH_CLIENT_ID}
        clientSecret: ${GOOGLE_OAUTH_CLIENT_SECRET}
        callbackURL: ${GOOGLE_OAUTH_CALLBACK_URL}
```

**Resolution (Option B — UI configuration):** Document that after first boot, the administrator must manually navigate to Admin → Authentication → Google in the Wiki.js Admin panel and configure the provider using the credentials from `.env.production`. Add this step explicitly to the deployment checklist.

Both options are valid. Option A is more reproducible. Either choice must be documented and verified before v0.1.0.

---

## Warnings

The following items are not deployment blockers but represent meaningful risks.

### WARN-1: GitHub Actions deploy workflow is a scaffold

**File:** `.github/workflows/deploy-production.yml`

The workflow validates the environment file and compose config, then exits with:
```
echo "Scaffold only: wire SSH/runner deployment in a follow-up issue."
```

**Impact:** There is no automated deployment path. All deployments must be performed manually on the production server.

**Resolution:** Wire an SSH deployment step. Store the server's private key as a GitHub Actions secret. Use a step such as:
```yaml
- name: Deploy via SSH
  uses: appleboy/ssh-action@v1
  with:
    host: ${{ secrets.PRODUCTION_HOST }}
    username: ${{ secrets.PRODUCTION_USER }}
    key: ${{ secrets.PRODUCTION_SSH_KEY }}
    script: |
      cd /opt/167guild.io
      git pull origin main
      task deploy:production
```

### WARN-2: Production compose overlay is minimal

**File:** `deploy/production/docker-compose.production.yml`

The production overlay currently sets only `APP_ENV: production`. It does not configure:
- Log driver limits (to prevent disk exhaustion)
- Memory limits per service
- CPU limits per service
- Container labels for operational tooling

**Resolution:** Add resource limits and log driver configuration to the production overlay:
```yaml
services:
  wikijs:
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
    deploy:
      resources:
        limits:
          memory: 512m
  postgres:
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
  caddy:
    logging:
      driver: json-file
      options:
        max-size: "10m"
        max-file: "3"
```

### WARN-3: Caddy health check tests config syntax, not runtime health

**File:** `docker-compose.yml`

The Caddy health check runs:
```
caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile
```

This validates the configuration file, not whether the Caddy process is serving requests. A running Caddy that has failed to provision a TLS certificate would pass this health check.

**Resolution:** Replace with an HTTP request to `localhost:80`:
```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -q --spider http://localhost:80 || exit 1"]
  interval: 30s
  timeout: 5s
  retries: 3
```

### WARN-4: No log rotation is configured

By default, Docker uses the `json-file` log driver with no size limits. On a long-running production server, container logs may exhaust available disk.

**Resolution:** Configure log limits in the production overlay (see WARN-2) or configure a default Docker daemon log driver in `/etc/docker/daemon.json` on the production server.

### WARN-5: Restore script is also a stub

**File:** `scripts/restore/restore.sh`

Like the backup script, all restore functions are TODO stubs. There is no validated restore procedure.

**Resolution:** Implement restore functions alongside backup functions. The restore procedure must be tested against a real backup archive before v0.1.0 is released.

---

## Deployment Workflow Assessment

The overall deployment workflow is sound. The `task deploy:production` command:

1. Checks that `.env.production` exists
2. Validates the environment with `validate-env.sh`
3. Validates the Compose configuration
4. Runs `docker compose up -d --build --remove-orphans`

This is a good baseline. The main gap is the absence of a post-deploy verification step in the task itself. Consider adding:

```yaml
'deploy:production':
  cmds:
    - bash deploy/scripts/validate-env.sh {{.PRODUCTION_ENV_FILE}}
    - '{{.COMPOSE_PRODUCTION_CMD}} config >/dev/null'
    - '{{.COMPOSE_PRODUCTION_CMD}} up -d --build --remove-orphans'
    - bash deploy/scripts/health-check.sh {{.PRODUCTION_ENV_FILE}}
```

---

## Environment Validation Assessment

`deploy/scripts/validate-env.sh` is well-implemented. It:

- Checks that all required variables are present
- Rejects placeholder values
- Enforces `APP_ENV=production`
- Validates `DOMAIN` format (no scheme, no IP, no invalid suffixes)
- Validates HTTPS-only URLs
- Validates callback URL consistency

One gap: the script does not validate that `EMAIL` is a syntactically valid email address (only that it is not the placeholder `admin@example.com`). A malformed email address will cause Caddy's ACME provisioning to fail silently.

---

## Production Server Prerequisites

| Prerequisite | Notes |
|---|---|
| Ubuntu LTS | 22.04 or 24.04 LTS recommended |
| Docker Engine ≥ 24 | From Docker's official APT repository, not the OS-bundled version |
| Docker Compose plugin ≥ 2.20 | The Compose plugin (`docker compose`) not the legacy binary (`docker-compose`) |
| `task` (Taskfile) | `https://taskfile.dev` |
| `git` | For cloning and pulling the repository |
| Open ports 80 and 443 | Inbound; all other ports closed |
| Outbound internet access | For container pulls from `ghcr.io` and `docker.io`, and ACME provisioning |
| Persistent block storage | Recommended ≥ 10 GB for volumes and backup archives |
