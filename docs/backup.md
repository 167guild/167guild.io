# Backup & Restore

## Purpose

This runbook documents the production backup and restore workflow for the 167 Guild Wiki.

It covers:

- PostgreSQL backups
- Wiki.js data backups
- Configuration backups
- Restore order
- Disaster recovery expectations and verification

---

## Backup Artifacts

Each backup run creates `backups/YYYY-MM-DDTHH-MM-SS/` containing:

- `postgres.sql.gz`
- `wikijs_data.tar.gz`
- `config.tar.gz`
- `.env.example`
- `manifest.txt` (metadata + SHA-256 checksums)

The live `.env` / `.env.production` files are never included.

---

## How Backups Run

```bash
# Local-style env
bash scripts/backup/backup.sh

# Production env file
bash scripts/backup/backup.sh .env.production
```

Backup implementation details:

- PostgreSQL: `pg_dump` executed in the `postgres` container
- Wiki.js data: tar archive from the `wikijs_data` Docker volume
- Configuration: tar archive of `config/`, `deploy/production/`, and `deploy/scripts/`
- Manifest: checksum file generated with `sha256sum`

---

## Recommended Backup Schedule

For production:

- Daily backup (off-peak hours)
- Before every deployment
- Before any risky maintenance (schema/config changes)

Suggested automation command:

```bash
bash /path/to/repo/scripts/backup/backup.sh .env.production
```

---

## Restore Order (Critical)

Restore in this exact order:

1. Configuration (`config.tar.gz`)
2. Wiki.js data volume (`wikijs_data.tar.gz`)
3. PostgreSQL database (`postgres.sql.gz`)

This order is implemented by `scripts/restore/restore.sh`.

---

## Restore Procedure

```bash
# Stop services and restore from a backup directory
bash scripts/restore/restore.sh ./backups/YYYY-MM-DDTHH-MM-SS .env.production

# Bring the stack back up
# (task may not be installed everywhere, so docker compose is also valid)
docker compose --env-file .env.production -f docker-compose.yml -f deploy/production/docker-compose.production.yml up -d --remove-orphans
```

The restore script:

- validates required backup artifacts
- verifies checksums from `manifest.txt`
- stops the stack
- restores config + Wiki.js volume
- starts PostgreSQL and restores SQL dump

---

## Disaster Recovery (Total Server Loss)

If the production server is lost:

1. Provision a new Ubuntu LTS server with Docker + Docker Compose.
2. Clone this repository.
3. Recreate `.env.production` from secure secret storage.
4. Copy the latest backup directory to `backups/` on the new host.
5. Run `bash scripts/restore/restore.sh ./backups/<timestamp> .env.production`.
6. Start services.
7. Run health checks and functional verification.

Expected recovery impact:

- Application downtime during restore
- Data restored up to the timestamp of the selected backup

---

## Backup Verification

After each backup:

1. Confirm all expected files exist in the backup directory.
2. Confirm `manifest.txt` includes checksum entries.
3. Test restore periodically in a non-production environment.

After restore:

1. Run `bash deploy/scripts/health-check.sh .env.production`.
2. Verify key wiki pages/media.
3. Perform a Google OAuth login test.

---

## Backup Storage Guidance

Store backups in at least two places:

- primary copy on production host (short retention)
- secondary copy off-host/offsite (longer retention)

Do not commit backup artifacts to Git.

---

## Related Files

- `scripts/backup/backup.sh`
- `scripts/restore/restore.sh`
- `deploy/scripts/health-check.sh`
- `backups/README.md`
