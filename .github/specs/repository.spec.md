# 📦 Repository Specification

## Purpose

This repository contains the complete source of truth for the 167 Guild Wiki infrastructure, deployment, documentation, and operational tooling.

The repository should remain reproducible, well-documented, and approachable for contributors while serving as the deployment source for production.

---

# Objectives

- Maintain a single source of truth.
- Encourage specification-first development.
- Provide an excellent developer experience.
- Make local development identical to production whenever practical.
- Automate repetitive tasks.
- Minimize onboarding time.

---

# Repository Layout

    .
    ├── .github/
    │   ├── ISSUE_TEMPLATE/
    │   ├── workflows/
    │   └── specs/
    │
    ├── config/
    │   ├── caddy/
    │   └── wikijs/
    │
    ├── docs/
    │
    ├── scripts/
    │   ├── backup/
    │   ├── deploy/
    │   ├── restore/
    │   └── bootstrap/
    │
    ├── docker/
    │
    ├── docker-compose.yml
    ├── Taskfile.yml
    ├── .env.example
    ├── README.md
    ├── LICENSE
    └── SECURITY.md

---

# Repository Standards

## Documentation

Every major subsystem should have a corresponding specification located in:

    .github/specs/

Specifications define intent.

GitHub Issues define implementation.

Pull Requests implement Issues.

---

## Branch Strategy

Primary branches:

- main
- develop (optional)

Feature branches:

    feature/<name>

Bug fixes:

    fix/<name>

Documentation:

    docs/<name>

---

# Commit Convention

Use Conventional Commits.

Examples:

    feat: bootstrap Wiki.js stack

    docs: add authorization specification

    fix: correct postgres configuration

    chore: update development container

---

# Required Files

The repository should eventually contain:

- README.md
- LICENSE
- SECURITY.md
- CONTRIBUTING.md
- CHANGELOG.md
- CODE_OF_CONDUCT.md
- Taskfile.yml
- docker-compose.yml
- .env.example

---

# Automation

Automation should eventually include:

- GitHub Actions
- linting
- spell checking
- secret scanning
- dependency updates
- Docker validation
- backup validation

---

# Local Development

The repository should support:

- Docker Compose
- VS Code Dev Containers
- reproducible environments
- one-command startup
- one-command deployment
- one-command backups

---

# Security

Never commit:

- production secrets
- OAuth credentials
- SSH private keys
- production database dumps
- production backups
- real environment files

Only commit templates.

---

# Philosophy

The repository should be understandable by a new contributor within minutes.

The repository structure should communicate architecture naturally.

Specifications drive implementation.

Automation reinforces specifications.

The goal is not only to build a great DnD wiki, but to establish a reusable template for future self-hosted knowledge platforms.
