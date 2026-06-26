# 🏰 Architecture Spec

## System Overview

167 Guild Wiki is a self-hosted wiki stack deployed behind Caddy with automatic HTTPS.

The initial architecture uses:

- Wiki.js as the wiki engine.
- PostgreSQL as the primary database.
- Caddy as the reverse proxy and TLS terminator.
- Docker Compose as the initial runtime.
- Google OAuth as the primary authentication provider.
- GitHub as the source of truth for infrastructure and operational configuration.

## High-Level Flow

1. User visits `https://167guild.io` or `https://wiki.167guild.io`.
2. DNS resolves to the production VM.
3. Caddy receives the request and terminates TLS.
4. Caddy proxies traffic to Wiki.js on the internal Docker network.
5. Wiki.js handles authentication, page rendering, permissions, and content operations.
6. Wiki.js reads and writes metadata/content state to PostgreSQL.
7. Uploaded assets are stored in persistent Docker volumes.
8. Backups export PostgreSQL and persistent file volumes.

## Core Components

### Caddy

Responsibilities:

- Public HTTPS entrypoint.
- Automatic TLS certificate management.
- Reverse proxy to Wiki.js.
- HTTP to HTTPS redirects.
- Security headers where practical.

### Wiki.js

Responsibilities:

- Wiki UI.
- Page editing.
- Page history.
- Media uploads.
- Search.
- User/group management.
- Authentication integration.
- Role-based access control.

### PostgreSQL

Responsibilities:

- Wiki.js database.
- Users.
- Groups.
- Permissions.
- Pages.
- Metadata.
- Configuration.

### Docker Compose

Responsibilities:

- Local and production orchestration for v1.
- Named volumes for persistence.
- Internal Docker networking.
- Simple operations through Taskfile commands.

## Future Architecture Options

Future versions may migrate to:

- Kubernetes.
- Helm charts.
- Pulumi or Terraform-managed infrastructure.
- S3-compatible object storage for media.
- External managed PostgreSQL.
- Observability stack with Prometheus, Grafana, and Loki.

These are intentionally deferred until the simple deployment is stable.
