# Architecture Review

**Date:** 2026-06-27
**Scope:** Service design, container configuration, configuration management, infrastructure patterns
**Target:** v0.1.0

---

## Summary

The architecture is well-suited for the initial deployment goal: a single-VM, self-hosted wiki with automatic HTTPS. The choice of Docker Compose over Kubernetes is appropriate and consistent with the project's guiding principle to avoid over-engineering before the first deployment is validated.

This review identifies gaps in configuration completeness and notes where architectural decisions may need to be revisited as the project scales.

---

## Service Architecture

### Overview

```
Internet
    │
    ▼
 Caddy (ports 80/443)
    │    (edge network)
    ▼
Wiki.js (port 3000)
    │    (internal network)
    ▼
PostgreSQL (port 5432)
```

This is correct. The network isolation is well-implemented.

### Network Assessment

| Network | Services | Type | Assessment |
|---|---|---|---|
| `edge` | Caddy | `bridge` | ✅ Correct — only the proxy is on the public network |
| `internal` | Caddy, Wiki.js, PostgreSQL | `bridge`, `internal: true` | ✅ Correct — internal traffic only, no external routing |

One observation: Caddy is on both the `edge` and `internal` networks. This is correct — Caddy must reach Wiki.js on the internal network to reverse-proxy requests.

---

## Container Configuration

### Caddy

**Image:** `caddy:2-alpine`
**Health check:** `caddy validate --config /etc/caddy/Caddyfile --adapter caddyfile`

**Gap — ARCH-1:** The health check validates configuration syntax, not service availability. A Caddy process that is running but has failed to obtain a TLS certificate or is not accepting connections would still pass this health check. Consider replacing with an HTTP probe.

**Gap — ARCH-2:** The Caddyfile is mounted read-only (`./config/caddy/Caddyfile:/etc/caddy/Caddyfile:ro`). This is correct. However, if the Caddyfile needs to be updated, a container restart is required. Document this operational requirement.

**Gap — ARCH-3:** Caddy is configured to proxy all traffic to `{$WIKI_UPSTREAM}`. There is no routing for a future health endpoint, status page, or administrative path separation. For v0.1.0 this is acceptable.

### Wiki.js

**Image:** `ghcr.io/requarks/wiki:2`
**Health check:** `wget -q --spider http://localhost:3000/healthz || exit 1`

**Gap — ARCH-4:** The image tag is `:2`, which pulls the latest 2.x release. This is mutable — a new patch release could change behavior between deployments. Pin to a specific version (e.g., `ghcr.io/requarks/wiki:2.5.303`) in the production overlay for reproducible deployments.

**Gap — ARCH-5:** `config/wikijs/config.yml` is mounted into the container at `/wiki/config:ro` but the file is a placeholder. Wiki.js may ignore it, fall back to defaults, or fail to start depending on what it expects. This must be resolved before v0.1.0.

**Gap — ARCH-6:** OAuth environment variables (`GOOGLE_OAUTH_CLIENT_ID`, etc.) are passed to the container but Wiki.js 2.x does not automatically activate OAuth providers from these variables. They must be configured through the Admin UI or a provider configuration in the YAML config. This is the most significant architectural gap.

**Gap — ARCH-7:** `wikijs_data` volume is mounted at `/wiki/data`. Wiki.js also writes to its database (PostgreSQL). The distinction between what lives in the volume vs. the database is not documented. Backup coverage should explicitly address both.

### PostgreSQL

**Image:** `postgres:16-alpine`
**Health check:** `pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB`

**Gap — ARCH-8:** Image tag is `:16-alpine`. This is a major version pin, which is appropriate. However, the minor version is floating. For strict reproducibility, pin to a specific digest or minor version in the production overlay.

**Gap — ARCH-9:** No `postgres.conf` customization is present. For a wiki with light traffic, defaults are acceptable. For future scaling, `max_connections`, `shared_buffers`, and `wal_level` may need tuning.

---

## Configuration Management

### Wiki.js YAML Configuration

**File:** `config/wikijs/config.yml`

Current content:
```yaml
# Placeholder Wiki.js configuration.
# Application-specific configuration is intentionally deferred.
```

Wiki.js supports a `config.yml` for database connection, authentication strategies, logging, and other settings. The database connection is currently provided entirely through environment variables, which Wiki.js reads by default. However, authentication provider configuration is not automatically activated from environment variables alone.

**Required for v0.1.0:** At minimum, a Google OAuth provider configuration block must be added, OR the deployment checklist must explicitly document the required in-UI configuration steps.

### Caddyfile

**File:** `config/caddy/Caddyfile`

The Caddyfile is clean and well-structured. Global options, reusable snippets, and the main site block are clearly separated. Environment variable substitution is used correctly (`{$DOMAIN}`, `{$EMAIL}`, `{$WIKI_UPSTREAM}`).

One consideration: the Caddyfile does not configure a `www.167guild.io` → `167guild.io` redirect. If a `www` DNS record is added later, visitors to `www.167guild.io` will not be redirected. This is low priority but worth noting for when the DNS record is created.

---

## Volumes and Persistence

| Volume | Service | Contents | Backup Priority |
|---|---|---|---|
| `postgres_data` | PostgreSQL | All wiki data, pages, users, permissions | Critical |
| `wikijs_data` | Wiki.js | Uploaded media, application data | Critical |
| `caddy_data` | Caddy | TLS certificates, ACME state | Optional (auto-renewed) |
| `caddy_config` | Caddy | Runtime configuration cache | Optional (regenerated) |

All volumes are named Docker volumes, which is correct. They persist across container restarts and rebuilds. They are not tied to a host path, which simplifies deployment but requires explicit backup procedures.

**Gap — ARCH-10:** `caddy_data` contains TLS certificates. While Caddy will re-provision certificates automatically, including it in backups avoids a brief downtime on restore (re-provisioning requires DNS to resolve correctly and Let's Encrypt rate limits to not be exceeded). Consider including it in the backup strategy.

---

## Docker Compose Production Overlay

**File:** `deploy/production/docker-compose.production.yml`

Current content:
```yaml
services:
  wikijs:
    environment:
      APP_ENV: production
```

This overlay is minimal. It sets `APP_ENV: production` on the Wiki.js container. No other production-specific configuration is applied.

**Recommended additions:**

- Log driver limits (WARN-2 in production review)
- Container resource limits
- Pinned image digests for reproducibility
- Any production-specific Wiki.js configuration overrides

---

## Specifications vs. Implementation Alignment

| Specification | Implementation Status | Notes |
|---|---|---|
| `infrastructure.spec.md` | Mostly implemented | Wiki.js config missing |
| `architecture.spec.md` | Mostly implemented | Config file placeholder |
| `deployment.spec.md` | Mostly implemented | SSH step missing from workflow |
| `authentication.spec.md` | Partially implemented | OAuth env vars present, provider not configured |
| `authorization.spec.md` | Implemented | Seed script and docs complete |
| `backups.spec.md` | Partially implemented | Spec is complete, scripts are stubs |
| `design-system.spec.md` | Implemented | Tokens, CSS, and components defined |
| `content-model.spec.md` | Partially implemented | Templates created, content not populated |
| `versioning.spec.md` | Implemented | Release Please fully configured |
| `permissions.spec.md` | Implemented | Authorization docs and seed script complete |

---

## Architecture Spec Gap: `wiki.167guild.io`

**File:** `.github/specs/architecture.spec.md`

The architecture spec states:
> User visits `https://167guild.io` or `https://wiki.167guild.io`.

However, the Caddyfile only configures `{$DOMAIN}` (which resolves to `167guild.io`). There is no configuration for `wiki.167guild.io`. The DNS table in `deploy/README.md` lists `wiki` as an optional future alias, but the architecture spec presents it as a current entry point.

**Resolution:** Either remove `https://wiki.167guild.io` from the architecture spec's login flow, or add it to the Caddyfile as a second site block (or redirect to apex). Clarify the spec to reflect the v0.1.0 reality.

---

## Future Architecture Readiness

The current architecture makes the following future transitions straightforward:

| Future Path | Readiness |
|---|---|
| Kubernetes | Docker Compose volumes and networking will need to be translated to PVCs and Services. The spec acknowledges this. |
| External managed PostgreSQL | DB credentials are already externalized. Replacing the PostgreSQL container with an external endpoint requires only changing `DB_HOST`, `DB_PORT`, and credentials. |
| S3-compatible media storage | Wiki.js supports S3 storage. This would require adding `STORAGE_*` config to the Wiki.js configuration YAML. |
| Observability stack | Caddy already logs in JSON format to stdout. Adding a log shipper (Promtail, Filebeat) is straightforward. |
| Multi-domain support | Caddyfile uses environment variable substitution; adding new domains requires only Caddyfile updates and redeployment. |
