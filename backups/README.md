# Backups

This directory is the default output location for `task backup`.

Each backup run creates a timestamped subdirectory:

```
backups/
└── YYYY-MM-DDTHH-MM-SS/
    ├── postgres.sql.gz
    ├── wikijs_data.tar.gz
    ├── config.tar.gz
    └── .env.example
```

## ⚠️ Important

- Backup archives are excluded from version control via `.gitignore`.
- Never commit backup archives to this repository — they may contain sensitive data.
- Store backups in a secure location separate from the repository.

## Usage

```bash
task backup
```

See [`docs/backup.md`](../docs/backup.md) for the full backup and restore documentation.
