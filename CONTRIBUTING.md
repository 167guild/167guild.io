# Contributing to 167guild.io

Thank you for your interest in contributing to this project!

This repository follows a **specification-driven development** workflow:

> Specifications → GitHub Issues → Pull Requests

---

## Before You Begin

Read the relevant specifications in [`.github/specs/`](.github/specs/) before starting work.
Specifications are the source of truth for all design decisions.

---

## Development Workflow

1. **Read the specs** relevant to your change.
2. **Open or find an issue** that describes the work. All work should be tied to an issue.
3. **Create a branch** from `main`:
   - Features: `feature/<name>`
   - Bug fixes: `fix/<name>`
   - Documentation: `docs/<name>`
4. **Make your changes** following the standards below.
5. **Open a pull request** using the provided template.
6. **Address review feedback** before merging.

---

## Commit Convention

This project uses [Conventional Commits](https://www.conventionalcommits.org/).

Examples:

```
feat: bootstrap Wiki.js stack
docs: add authorization specification
fix: correct postgres configuration
chore: update development container
```

---

## Local Development

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)
- [Task](https://taskfile.dev/#/installation)

### Setup

```bash
cp .env.example .env
task up
```

See [README.md](README.md) for full setup instructions.

---

## Code Standards

- Use the provided [`.editorconfig`](.editorconfig) for formatting.
- Do not commit secrets, credentials, or real environment files.
- Only commit template files (e.g., `.env.example`).
- Keep pull requests focused and small.

---

## Reporting Issues

Use the provided GitHub Issue Templates when filing issues:

- Bug report
- Feature request
- Specification-driven implementation

---

## Questions

Open a [GitHub Discussion](../../discussions) or file an issue if you have questions.
