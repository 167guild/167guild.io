# 💾 Backup & Restore Specification

## Purpose

This document defines the backup and restore strategy for the 167 Guild Wiki.

Backups must protect all persistent application data and make recovery onto a clean server straightforward and reproducible.

---

## Design Principles

- Backups are reproducible and scripted — no manual database dumps.
- All backup operations are documented and version-controlled.
- Restore procedures are tested and documented.
- Secrets are never included in backups committed to source control.
- Environment templates (excluding values) may be archived alongside backups.
- Future automation builds on this foundation without requiring structural changes.

---

## What to Back Up

### PostgreSQL Database

- Named Docker volume: `postgres_data`
- Backup method: `pg_dump` via `docker compose exec`
- Output format: compressed SQL dump (`.sql.gz`)
- Scope: full database dump of `POSTGRES_DB`

### Wiki.js Uploads & Application Data

- Named Docker volume: `wikijs_data`
- Backup method: `docker run` with volume mount + `tar` archive
- Output format: compressed tarball (`.tar.gz`)
- Scope: entire `/wiki/data` directory

### Configuration

- Directory: `config/`
- Backup method: `tar` archive of the `config/` tree
- Output format: compressed tarball (`.tar.gz`)
- Scope: Caddy and Wiki.js configuration files (no secrets)

### Environment Templates

- File: `.env.example`
- Backup method: copy alongside other backup artifacts
- Scope: template only — never the live `.env` file

---

## What NOT to Back Up

- `.env` (contains production secrets)
- `.git/` (tracked by version control)
- `node_modules/` or other build artifacts
- Container images (pulled on demand)

---

## Backup Storage

Initial implementation stores backups locally on the host server.

Future implementations may include:

- Offsite object storage (S3-compatible)
- Encrypted backup archives
- Remote replication

---

## Retention Policy (Future)

Retention policies are deferred to a future issue.

Planned approach:

- Keep daily backups for 7 days
- Keep weekly backups for 4 weeks
- Keep monthly backups for 12 months

---

## Scheduling (Future)

Scheduled backups are deferred to a future issue.

Planned approach: system cron or external scheduler invoking `task backup`.

---

## Restore Philosophy

Restores must be reproducible on a clean server with only:

1. Docker and Docker Compose installed
2. A valid `.env` file
3. A backup archive from `task backup`

---

## Restore Scope

| Component          | Restore Method                                      |
|--------------------|-----------------------------------------------------|
| PostgreSQL         | `psql` restore from `.sql.gz` dump                  |
| Wiki.js data       | Extract `.tar.gz` into named Docker volume          |
| Configuration      | Extract `config/` tarball into repository root      |

---

## Integrity Verification (Future)

Integrity verification is deferred to a future issue.

Planned approach:

- SHA-256 checksum files alongside each backup artifact
- Automated verification step before restore

---

## Encryption (Future)

Backup encryption is deferred to a future issue.

Planned approach: GPG symmetric encryption for backup archives at rest and in transit.

---

## Directory Layout

```text
scripts/
├── backup/
│   ├── backup.sh       # Main backup entrypoint (placeholder)
│   └── README.md       # Backup documentation
└── restore/
    ├── restore.sh      # Main restore entrypoint (placeholder)
    └── README.md       # Restore documentation
```

---

## Taskfile Integration

Backup and restore operations are exposed as Taskfile tasks:

```bash
task backup    # Run full backup
task restore   # Run full restore
```

These tasks delegate to the scripts in `scripts/backup/` and `scripts/restore/`.
