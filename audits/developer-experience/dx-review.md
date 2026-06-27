# Developer Experience Review

**Date:** 2026-06-27
**Scope:** Local development, onboarding, tooling, documentation, VS Code integration, Dev Container
**Target:** v0.1.0

---

## Summary

The repository has a strong developer experience foundation. Specifications are well-organized, community health files are present, VS Code settings and extensions are configured, a Dev Container is provided, and the Taskfile provides a consistent command surface. However, the core local development tasks are all stubs, meaning a contributor following the README will reach dead ends immediately.

---

## Onboarding Assessment

### What Works

- The `README.md` provides a clear six-step local workflow.
- The `CONTRIBUTING.md` describes the workflow, commit conventions, and code standards.
- Specifications in `.github/specs/` clearly describe the intent of every subsystem.
- The Dev Container provides a reproducible environment without manual tool installation.
- `cp .env.example .env` gives a working environment template.

### What Doesn't Work

**DX-1: All core developer tasks are stubs**

Running the documented workflow from `README.md`:
```bash
task init     # → echoes "TODO: initialize local development environment"
task lint     # → echoes "TODO: run lint checks"
task format   # → echoes "TODO: run formatting tools"
task up       # → echoes "TODO: start local development stack"
task down     # → echoes "TODO: stop local development stack"
```

None of these commands do anything. A new contributor following the README will be unable to start a local environment.

**Resolution:** Implement the minimum viable versions:
```yaml
up:
  desc: Start local development stack
  cmds:
    - docker compose --env-file .env up -d

down:
  desc: Stop local development stack
  cmds:
    - docker compose --env-file .env down

init:
  desc: Initialize local development environment
  cmds:
    - sh: test -f .env || cp .env.example .env
      msg: ".env already exists, skipping."
    - echo "✅ .env initialized. Edit it and run task up."
```

For `lint` and `format`, either wire to a real linter (markdownlint, yamllint, shellcheck) or at minimum make the commands succeed silently rather than printing a TODO message that implies failure.

**DX-2: `docs/architecture.md` does not exist**

`README.md` links to `docs/architecture.md`:
> See [`docs/architecture.md`](docs/architecture.md) for the architecture overview.

This file does not exist. The link produces a 404 on GitHub.

**Resolution:** Create `docs/architecture.md` with at minimum the service overview table already in `README.md` and a text-based service interaction diagram.

---

## Documentation Coverage

### Existing Documentation

| File | Status | Assessment |
|---|---|---|
| `README.md` | ✅ Present | Clear, well-structured. One broken link. |
| `CONTRIBUTING.md` | ✅ Present | Good workflow and conventions. |
| `SECURITY.md` | ⚠️ Minimal | Only two sentences. No real policy. |
| `CHANGELOG.md` | ✅ Present | Auto-generated; has placeholder 0.1.0 entry. |
| `CODE_OF_CONDUCT.md` | ✅ Present | Not mentioned in README's community files section. |
| `ROADMAP.md` | ✅ Present | Comprehensive; some items need updating. |
| `LICENSE` | ✅ Present | MIT. |
| `deploy/README.md` | ✅ Present | Excellent. Thorough deployment documentation. |
| `docs/backup.md` | ✅ Present | Good current-state and future-work documentation. |
| `docs/authorization.md` | ✅ Present | Comprehensive RBAC documentation. |
| `docs/architecture.md` | ❌ Missing | Referenced but does not exist. |
| `SUPPORT.md` | ❌ Missing | No support policy documented. |

### Specification Coverage

| Spec | Present | Notes |
|---|---|---|
| `vision.spec.md` | ✅ | Clear and well-written. |
| `architecture.spec.md` | ✅ | Has a `wiki.167guild.io` reference inconsistent with Caddyfile. |
| `infrastructure.spec.md` | ✅ | Comprehensive. |
| `deployment.spec.md` | ✅ | Good. |
| `authentication.spec.md` | ✅ | Clear. |
| `authorization.spec.md` | ✅ | Detailed. |
| `backups.spec.md` | ✅ | Well-structured. |
| `design-system.spec.md` | ✅ | Highly detailed. |
| `content-model.spec.md` | ✅ | Comprehensive. |
| `permissions.spec.md` | ✅ | Detailed. |
| `versioning.spec.md` | ✅ | Clear. |
| `repository.spec.md` | ✅ | Present; some items reference future state. |
| `roadmap.spec.md` | ✅ | Present. |

---

## Taskfile Assessment

### Implemented Tasks

| Task | Status | Notes |
|---|---|---|
| `help` | ✅ Working | Lists available tasks. |
| `backup` | ✅ Runs | Delegates to `scripts/backup/backup.sh`; script is a stub. |
| `restore` | ✅ Runs | Delegates to `scripts/restore/restore.sh`; script is a stub. |
| `deploy` | ✅ Runs | Delegates to `deploy:production`. |
| `deploy:production` | ✅ Working | Validates, configures, deploys production. |
| `stop` | ✅ Working | Stops production containers. |
| `restart` | ✅ Working | Restarts production containers. |
| `logs` | ✅ Working | Tails production logs. |
| `status` | ✅ Working | Shows container status. |
| `health` | ✅ Working | Runs health checks. |

### Stub Tasks (Not Yet Implemented)

| Task | Resolution |
|---|---|
| `init` | Implement: copy `.env.example` to `.env` if missing. |
| `up` | Implement: `docker compose --env-file .env up -d`. |
| `down` | Implement: `docker compose --env-file .env down`. |
| `lint` | Implement: run `shellcheck`, `yamllint`, and `markdownlint`, or remove if no linters are planned. |
| `format` | Implement: run a formatter, or remove if no formatter is planned. |

---

## Dev Container Assessment

**File:** `.devcontainer/devcontainer.json`

The Dev Container is based on `mcr.microsoft.com/devcontainers/base:ubuntu`. It mounts Docker outside of Docker via the `docker-outside-of-docker` feature.

**DX-3: Dev Container does not install `task`**

The Taskfile is described as the primary interface for all workflows, but the Dev Container does not install it. A developer using the Dev Container must manually install `task` before following the README instructions.

**Resolution:** Add task installation to the Dev Container:
```json
"features": {
  "ghcr.io/devcontainers/features/docker-outside-of-docker:1": {},
  "ghcr.io/devcontainers/features/common-utils:2": {}
},
"postCreateCommand": "sh -c 'curl -sL https://taskfile.dev/install.sh | sh -s -- -d -b /usr/local/bin'"
```

Or use the Taskfile community dev container feature if available.

**DX-4: Dev Container does not copy `.env.example` to `.env` automatically**

A contributor who opens the repository in a Dev Container still needs to manually copy the env file before running any tasks.

**Resolution:** Add to `postCreateCommand`:
```json
"postCreateCommand": "test -f .env || cp .env.example .env"
```

---

## VS Code Configuration

**Files:** `.vscode/extensions.json`, `.vscode/settings.json`

Extensions recommended:
- Docker (`ms-azuretools.vscode-docker`)
- Markdown All in One (`yzhang.markdown-all-in-one`)
- markdownlint (`davidanson.vscode-markdownlint`)
- YAML (`redhat.vscode-yaml`)
- EditorConfig (`editorconfig.editorconfig`)
- GitHub Copilot and Copilot Chat
- Code Spell Checker

**Assessment:** Good selection for a documentation-heavy, Docker-based project. Consider adding:
- `timonwong.shellcheck` — shell script linting for `scripts/` and `deploy/scripts/`
- `task.vscode-task` — Taskfile syntax support

---

## Empty Directories

The following directories exist but contain only `.gitkeep`:

| Directory | Notes |
|---|---|
| `scripts/deploy/` | Purpose unclear. Deploy scripts live in `deploy/scripts/`. |
| `docker/` | Purpose unclear. No custom Dockerfiles are planned. |
| `assets/icons/` | Icon assets are referenced in the design system; none are present. |
| `assets/images/` | General images placeholder. |
| `theme/assets/` | Theme assets (fonts, SVGs) placeholder. |

**DX-5:** Empty directories with `.gitkeep` suggest planned but undelivered content. Consider adding brief `README.md` files to each explaining the intended purpose and current status, or removing directories where the purpose has been superseded.

---

## Commit Conventions

Conventional Commits are enforced via `commitlint` in the release workflow. The `.commitlintrc.json` configuration is present.

**Assessment:** This is well-implemented. The `release.yml` workflow validates commits on every push to `main`.

**One observation:** The release workflow runs `validate-commits` before `release-please`. If `validate-commits` fails, `release-please` is skipped. This is correct behavior. However, if a merge commit from a GitHub PR (e.g., "Merge pull request #42 from ...") does not follow Conventional Commits, the entire release workflow will fail.

**Resolution:** Ensure all PRs are merged using "Squash and Merge" with a Conventional Commits-compliant title, or configure the commitlint check to use `firstParent: true` (already set in the workflow configuration — this is correct).

---

## Broken Documentation Links

| Location | Link | Status |
|---|---|---|
| `README.md` | `docs/architecture.md` | ❌ File does not exist |
| `README.md` | `assets/README.md` | ✅ Exists |
| `README.md` | `CONTRIBUTING.md` | ✅ Exists |
| `README.md` | `SECURITY.md` | ✅ Exists |
| `README.md` | `.github/specs/` | ✅ Exists |
| `docs/backup.md` | `scripts/backup/backup.sh` | ✅ Exists |
| `docs/backup.md` | `scripts/restore/restore.sh` | ✅ Exists |
| `docs/backup.md` | `.github/specs/backups.spec.md` | ✅ Exists |
| `docs/authorization.md` | `scripts/bootstrap/seed-groups.sql` | ✅ Exists |
