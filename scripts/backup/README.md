# Backup Scripts

## Script

- `backup.sh` — creates a timestamped full backup directory.

## Usage

```bash
# Default env file (.env)
bash scripts/backup/backup.sh

# Explicit env file (recommended for production)
bash scripts/backup/backup.sh .env.production
```

## Output

`backups/YYYY-MM-DDTHH-MM-SS/`

- `postgres.sql.gz`
- `wikijs_data.tar.gz`
- `config.tar.gz`
- `.env.example`
- `manifest.txt`

## Notes

- `.env` / `.env.production` are never archived.
- `manifest.txt` includes SHA-256 checksums for restore-time verification.
- Backups are ignored by Git in `backups/.gitignore`.
