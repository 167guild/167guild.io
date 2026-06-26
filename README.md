# 🐉 167guild.io

A self-hosted D&D world wiki for the 167 Guild — powered by Wiki.js, PostgreSQL, and Caddy.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Overview

167guild.io is a self-hosted knowledge portal for the 167 Guild D&D campaign. It preserves lore, session history, characters, maps, and world context.

This repository is also intended as a **reusable template** for future self-hosted knowledge platforms.

---

## Architecture

| Component     | Role                                      |
|---------------|-------------------------------------------|
| **Wiki.js**   | Wiki engine and content management        |
| **PostgreSQL** | Primary database                         |
| **Caddy**     | Reverse proxy, automatic HTTPS           |
| **Docker Compose** | Local orchestration                 |

See [`docs/architecture.md`](docs/architecture.md) for the architecture overview.

---

## Docker Stack (Scaffold)

### Required Software

- [Docker Engine](https://docs.docker.com/engine/install/)
- [Docker Compose](https://docs.docker.com/compose/)

### Planned Startup Flow

The repository now includes an initial `docker-compose.yml` scaffold for `caddy`, `wikijs`, and `postgres`.

When service configuration is completed in follow-up issues, the stack is expected to be started with Docker Compose after creating a local environment file from `.env.example`.

### Service Overview

- **caddy**: reverse-proxy entrypoint scaffold (configuration deferred)
- **wikijs**: wiki application scaffold wired for PostgreSQL environment variables
- **postgres**: persistent database scaffold with a basic health check

Named volumes are defined for persistent data, and services are attached to an internal Docker network.

---

## Development

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)
- [Task](https://taskfile.dev/#/installation) (optional but recommended)

### Local Workflow (High Level)

```bash
# 1. Clone the repository
git clone https://github.com/167guild/167guild.io.git
cd 167guild.io

# 2. Copy environment template
cp .env.example .env

# 3. Open in VS Code
#    - install recommended extensions from .vscode/extensions.json
#    - optionally reopen in the provided Dev Container

# 4. Initialize local environment scaffolding
task init

# 5. Run placeholder quality checks
task lint
task format

# 6. Start/stop local workflow placeholders
task up
task down
```

The current Taskfile commands are intentionally scaffolded placeholders to establish a reproducible baseline developer environment.

---

## Available Commands

```bash
task help      # List available tasks
task init      # Initialize local development scaffolding (placeholder)
task lint      # Run lint workflow (placeholder)
task format    # Run formatter workflow (placeholder)
task up        # Start local workflow (placeholder)
task down      # Stop local workflow (placeholder)
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

Project specifications are located in [`.github/specs/`](.github/specs/):

| Specification | Description |
|---|---|
| [vision.spec.md](.github/specs/vision.spec.md) | Project goals and guiding principles |
| [architecture.spec.md](.github/specs/architecture.spec.md) | System design and component overview |
| [repository.spec.md](.github/specs/repository.spec.md) | Repository standards and structure |

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.

---

## Security

See [SECURITY.md](SECURITY.md) for the security policy and reporting vulnerabilities.

---

## License

This project is licensed under the [MIT License](LICENSE).
