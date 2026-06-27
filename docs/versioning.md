# Versioning & Release Guide

This document explains how versions are created, tagged, and published in the 167 Guild Wiki repository.

For the full specification, see [`.github/specs/versioning.spec.md`](../.github/specs/versioning.spec.md).

---

## Overview

This project uses:

- **[Semantic Versioning](https://semver.org/)** for version numbers
- **[Conventional Commits](https://www.conventionalcommits.org/)** for structured commit messages
- **[Release Please](https://github.com/googleapis/release-please)** for automated release management
- **[Keep a Changelog](https://keepachangelog.com/)** for changelog format

---

## Version Format

    MAJOR.MINOR.PATCH

| Part    | When it increments                                      |
|---------|---------------------------------------------------------|
| `MAJOR` | Breaking changes incompatible with previous behavior    |
| `MINOR` | New backward-compatible features                        |
| `PATCH` | Backward-compatible bug fixes                           |

While the major version is `0`, the project is in active pre-release development.

---

## Commit Message Convention

All commits must follow the [Conventional Commits](https://www.conventionalcommits.org/) format:

```
<type>[optional scope]: <description>
```

### Examples

```
feat: add automated backup validation
fix: correct PostgreSQL healthcheck interval
docs: update deployment runbook
chore: update development container base image
feat!: redesign environment configuration format
```

### Types and Their Version Impact

| Type        | Version Impact        |
|-------------|-----------------------|
| `feat`      | MINOR bump            |
| `fix`       | PATCH bump            |
| `perf`      | PATCH bump            |
| `feat!`     | MAJOR bump            |
| `docs`      | No release triggered  |
| `chore`     | No release triggered  |
| `ci`        | No release triggered  |
| `refactor`  | No release triggered  |
| `test`      | No release triggered  |
| `style`     | No release triggered  |
| `build`     | No release triggered  |

A **breaking change** is signaled by appending `!` to the type or adding a `BREAKING CHANGE:` footer.

---

## Release Lifecycle

```
feature branch → PR → merge to main → Release Please opens release PR
                                              ↓
                                    Review & merge release PR
                                              ↓
                                    GitHub tag + Release created
                                              ↓
                                    CHANGELOG.md updated
```

1. Developers merge feature PRs into `main` using Conventional Commits.
2. Release Please monitors `main` and opens a **release PR** that proposes:
   - A version bump based on commit history
   - An updated `CHANGELOG.md`
3. When the release PR is merged, Release Please automatically:
   - Creates a git tag (e.g., `v0.2.0`)
   - Publishes a GitHub Release with generated release notes

---

## Branching Expectations

| Branch Type    | Pattern              | Purpose                            |
|----------------|----------------------|------------------------------------|
| Primary        | `main`               | Production-ready, released code    |
| Feature        | `feature/<name>`     | New features and enhancements      |
| Bug fix        | `fix/<name>`         | Bug corrections                    |
| Documentation  | `docs/<name>`        | Documentation updates              |
| Release PR     | `release-please--…`  | Managed by Release Please          |

All releases originate from `main`.

---

## Tagging Conventions

Release tags always use the format:

    v<MAJOR>.<MINOR>.<PATCH>

Examples:

    v0.1.0
    v0.2.0
    v1.0.0

Tags are created automatically by the release workflow. Manual tags should be avoided.

---

## Changelog

The [`CHANGELOG.md`](../CHANGELOG.md) at the repository root is the authoritative record of all releases.

It follows [Keep a Changelog](https://keepachangelog.com/) format and is maintained automatically by Release Please.
Do not edit `CHANGELOG.md` manually; let the release workflow update it.

---

## Configuration Files

| File                                  | Purpose                                |
|---------------------------------------|----------------------------------------|
| `.github/release-please-config.json`  | Release Please release type and options |
| `.release-please-manifest.json`       | Current version manifest               |
| `.github/workflows/release.yml`       | GitHub Actions release workflow        |
| `.commitlintrc.json`                  | Commit message validation rules        |

---

## Workflow Reference

The release workflow (`.github/workflows/release.yml`) runs on every push to `main` and:

1. **Validates commit messages** — ensures all commits follow Conventional Commits.
2. **Runs Release Please** — determines the next version, updates `CHANGELOG.md`, and manages release PRs and tags.

The workflow requires the default `GITHUB_TOKEN` with `contents: write` and `pull-requests: write` permissions, which are configured in the workflow file.

---

## First-Time Setup

No manual setup is required. The workflow uses the built-in `GITHUB_TOKEN` provided by GitHub Actions.

Ensure the following repository permissions are enabled under **Settings → Actions → General**:

- Allow GitHub Actions to create and approve pull requests: ✅
- Workflow permissions: **Read and write permissions** ✅
