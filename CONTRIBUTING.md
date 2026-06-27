# Contributing to 167guild.io

Thank you for your interest in contributing.

This repository follows specification-driven development:

> Specifications -> GitHub Issues -> Pull Requests

## Before You Begin

1. Read relevant specs in [`.github/specs/`](.github/specs/).
2. Review architecture and setup docs:
   - [docs/architecture.md](docs/architecture.md)
   - [docs/setup/README.md](docs/setup/README.md)

## Development Workflow

1. Open or find an issue for the work.
2. Create a branch from `main` (`feature/*`, `fix/*`, `docs/*`).
3. Make focused changes.
4. Run local checks:

```bash
task init
task lint
task format
```

5. Start stack if needed:

```bash
task up
```

6. Open a PR and address review feedback.

## Commit Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/).

Examples:

- `feat: bootstrap Wiki.js stack`
- `docs: add setup portal`
- `fix: correct postgres configuration`
- `chore: update development container`

## Code Standards

- Use the repository formatting defaults and editor settings.
- Never commit secrets, credentials, or populated environment files.
- Commit only templates like `.env.example` and `deploy/examples/.env.production.example`.
- Keep pull requests focused and small.

## Questions

Use GitHub Discussions at https://github.com/167guild/167guild.io/discussions or open an issue.
