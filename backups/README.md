# Backups

This directory is the default output location for `scripts/backup/backup.sh`.

Each backup run creates a timestamped subdirectory:

```
backups/
└── YYYY-MM-DDTHH-MM-SS/
    ├── postgres.sql.gz
    ├── wikijs_data.tar.gz
    ├── config.tar.gz
    ├── .env.example
    └── manifest.txt
```

## ⚠️ Important

- Backup archives are excluded from version control via `backups/.gitignore`.
- Never commit backup artifacts — they may contain sensitive data.
- Store backups in a secure off-host location for disaster recovery.

## Usage

```bash
# Local env
bash scripts/backup/backup.sh

# Production env
bash scripts/backup/backup.sh .env.production
```

See [`docs/backup.md`](../docs/backup.md) for full backup + disaster recovery steps.
