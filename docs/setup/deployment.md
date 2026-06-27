# Deployment Runbook

1. Copy `deploy/examples/.env.production.example` to `.env.production`.
2. Replace placeholders with real production values.
3. Validate configuration:

```bash
bash deploy/scripts/validate-env.sh .env.production
docker compose --env-file .env.production -f docker-compose.yml -f deploy/production/docker-compose.production.yml config >/dev/null
```

4. Deploy:

```bash
task deploy:production
```

5. Verify:

```bash
task status
task health
task logs
```

Backup/restore automation is available via `scripts/backup/backup.sh` and `scripts/restore/restore.sh`.
