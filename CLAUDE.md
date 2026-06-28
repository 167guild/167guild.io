# 🧠 CLAUDE.md

> This document contains Claude-specific guidance for working within this repository.
>
> Repository engineering policies are defined in **AGENTS.md**.
>
> Claude should treat `AGENTS.md` as the canonical engineering standard.

---

# Before Beginning Work

Always:

1. Read the GitHub Issue completely.
2. Read every specification referenced by the issue.
3. Read `AGENTS.md`.
4. Stay within the issue scope.

Do not expand the issue unless explicitly instructed.

---

# Development Philosophy

Prefer:

* small iterations
* thoughtful reasoning
* maintainable code
* explicit tradeoffs
* clear documentation

Avoid speculative implementations.

---

# Specifications

Treat repository specifications as the source of truth.

If implementation and specification disagree:

* prefer the specification
* document inconsistencies
* avoid silently changing behavior

---

# Commits

Follow the commit policy defined in `AGENTS.md`.

Use Conventional Commits.

Prefer multiple small commits over one large commit.

---

# Documentation

Whenever implementation changes:

Review whether:

* README
* ROADMAP
* setup documentation
* deployment documentation
* specifications

also require updates.

Documentation is considered part of the implementation.

---

# Refactoring

Do not perform broad repository cleanup unless requested.

If unrelated improvements are discovered:

* document them
* recommend a future issue

Stay focused on the requested scope.

---

# Pull Requests

Aim for:

* small
* reviewable
* self-contained

Avoid mixing unrelated changes.

---

# Architecture

Favor existing repository patterns.

Avoid introducing new architectural concepts when existing patterns already solve the problem.

Consistency is preferred over novelty.

---

# Reflector

Repository audits are first-class engineering activities.

When asked to audit:

* observe before changing
* distinguish between findings and recommendations
* separate critical blockers from future enhancements

---

# Long-Term Vision

The 167 Guild Wiki is the reference implementation for a future reusable **Knowledge World Platform**.

Engineering decisions should favor modularity, reproducibility, and future extraction into reusable open-source components.

When making implementation decisions, prefer solutions that will scale into that future platform.
