# 🚀 Deployment Specification

## Purpose

This document defines how the 167 Guild Wiki is deployed from source code to a production environment.

Deployment should be simple, reproducible, secure, and require minimal operational effort.

---

# Deployment Philosophy

- One repository.
- One deployment process.
- Infrastructure is reproducible.
- Configuration is externalized.
- Production should closely mirror local development.

---

# Deployment Environment

Initial deployment target:

- Single Linux virtual machine

Operating System:

- Ubuntu LTS

Runtime:

- Docker Engine
- Docker Compose

---

# Deployment Pipeline

Developer

↓

GitHub Repository

↓

GitHub Actions (future)

↓

Production Server

↓

Docker Compose

↓

Caddy

↓

Wiki.js

↓

PostgreSQL

---

# Deployment Components

## Docker Compose

Responsible for:

- Container lifecycle
- Networking
- Persistent volumes
- Service startup order

---

## Caddy

Responsible for:

- HTTPS
- Reverse proxy
- Automatic certificate management
- Compression
- HTTP redirects

---

## Wiki.js

Responsible for:

- Wiki application
- Authentication
- Authorization
- Content management

---

## PostgreSQL

Responsible for:

- Persistent application data

---

# DNS

Production domain:

167guild.io

Optional subdomains:

- wiki.167guild.io
- admin.167guild.io (future)

DNS should point directly to the production server.

---

# Environment Configuration

Configuration should originate from:

.env.production

Examples include:

- database credentials
- OAuth secrets
- domain configuration

Environment files must never be committed.

---

# Deployment Workflow

Typical deployment:

1. Pull latest source.
2. Validate configuration.
3. Build containers if necessary.
4. Restart services.
5. Verify application health.
6. Verify HTTPS.
7. Verify authentication.

---

# Rollback

Deployment should support fast rollback.

Rollback should preserve:

- Database
- Uploaded media
- Configuration

Application containers should be replaceable without data loss.

---

# Health Checks

Deployment should verify:

- Caddy is responding.
- Wiki.js is healthy.
- PostgreSQL is reachable.
- Google OAuth is functioning.
- Persistent storage is mounted.

---

# Future Improvements

Future deployment may include:

- GitHub Actions deployment
- Pulumi
- Kubernetes
- Helm
- Automated backups
- Blue/Green deployments
- Zero-downtime upgrades

These improvements should build upon—not replace—the initial Docker Compose deployment.

---

# Success Criteria

A new production server should be deployable from scratch using only:

- Repository source
- Environment variables
- Deployment commands

No manual application configuration should be required beyond initial OAuth setup.
