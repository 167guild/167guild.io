# Authorization

## Overview

The 167 Guild Wiki uses Wiki.js group-based role access control. Authentication
identifies a user; authorization determines what that user may access.

Production member identities and role mappings are private deployment state.
This public repository contains synthetic role fixtures only.

## Permission philosophy

- Deny access by default.
- Grant only the permissions required by each role.
- Keep platform administration separate from campaign administration.
- Restrict all Dungeon Master material to the `/dm/` namespace.
- Never commit production member names, email addresses, group membership, or
  exported user records.

## Roles

### Platform Administrator

Maps to the built-in Wiki.js `Administrators` group and has full platform
control. Use `platform-admin@example.invalid` in public examples.

Responsibilities include authentication configuration, user and group
management, backup, recovery, and platform maintenance.

### Dungeon Master

A custom group with campaign-management permissions, including access to
`/dm/`. Use `dungeon-master@example.invalid` in public examples.

Recommended permissions:

- `read:pages`
- `write:pages`
- `manage:pages`
- `delete:pages`
- `read:assets`
- `write:assets`
- `manage:assets`
- `read:comments`
- `write:comments`
- `manage:comments`
- `read:source`

### Player

A custom group for authenticated participants. Public examples use
`player-one@example.invalid`, `player-two@example.invalid`, and
`player-three@example.invalid`.

Players may read published content and write under `/characters/` and
`/journals/`, but must be denied access to `/dm/`.

Wiki.js does not enforce per-user page ownership natively. Write access in a
namespace is shared by the group, so the initial deployment relies on community
trust until a finer-grained ownership layer is implemented.

### Viewer

A read-only custom group. Viewers may read approved published content and must
be denied access to `/dm/`.

### Anonymous

The Wiki.js `Guests` group must have no permissions unless a separate,
owner-approved public-content policy is introduced. The setup wizard and
administration surface are never intended as public content.

## Namespace policy

| Namespace | Read | Write |
| --- | --- | --- |
| `/` | Authenticated roles | Dungeon Master |
| `/characters/` | Authenticated roles | Player, Dungeon Master |
| `/journals/` | Authenticated roles | Player, Dungeon Master |
| `/lore/` | Authenticated roles | Dungeon Master |
| `/dm/` | Platform Administrator, Dungeon Master | Platform Administrator, Dungeon Master |

## Private member mapping

Production identity-to-role mappings belong in one of these private locations:

- Wiki.js/PostgreSQL application state
- an encrypted operator record outside the repository
- an approved private infrastructure repository

Do not place the mapping in Markdown, SQL comments, examples, issues, workflow
logs, screenshots, fixtures, or generated artifacts in this public repository.

## Onboarding

1. The approved operator creates or authenticates the user.
2. The operator assigns the minimum required group in Wiki.js Admin.
3. The operator removes unintended default memberships.
4. The operator validates access using the role matrix below.
5. The operator records the production identity mapping privately.

## Bootstrap

Run `scripts/bootstrap/seed-groups.sql` only after Wiki.js initializes its
schema. The script creates role definitions, not production member assignments.
Assign approved users through the private Wiki.js administration surface.

## Verification checklist

- [ ] The `Guests` group has no unintended permissions.
- [ ] The setup wizard is not reachable from the signed-out public endpoint.
- [ ] The Administrators group contains only approved operators.
- [ ] The Dungeon Master group can access `/dm/`.
- [ ] Player and Viewer groups cannot access `/dm/`.
- [ ] Players can write only in approved namespaces.
- [ ] Viewers cannot write.
- [ ] No production identity or member roster appears in the public repository.
- [ ] `python3 scripts/verify-public-fixtures.py` passes.

## Future enhancements

- Per-user character-page ownership.
- Multiple campaigns with isolated namespaces.
- Approval workflows for participant edits.
- Automated signed-out access regression checks.
