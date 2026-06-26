# 🏗️ Infrastructure Specification

## Purpose

This document defines the infrastructure responsible for hosting, deploying, securing, and operating the 167 Guild Wiki.

The infrastructure should be reproducible, simple to understand, secure by default, and easily extensible as the project grows.

---

# Design Principles

- Infrastructure as Code whenever practical.
- Local-first development.
- Production mirrors local development.
- Immutable infrastructure where possible.
- Security by default.
- Small operational footprint.
- Simple deployment process.

---

# Initial Technology Stack

## Reverse Proxy

- Caddy

Responsibilities:

- Automatic HTTPS
- Reverse proxy
- HTTP → HTTPS redirects
- Security headers
- Compression

---

## Wiki Engine

- Wiki.js

Responsibilities:

- Content management
- Authentication
- Authorization
- Search
- Version history
- Media management

---

## Database

- PostgreSQL

Responsibilities:

- Persistent wiki data
- Users
- Permissions
- Page metadata
- Configuration

---

## Runtime

- Docker Compose

Responsibilities:

- Local development
- Production deployment
- Internal networking
- Persistent volumes

---

## Authentication Provider

- Google OAuth

Responsibilities:

- User authentication
- Identity management

Authorization is handled by Wiki.js groups and permissions.

---

# Persistent Storage

Persistent volumes should exist for:

- PostgreSQL
- Uploaded media
- Wiki assets

No application data should exist only inside containers.

---

# Networking

Public Internet

↓

Caddy

↓

Wiki.js

↓

PostgreSQL

PostgreSQL should never be publicly exposed.

Only Caddy should listen on ports:

- 80
- 443

---

# Environment Variables

All configuration should originate from:

.env

or

.env.production

Never hardcode secrets.

Never commit production credentials.

---

# Backups

Backups should include:

- PostgreSQL database
- Uploaded media
- Configuration

Backups should be restorable onto a clean server.

---

# Deployment Targets

Initial deployment:

- Single Linux VM

Future deployment options:

- Kubernetes
- Pulumi
- Terraform
- Helm
- S3-compatible storage
- Managed PostgreSQL

These should not complicate the first production release.

---

# Observability

Future versions may include:

- Prometheus
- Grafana
- Loki

Logging should remain simple until operational complexity requires additional tooling.

---

# Operational Goals

Deploying the entire platform should eventually require only a few commands.

Examples:

- task setup
- task up
- task deploy
- task backup
- task restore

The infrastructure should minimize operational burden while remaining production-ready.
