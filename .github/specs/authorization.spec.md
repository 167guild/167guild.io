# 🛡️ Authorization Specification

## Purpose

This document defines how authenticated users are granted access to resources within the 167 Guild Wiki.

Authorization answers the question:

"What is this user allowed to do?"

Authentication identifies users.

Authorization determines what those users may access.

---

# Design Goals

- Simple permission model.
- Principle of least privilege.
- Explicit role inheritance.
- Easy administration.
- Secure by default.

---

# Authorization Model

The system uses Role-Based Access Control (RBAC).

Users are assigned one or more roles.

Roles grant permissions.

Permissions determine access to content and administrative capabilities.

---

# Initial Roles

- Administrator
- Dungeon Master
- Player
- Viewer
- Anonymous (optional)

The detailed capabilities of each role are defined in `permissions.spec.md`.

---

# Content Visibility

Content should support restricted visibility.

Examples include:

- Public pages
- Guild-only pages
- Player-specific pages
- DM-only pages
- Administrative documentation

Visibility should be configurable per page or namespace where supported.

---

# Ownership

Some content should have ownership.

Examples:

- Character pages
- Session journals
- Personal notes

Owners may edit their own content without requiring elevated privileges.

---

# Administrative Access

Administrators may:

- Manage authentication providers.
- Manage users.
- Manage roles.
- Configure the wiki.
- Perform maintenance.

Administrators should avoid participating in normal gameplay administration whenever possible.

---

# Dungeon Master Access

The Dungeon Master is responsible for campaign management.

Examples include:

- World lore
- Hidden campaign information
- NPC planning
- Secret locations
- Future encounters
- Campaign preparation

DM content should remain invisible to Players and Viewers.

---

# Security Principles

Authorization should:

- Deny access by default.
- Require explicit permission grants.
- Prevent privilege escalation.
- Isolate private campaign information.
- Minimize accidental exposure.

---

# Future Enhancements

Future versions may support:

- Multiple campaigns.
- Multiple DMs.
- Temporary permissions.
- Group ownership.
- Fine-grained namespace permissions.

---

# Success Criteria

Every authenticated user should automatically receive the appropriate level of access.

Authorization should remain predictable, maintainable, and easy to audit as the guild and wiki continue to grow.
