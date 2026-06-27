# Restore Scripts

## Overview

This directory contains the restore automation scripts for the 167 Guild Wiki.

Restore operations recover all persistent application data from a backup archive produced by `scripts/backup/backup.sh`.

---

## Scripts

| Script        | Description                           |
|---------------|---------------------------------------|
| `restore.sh`  | Main restore entrypoint (placeholder) |

---

## What Gets Restored

| Component             | Source File            | Target Volume / Path  |
|-----------------------|------------------------|-----------------------|
| PostgreSQL database   | `postgres.sql.gz`      | `postgres_data`       |
| Wiki.js uploads/data  | `wikijs_data.tar.gz`   | `wikijs_data`         |
| Application config    | `config.tar.gz`        | `config/`             |

---

## Usage

```bash
# Via Taskfile (recommended)
task restore

# Directly (specify the backup directory)
./scripts/restore/restore.sh ./backups/2025-01-01T00-00-00
```

---

## Requirements

- Docker and Docker Compose installed
- The stack should be **stopped** before restoring data
- A valid `.env` file in the repository root
- A backup archive directory produced by `task backup`

---

## High-Level Restore Procedure

1. Stop the running stack:

   ```bash
   task down
   ```

2. Run the restore script with the target backup directory:

   ```bash
   task restore
   ```

3. Start the stack:

   ```bash
   task up
   ```

4. Verify the wiki is accessible and data is intact.

---

## Current Status

The restore script is a **placeholder**. Individual restore functions are stubbed with `TODO` comments.

Implementation is deferred to future issues:

- [ ] Implement PostgreSQL restore (`psql`)
- [ ] Implement Wiki.js data volume restore
- [ ] Implement configuration restore
- [ ] Add checksum verification before restore (future issue)
- [ ] Add dry-run mode (future issue)
- [ ] Add interactive confirmation prompt (future issue)

---

## Warnings

- Restore is a **destructive operation**. Existing data will be overwritten.
- Always confirm the backup directory before proceeding.
- Test restore procedures in a non-production environment before relying on them in production.
