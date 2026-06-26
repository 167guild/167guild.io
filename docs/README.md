# Documentation

## Caddy Reverse Proxy

### Purpose

Caddy is the public entrypoint for the stack. It terminates HTTPS, redirects HTTP to HTTPS, applies baseline security headers, enables compression, and reverse-proxies requests to Wiki.js.

### Directory Layout

```text
config/
└── caddy/
    └── Caddyfile
```

`/config/caddy/Caddyfile` contains production-oriented reverse proxy behavior using environment-driven placeholders.

### Configuration Philosophy

- Keep configuration environment-driven (`DOMAIN`, `EMAIL`, `WIKI_UPSTREAM`).
- Prefer reusable Caddy snippets for easy extension.
- Keep security defaults in the proxy layer while keeping app and database concerns separate.

---

## PostgreSQL Database

### Purpose

PostgreSQL is the persistent datastore for the Wiki.js application. It stores wiki pages, users, permissions, page metadata, and all application configuration.

### Directory Layout

```text
volumes:
└── postgres_data    # named Docker volume — survives container recreation
```

Data is stored in the named Docker volume `postgres_data` mapped to `/var/lib/postgresql/data` inside the container. Because this is a named volume (not a bind-mount), data persists across `docker compose down` and container recreation.

### Environment Variables

| Variable            | Description                                              | Example        |
|---------------------|----------------------------------------------------------|----------------|
| `POSTGRES_DB`       | Name of the database created on first container startup  | `wikidb`       |
| `POSTGRES_USER`     | Database superuser created on first container startup    | `wikijs`       |
| `POSTGRES_PASSWORD` | Password for the database superuser — **required**       | *(secret)*     |

Configure these values in `.env` (copied from `.env.example`). Never commit real credentials.

### Persistence Notes

- All wiki data lives in the `postgres_data` named volume.
- Running `docker compose down` does **not** remove the volume; data is preserved.
- To wipe the database intentionally, use `docker compose down -v` (destructive).
- Backup the volume contents before any destructive operation.

### Network and Security

- PostgreSQL is attached **only** to the `internal` Docker network.
- No ports are published to the host or the public internet.
- Only the `wikijs` service (and other services on the same internal network) can reach the database.
- Never expose PostgreSQL ports (5432) publicly.

### Health Check

The service uses `pg_isready` to confirm the database accepts connections before dependent services start:

```yaml
healthcheck:
  test: ["CMD-SHELL", "pg_isready -U $$POSTGRES_USER -d $$POSTGRES_DB"]
  interval: 10s
  timeout: 5s
  retries: 5
```

`wikijs` declares `condition: service_healthy` on `postgres`, so it will not start until the health check passes.
