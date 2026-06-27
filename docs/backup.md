# Backup & Restore

## Purpose

This document describes the backup and restore strategy for the 167 Guild Wiki.

The goal is to ensure all persistent application data can be recovered onto a clean server using a reproducible, scripted process.

---

## Philosophy

- Backups are scripted and reproducible — not manual.
- All backup operations are version-controlled alongside the application.
- Restore procedures must work on a clean server with only Docker, Compose, and a valid `.env` file.
- Secrets are never committed to source control or included in backup archives.
- Future automation (scheduling, cloud upload, encryption) builds on this foundation.

---

## What to Back Up

### Docker Volumes

The following named Docker volumes contain all persistent application data:

| Volume          | Service    | Contents                                    | Priority |
|-----------------|------------|---------------------------------------------|----------|
| `postgres_data` | `postgres` | All wiki data, users, pages, permissions    | Critical |
| `wikijs_data`   | `wikijs`   | Uploaded media and application data         | Critical |
| `caddy_data`    | `caddy`    | TLS certificates (auto-renewed by Caddy)    | Optional |
| `caddy_config`  | `caddy`    | Caddy runtime configuration cache           | Optional |

> `caddy_data` and `caddy_config` are managed automatically by Caddy and will be reprovisioned on first boot. Back them up as a convenience, not a requirement.

### Configuration

| Path             | Contents                              | Notes                     |
|------------------|---------------------------------------|---------------------------|
| `config/caddy/`  | Caddyfile reverse proxy configuration | Version-controlled        |
| `config/wikijs/` | Wiki.js application configuration     | Version-controlled        |
| `.env.example`   | Environment variable template         | Template only, no secrets |

Configuration files in `config/` are already tracked in Git, but are included in backup archives for convenience when restoring onto a clean server.

### What NOT to Back Up

- `.env` — contains production secrets; must be secured separately
- `.git/` — managed by version control
- Container images — pulled on demand from registries
- Build artifacts and temporary files

---

## Backup Strategy

### Method

| Component            | Tool                          | Output                  |
|----------------------|-------------------------------|-------------------------|
| PostgreSQL database  | `pg_dump` via `docker compose exec` | `postgres.sql.gz`  |
| Wiki.js data volume  | `docker run` + `tar`          | `wikijs_data.tar.gz`    |
| Configuration        | `tar`                         | `config.tar.gz`         |
| Environment template | `cp`                          | `.env.example`          |

### Output Directory

Each backup run creates a timestamped directory:

```
backups/
└── YYYY-MM-DDTHH-MM-SS/
    ├── postgres.sql.gz
    ├── wikijs_data.tar.gz
    ├── config.tar.gz
    └── .env.example
```

### Running a Backup

```bash
task backup
```

---

## Restore Procedure

### Prerequisites

Before restoring:

1. Install Docker and Docker Compose on the target server.
2. Clone the repository.
3. Copy `.env.example` to `.env` and fill in all required values.
4. Stop the running stack if it is already running: `task down`

### Steps

```bash
# Restore all persistent data from a backup archive
task restore BACKUP_DIR=./backups/2025-01-01T00-00-00

# Start the stack
task up
```

### Restore Scope

| Component            | Restore Method                             |
|----------------------|--------------------------------------------|
| PostgreSQL database  | `psql` import from `postgres.sql.gz`       |
| Wiki.js data         | `tar` extract into `wikijs_data` volume    |
| Configuration        | `tar` extract into `config/`               |

---

## Current Status

Backup and restore scripts are **placeholder implementations**.

Individual backup and restore functions are stubbed and documented for future implementation.

---

## Future Work

The following capabilities are planned for future issues:

| Capability                  | Status   |
|-----------------------------|----------|
| PostgreSQL `pg_dump` backup | Planned  |
| Wiki.js data volume backup  | Planned  |
| Configuration backup        | Planned  |
| Scheduled backups (cron)    | Future   |
| Offsite object storage      | Future   |
| Backup encryption (GPG)     | Future   |
| Retention policy            | Future   |
| Checksum verification       | Future   |
| Restore dry-run mode        | Future   |

---

## Related Files

| File                          | Description                          |
|-------------------------------|--------------------------------------|
| `scripts/backup/backup.sh`    | Main backup entrypoint               |
| `scripts/backup/README.md`    | Backup scripts documentation         |
| `scripts/restore/restore.sh`  | Main restore entrypoint              |
| `scripts/restore/README.md`   | Restore scripts documentation        |
| `.github/specs/backups.spec.md` | Backup & restore specification     |
