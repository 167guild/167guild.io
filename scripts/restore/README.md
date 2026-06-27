# Restore Scripts

## Script

- `restore.sh` — restores a full backup directory.

## Usage

```bash
# Restore from backup directory with default env file (.env)
bash scripts/restore/restore.sh ./backups/YYYY-MM-DDTHH-MM-SS

# Restore with explicit production env
bash scripts/restore/restore.sh ./backups/YYYY-MM-DDTHH-MM-SS .env.production
```

## Restore Order

1. Configuration (`config.tar.gz`)
2. Wiki.js data volume (`wikijs_data.tar.gz`)
3. PostgreSQL (`postgres.sql.gz`)

## Safety Checks

The script verifies:

- required artifacts exist
- checksums in `manifest.txt` are valid
- Docker volumes exist

Restore is destructive and overwrites existing wiki data.
