# Backup Scripts

## Overview

This directory contains the backup automation scripts for the 167 Guild Wiki.

Backups capture all persistent application data required to restore the wiki onto a clean server.

---

## Scripts

| Script       | Description                          |
|--------------|--------------------------------------|
| `backup.sh`  | Main backup entrypoint (placeholder) |

---

## What Gets Backed Up

| Component             | Volume / Path       | Output File            |
|-----------------------|---------------------|------------------------|
| PostgreSQL database   | `postgres_data`     | `postgres.sql.gz`      |
| Wiki.js uploads/data  | `wikijs_data`       | `wikijs_data.tar.gz`   |
| Application config    | `config/`           | `config.tar.gz`        |
| Environment template  | `.env.example`      | `.env.example`         |

The live `.env` file is **never** included in backups.

---

## Usage

```bash
# Via Taskfile (recommended)
task backup

# Directly
./scripts/backup/backup.sh
```

Backup artifacts are written to `./backups/YYYY-MM-DDTHH-MM-SS/` relative to the repository root.

---

## Requirements

- Docker and Docker Compose installed and running
- The stack must be running before executing a backup
- A valid `.env` file in the repository root

---

## Current Status

The backup script is a **placeholder**. Individual backup functions are stubbed with `TODO` comments.

Implementation is deferred to future issues:

- [ ] Implement PostgreSQL backup (`pg_dump`)
- [ ] Implement Wiki.js data volume backup
- [ ] Implement configuration backup
- [ ] Add offsite upload (future issue)
- [ ] Add retention policy (future issue)
- [ ] Add checksum verification (future issue)
- [ ] Add backup encryption (future issue)
- [ ] Schedule automated backups (future issue)

---

## Docker Volumes

The following named Docker volumes must be included in any full backup:

| Volume          | Service    | Contents                            |
|-----------------|------------|-------------------------------------|
| `postgres_data` | `postgres` | All wiki data, users, permissions   |
| `wikijs_data`   | `wikijs`   | Uploads, application data           |
| `caddy_data`    | `caddy`    | TLS certificates (auto-renewed)     |
| `caddy_config`  | `caddy`    | Caddy runtime configuration         |

> **Note:** `caddy_data` and `caddy_config` contain TLS certificates that Caddy manages automatically. These are nice-to-have in backups but not strictly required for a restore since Caddy will re-provision certificates on first boot.
