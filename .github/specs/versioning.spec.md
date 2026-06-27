# 📦 Versioning Specification

## Purpose

This document defines the versioning strategy for the 167 Guild Wiki repository.

The goal is to make every release reproducible, traceable, and consistently communicated.

---

# Versioning Philosophy

- Versions are meaningful signals, not arbitrary numbers.
- Every release should be traceable to a specific set of changes.
- Automation reduces human error in release management.
- Release notes should be generated from commit history.

---

# Semantic Versioning

This project follows [Semantic Versioning 2.0.0](https://semver.org/).

Format:

    MAJOR.MINOR.PATCH

Rules:

| Increment | When to use |
|-----------|-------------|
| MAJOR     | Breaking changes that are incompatible with previous behavior |
| MINOR     | New features added in a backward-compatible manner |
| PATCH     | Backward-compatible bug fixes |

Examples:

    0.1.0 — initial infrastructure release
    0.2.0 — new feature added
    0.2.1 — bug fix applied
    1.0.0 — stable production-ready release

While the major version is 0, the project is considered pre-1.0 and under active development. Rapid iteration is expected.

---

# Conventional Commits

This project uses [Conventional Commits](https://www.conventionalcommits.org/) to drive automated version bumps.

Format:

    <type>[optional scope]: <description>

    [optional body]

    [optional footer(s)]

## Commit Types and Version Impact

| Commit Type | Description                          | Version Impact |
|-------------|--------------------------------------|----------------|
| `feat`      | New feature                          | MINOR bump     |
| `fix`       | Bug fix                              | PATCH bump     |
| `docs`      | Documentation changes only           | No release     |
| `chore`     | Maintenance tasks                    | No release     |
| `refactor`  | Code restructuring without new feat  | No release     |
| `perf`      | Performance improvement              | PATCH bump     |
| `test`      | Test additions or corrections        | No release     |
| `ci`        | CI/CD pipeline changes               | No release     |
| `build`     | Build system changes                 | No release     |
| `style`     | Formatting, whitespace               | No release     |

## Breaking Changes

A breaking change is indicated by:

- A `!` after the type: `feat!: redesign authentication`
- A `BREAKING CHANGE:` footer in the commit body

Breaking changes trigger a MAJOR version bump.

## Examples

    feat: add automated backup validation
    fix: correct PostgreSQL healthcheck interval
    docs: update deployment runbook
    chore: update development container base image
    feat!: redesign environment configuration format

---

# Release Lifecycle

1. **Development** — commits are pushed to feature branches following Conventional Commits.
2. **Pull Request** — changes are reviewed and merged into `main`.
3. **Release PR** — Release Please automatically opens a release PR against `main` with:
   - Updated `CHANGELOG.md`
   - Version bump proposal
4. **Release** — when the release PR is merged:
   - A git tag is created (e.g., `v0.2.0`)
   - A GitHub Release is published with generated release notes
5. **Post-release** — contributors resume development on `main`.

---

# Branching Expectations

| Branch type         | Pattern                | Purpose                              |
|---------------------|------------------------|--------------------------------------|
| Primary             | `main`                 | Production-ready code                |
| Feature             | `feature/<name>`       | New features                         |
| Bug fix             | `fix/<name>`           | Bug corrections                      |
| Documentation       | `docs/<name>`          | Documentation changes                |
| Release PR          | `release-please--...`  | Managed by Release Please automation |

Releases are cut from `main` only.

---

# Tagging Conventions

All release tags follow the format:

    v<MAJOR>.<MINOR>.<PATCH>

Examples:

    v0.1.0
    v0.2.0
    v1.0.0

Tags are created automatically by the release workflow when a release PR is merged.

Manual tags should only be created in exceptional circumstances and must follow the same format.

---

# Changelog

The `CHANGELOG.md` file at the repository root is:

- Maintained automatically by the release workflow.
- Updated in every release PR.
- The authoritative record of changes per release.

Format follows [Keep a Changelog](https://keepachangelog.com/).

---

# Release Automation

This repository uses [Release Please](https://github.com/googleapis/release-please) for automated release management.

Release Please:

- Parses Conventional Commits from merged PRs.
- Opens a release PR with updated `CHANGELOG.md` and version manifest.
- Creates a GitHub Release and git tag when the release PR is merged.

Configuration files:

| File                                  | Purpose                          |
|---------------------------------------|----------------------------------|
| `.github/release-please-config.json`  | Release Please configuration     |
| `.release-please-manifest.json`       | Current version manifest         |
| `.github/workflows/release.yml`       | GitHub Actions release workflow  |

---

# Success Criteria

- Every release has a corresponding git tag.
- Every git tag has a corresponding GitHub Release.
- Every GitHub Release includes automatically generated release notes.
- `CHANGELOG.md` reflects all user-facing changes.
- Version increments follow Semantic Versioning rules.
