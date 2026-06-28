# 🤖 AGENTS.md

> **Purpose**
>
> This document defines how AI coding agents (GitHub Copilot Coding Agent, ChatGPT, Claude Code, Codex, etc.) should operate within this repository.
>
> The goal is to maintain a high-quality, production-ready, specification-driven codebase that emphasizes long-term maintainability over short-term convenience.

---

# Core Philosophy

This repository follows several guiding principles:

* Specification-first development
* Small, reviewable pull requests
* Atomic commits
* Infrastructure as Code
* Local-first development
* Security by default
* Documentation as a first-class artifact
* Reproducible environments
* Incremental improvement over large rewrites

Agents should optimize for long-term maintainability rather than the fastest possible implementation.

---

# Read Before Implementing

Before making changes, always read the specifications relevant to the current issue.

Only read the specifications referenced by the issue unless additional context is required.

Avoid making assumptions that contradict the documented specifications.

---

# Development Workflow

For every issue:

1. Understand the scope.
2. Read the referenced specifications.
3. Produce the smallest implementation that satisfies the issue.
4. Avoid unrelated refactoring.
5. Update documentation if behavior changes.
6. Update `ROADMAP.md` when appropriate.
7. Verify changes before considering the issue complete.

---

# Commit Policy

Use **Conventional Commits**.

Format:

```text
type(scope): summary
```

Examples:

```text
feat(auth): configure Google OAuth

fix(ci): resolve commitlint workflow

docs(setup): expand deployment guide

refactor(taskfile): simplify deployment commands

test(auth): add OAuth validation tests

ci(actions): improve release workflow

chore(deps): update GitHub Actions versions
```

Rules:

* lowercase commit types
* concise summaries
* under 72 characters
* one logical change per commit
* avoid mixing unrelated work

Preferred commit types:

* feat
* fix
* docs
* refactor
* perf
* test
* build
* ci
* chore
* revert

---

# Pull Requests

Pull requests should:

* solve one logical problem
* reference the GitHub issue
* avoid unrelated changes
* update documentation when necessary
* remain reasonably small and reviewable

---

# Documentation

Documentation is part of the implementation.

Whenever functionality changes, review whether any of the following require updates:

* README
* ROADMAP
* architecture documentation
* setup documentation
* deployment documentation
* specifications

Broken documentation is considered a bug.

---

# Repository Organization

Prefer existing structure.

Avoid creating new top-level directories without strong justification.

Keep related functionality grouped together.

Favor consistency over personal preference.

---

# Security

Never:

* commit secrets
* commit production credentials
* hardcode passwords
* disable security checks
* bypass validation

Prefer environment variables for configuration.

Document any new required configuration.

---

# Developer Experience

Optimize for contributors.

A new developer should be able to:

* clone the repository
* open the Dev Container
* configure the environment
* run documented commands
* understand the architecture

Avoid introducing unnecessary onboarding friction.

---

# Error Handling

Prefer explicit failures over silent behavior.

Validation errors should:

* explain what failed
* explain why
* explain how to fix it

---

# Code Quality

Prefer:

* readability
* maintainability
* explicit behavior
* clear naming
* composition over duplication

Avoid:

* premature optimization
* unnecessary abstraction
* speculative features

---

# Refactoring

Do not perform broad refactoring unless explicitly requested.

If improvements outside the issue scope are discovered:

* document them
* create follow-up issues
* avoid expanding the current issue unnecessarily

---

# Production

Production changes should be:

* reproducible
* documented
* validated

Infrastructure changes should favor deterministic deployments.

---

# AI Behavior

When uncertain:

Prefer asking for clarification rather than making assumptions.

When implementing:

Explain reasoning through code, documentation, and commit history rather than excessive comments.

Avoid introducing hidden behavior.

---

# Reflector

Treat repository audits as first-class engineering activities.

Audit findings should:

* become GitHub issues when appropriate
* improve documentation
* improve developer experience
* improve operational maturity

The repository should continuously improve through reflection rather than large rewrites.

---

# Long-Term Vision

This repository is not simply a Dungeons & Dragons wiki.

It is the reference implementation of a reusable **Knowledge World Platform**.

Engineering decisions should prioritize reusable architecture, modularity, and extensibility so that future projects can build upon the same foundation.
