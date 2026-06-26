# 🐉 167guild.io

A beautiful, self-hosted D&D world wiki for the 167 Guild — powered by Wiki.js, PostgreSQL, and Caddy.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview

167guild.io is a private, self-hosted knowledge portal for the 167 Guild D&D campaign. It preserves lore, session history, characters, maps, artwork, and world context while giving the Dungeon Master a private space for hidden world notes.

This repository is also intended as a **reusable template** for future self-hosted knowledge platforms.

---

## Architecture

| Component     | Role                                      |
|---------------|-------------------------------------------|
| **Wiki.js**   | Wiki engine, authentication, content mgmt |
| **PostgreSQL** | Primary database                         |
| **Caddy**     | Reverse proxy, automatic HTTPS           |
| **Docker Compose** | Local and production orchestration  |

See [`.github/specs/architecture.spec.md`](.github/specs/architecture.spec.md) for the full architecture specification.

---

## Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)
- [Task](https://taskfile.dev/#/installation) (optional but recommended)

### Local Development

```bash
# 1. Clone the repository
git clone https://github.com/167guild/167guild.io.git
cd 167guild.io

# 2. Copy environment template
cp .env.example .env

# 3. Edit .env with your local configuration
#    (no secrets required for local development)

# 4. Start the stack
task up
# or without Task:
docker compose up -d
```

The wiki will be available at [http://localhost:3000](http://localhost:3000).

---

## Available Commands

```bash
task up        # Start all services
task down      # Stop all services
task restart   # Restart all services
task logs      # Follow service logs
task status    # Show service status
task backup    # Run a backup
task restore   # Restore from backup
task deploy    # Deploy to production
task setup     # Initial setup
```

---

## Repository Structure

```
.
├── .devcontainer/          # VS Code Dev Container configuration
├── .github/
│   ├── ISSUE_TEMPLATE/     # GitHub issue templates
│   ├── workflows/          # GitHub Actions workflows
│   └── specs/              # Project specifications (source of truth)
├── .vscode/                # VS Code workspace settings
├── config/
│   ├── caddy/              # Caddy reverse proxy configuration
│   └── wikijs/             # Wiki.js application configuration
├── docs/                   # Project documentation
├── scripts/
│   ├── backup/             # Backup automation scripts
│   ├── bootstrap/          # Server bootstrap scripts
│   ├── deploy/             # Deployment scripts
│   └── restore/            # Restore scripts
├── .editorconfig           # Editor formatting standards
├── .env.example            # Environment variable template
├── CHANGELOG.md            # Version history
├── CODE_OF_CONDUCT.md      # Community standards
├── CONTRIBUTING.md         # Contribution guidelines
├── docker-compose.yml      # Docker Compose stack definition
├── LICENSE                 # MIT License
├── README.md               # This file
├── SECURITY.md             # Security policy
└── Taskfile.yml            # Task automation
```

---

## Specifications

All project decisions are driven by specifications located in [`.github/specs/`](.github/specs/):

| Specification | Description |
|---|---|
| [vision.spec.md](.github/specs/vision.spec.md) | Project goals and guiding principles |
| [architecture.spec.md](.github/specs/architecture.spec.md) | System design and component overview |
| [repository.spec.md](.github/specs/repository.spec.md) | Repository standards and structure |
| [infrastructure.spec.md](.github/specs/infrastructure.spec.md) | Infrastructure design |
| [deployment.spec.md](.github/specs/deployment.spec.md) | Deployment process |
| [authentication.spec.md](.github/specs/authentication.spec.md) | Authentication design |
| [authorization.spec.md](.github/specs/authorization.spec.md) | Authorization and roles |
| [permissions.spec.md](.github/specs/permissions.spec.md) | Permission matrix |
| [content-model.spec.md](.github/specs/content-model.spec.md) | Wiki content structure |
| [design-system.spec.md](.github/specs/design-system.spec.md) | Visual design principles |
| [roadmap.spec.md](.github/specs/roadmap.spec.md) | Project roadmap |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## Security

See [SECURITY.md](SECURITY.md) for the security policy and reporting vulnerabilities.

---

## License

This project is licensed under the [MIT License](LICENSE).

