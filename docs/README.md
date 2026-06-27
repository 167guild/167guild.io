# Documentation

## Backup & Restore

See [`backup.md`](backup.md) for the complete backup and restore strategy, including:

- Backup philosophy and design principles
- Docker volumes that must be backed up
- Backup and restore procedures
- Current implementation status and future work

---

## Authorization

See [`authorization.md`](authorization.md) for the complete permission model, including:

- Role hierarchy (Platform Administrator, Dungeon Master, Player, Viewer)
- Group responsibilities and permission matrix
- Content namespace definitions
- Placeholder account documentation
- Onboarding process for each role
- Bootstrap instructions for the initial group seed

---

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

---

## Wiki.js Application

### Purpose

Wiki.js is the wiki engine and content management layer for the 167 Guild knowledge portal. It manages wiki pages, user authentication, authorization, media uploads, version history, and search.

### Responsibilities

- Content management and page rendering
- User authentication (Google OAuth)
- Authorization and group-based permissions
- Media and file uploads
- Full-text search
- Version history

### Directory Layout

```text
config/
└── wikijs/
    └── config.yml       # Application-level configuration overrides

volumes:
└── wikijs_data          # named Docker volume — persists uploads and application data
```

Application configuration overrides live in `config/wikijs/config.yml`, mounted read-only into the container at `/wiki/config`. The named volume `wikijs_data` is mounted at `/wiki/data` and persists across container recreation.

### Environment Variables

| Variable        | Description                                            | Example                    |
|-----------------|--------------------------------------------------------|----------------------------|
| `APP_ENV`       | Application environment (`development` or `production`)| `development`              |
| `WIKI_BASE_URL` | Public base URL for the wiki                           | `http://localhost:3000`    |
| `DB_HOST`       | Hostname of the PostgreSQL service                     | `postgres`                 |
| `DB_PORT`       | Port of the PostgreSQL service                         | `5432`                     |
| `POSTGRES_DB`   | Database name (shared with PostgreSQL service)         | `wikidb`                   |
| `POSTGRES_USER` | Database username (shared with PostgreSQL service)     | `wikijs`                   |
| `POSTGRES_PASSWORD` | Database password — **required**                   | *(secret)*                 |
| `GOOGLE_OAUTH_CLIENT_ID` | Google OAuth client ID                         | `your-google-client-id`    |
| `GOOGLE_OAUTH_CLIENT_SECRET` | Google OAuth client secret                 | *(secret)*                 |
| `GOOGLE_OAUTH_CALLBACK_URL` | Google OAuth redirect URI used by Wiki.js    | `http://localhost:3000/login/callback` |

Configure these values in `.env` (copied from `.env.example`). Never commit real credentials.

### Google OAuth Setup

Use Google OAuth as the Wiki.js authentication provider for identity only.

1. In Google Cloud Console, create (or select) a project.
2. Configure the OAuth consent screen.
3. Create an OAuth 2.0 Client ID for type **Web application**.
4. Add the redirect URI from `GOOGLE_OAUTH_CALLBACK_URL`.
5. Copy the generated client ID and client secret into `.env`:
   - `GOOGLE_OAUTH_CLIENT_ID`
   - `GOOGLE_OAUTH_CLIENT_SECRET`
   - `GOOGLE_OAUTH_CALLBACK_URL`
6. In Wiki.js Admin → Authentication, configure the Google strategy using these values, enable:
   - Auto-create users on first sign in
   - Auto-update existing users
7. Save and enable the Google provider.

#### Redirect URI Requirements

- The Google OAuth redirect URI must exactly match `GOOGLE_OAUTH_CALLBACK_URL`.
- Local development should typically use `http://localhost:3000/login/callback`.
- Production should use your public HTTPS wiki URL, for example:
  `https://wiki.example.com/login/callback`.
- Use HTTPS in production and avoid non-TLS callback URLs.

#### Local Development Considerations

- Keep local OAuth credentials in `.env` only.
- Use separate OAuth credentials for local and production environments.
- Never commit real OAuth client secrets.

#### Production Considerations

- Set `GOOGLE_OAUTH_CLIENT_ID`, `GOOGLE_OAUTH_CLIENT_SECRET`, and `GOOGLE_OAUTH_CALLBACK_URL` through a secure secret-management workflow.
- Restrict authorized redirect URIs in Google Cloud Console to production domains you control.
- Rotate OAuth secrets if they are exposed.

#### Expected Login Flow

1. User visits wiki.
2. User selects "Sign in with Google".
3. Google authenticates the user.
4. User returns to Wiki.js.
5. Wiki.js creates or updates the account.

### Startup Sequence

Wiki.js waits for PostgreSQL to pass its health check before starting:

```
postgres (healthy)
    └─→ wikijs (starts, runs health check)
            └─→ caddy (healthy wikijs required before proxying)
```

The service declares `condition: service_healthy` on `postgres` so it will not attempt to connect to the database until PostgreSQL is fully ready.

### Health Check

The service polls the `/healthz` endpoint to confirm the application is accepting requests:

```yaml
healthcheck:
  test: ["CMD-SHELL", "wget -q --spider http://localhost:3000/healthz || exit 1"]
  interval: 30s
  timeout: 10s
  retries: 5
  start_period: 60s
```

`caddy` declares `condition: service_healthy` on `wikijs`, so it will not proxy traffic until Wiki.js reports ready.

### Database Relationship

- Wiki.js connects to PostgreSQL using `DB_TYPE: postgres`.
- The connection hostname is the Docker service name `postgres`, reachable only on the `internal` network.
- All wiki pages, users, permissions, metadata, and configuration are stored in PostgreSQL.
- Wiki.js does **not** interact with the database at the network edge — only on the internal Docker network.

### Reverse Proxy Relationship

- Caddy receives all public HTTPS traffic and reverse-proxies it to Wiki.js at `WIKI_UPSTREAM` (default: `wikijs:3000`).
- Wiki.js is **not** published directly to the host — it is only reachable through Caddy or on the internal network.
- No ports are published from the `wikijs` container to the host.

### Persistence Notes

- Wiki uploads and application data live in the `wikijs_data` named volume.
- Running `docker compose down` does **not** remove the volume; data is preserved.
- To wipe the application data intentionally, use `docker compose down -v` (destructive).

### Network and Security

- Wiki.js is attached **only** to the `internal` Docker network.
- No ports are published to the host or the public internet.
- Public access is exclusively through Caddy on ports 80 and 443.
- Future authentication providers (e.g., Google OAuth) can be added as environment variables without restructuring the stack.
