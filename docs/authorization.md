# Authorization

## Overview

The 167 Guild Wiki uses Role-Based Access Control (RBAC) via Wiki.js group-based permissions.

Authorization answers the question: **"What is this user allowed to do?"**

Authentication (Google OAuth) identifies users. Authorization determines what those users may access.

---

## Permission Philosophy

- **Deny by default.** Users receive no access until explicitly assigned a group.
- **Principle of least privilege.** Each role grants only the permissions required for its purpose.
- **Platform administration is separate from campaign administration.** The Platform Administrator manages the infrastructure and wiki engine. The Dungeon Master manages campaign content. Neither role requires the other's responsibilities.
- **DM content is isolated.** Dungeon Master-only content lives under the `/dm/` namespace. Players and Viewers are explicitly denied access to this namespace.
- **Ownership is respected.** Players may edit their own character pages and create session journals without requiring elevated privileges.

---

## Role Hierarchy

```
Platform Administrator  (full platform control — Wiki.js Administrators group)
        │
        ├── Dungeon Master  (full campaign control — custom group)
        │
        ├── Player          (participant access — custom group)
        │
        └── Viewer          (read-only — custom group)
```

Roles do not inherit from one another. Each role has its permissions granted explicitly.

---

## Groups

### Platform Administrator

**Purpose:** Repository and platform maintenance.

**Wiki.js mapping:** Built-in `Administrators` system group.

**Responsibilities:**
- Wiki administration
- Authentication configuration
- Extension and theme management
- User management
- Role and group management
- Backup and maintenance

**Permissions:** Unrestricted. Full access to all Wiki.js administrative functions, including `manage:system`.

**Page rules:** No restrictions. Administrators may access all content including the `/dm/` namespace.

**Initial placeholder member:**

| Name  | Email                 | Notes                                     |
|-------|-----------------------|-------------------------------------------|
| Alan  | `szmyty@gmail.com`    | Assign to `Administrators` group on first login. |

---

### Dungeon Master

**Purpose:** Campaign administration.

**Wiki.js mapping:** Custom `Dungeon Master` group.

**Responsibilities:**
- Build and maintain world lore
- Create and manage NPCs
- Prepare encounters and secret locations
- Manage hidden campaign information
- Review player-submitted content
- Prepare future arcs and campaign planning

**Permissions:**
- `read:pages` — Read all wiki pages
- `write:pages` — Create and edit pages
- `manage:pages` — Move and rename pages
- `delete:pages` — Delete pages
- `read:assets` — View and download assets
- `write:assets` — Upload new assets
- `manage:assets` — Rename and delete assets
- `read:comments` — Read comments
- `write:comments` — Post comments
- `manage:comments` — Manage all comments
- `read:source` — View page source

**Page rules:** Allow all paths including `/dm/` (DM-only content namespace).

**Initial placeholder member:**

| Name    | Email                                    | Notes                                            |
|---------|------------------------------------------|--------------------------------------------------|
| Mitchell | `placeholder-dm@gmail.com`              | Replace with Mitchell's actual Google account.   |

---

### Player

**Purpose:** Campaign participant access.

**Wiki.js mapping:** Custom `Player` group.

**Responsibilities:**
- Read published campaign lore
- Maintain own character page
- Create session journals
- Upload character artwork
- Suggest edits and leave comments

**Permissions:**
- `read:pages` — Read published pages
- `write:pages` — Create and edit pages (restricted by page rules)
- `read:assets` — View and download assets
- `write:assets` — Upload new assets
- `read:comments` — Read comments
- `write:comments` — Post comments

**Page rules (evaluated in order):**
1. **Deny** read and write on `/dm/` namespace — Players must never see DM content.
2. **Allow** read on `/` (all public content).
3. **Allow** write on `/characters/` — Players may edit their own character pages.
4. **Allow** write on `/journals/` — Players may create session journals.

**Note:** Wiki.js does not enforce per-user ownership natively. The `/characters/` and `/journals/` write rules grant write access to all Players in those namespaces. Ownership enforcement (editing only one's own page) relies on community trust in the initial deployment. Fine-grained ownership may be added in a future version.

**Initial placeholder members:**

| Name                  | Email                                       | Notes                                          |
|-----------------------|---------------------------------------------|------------------------------------------------|
| Alan (Starwhisper)    | `szmyty@gmail.com`                          | Also holds Platform Administrator role.        |
| Kevin                 | `placeholder-kevin@gmail.com`               | Replace with Kevin's actual Google account.    |
| Christian             | `placeholder-christian@gmail.com`           | Replace with Christian's actual Google account.|
| Tom                   | `placeholder-tom@gmail.com`                 | Replace with Tom's actual Google account.      |

---

### Viewer

**Purpose:** Read-only access.

**Wiki.js mapping:** Custom `Viewer` group.

**Responsibilities:**
- Browse public campaign information
- Read published lore, character pages, and session journals
- View maps and artwork

**Permissions:**
- `read:pages` — Read published pages
- `read:assets` — View and download assets
- `read:comments` — Read comments

**Page rules:**
1. **Deny** read on `/dm/` namespace — Viewers must never see DM content.
2. **Allow** read on `/` (all public content).

**Initial members:** None. Viewers are added on a case-by-case basis.

---

### Anonymous

Anonymous (unauthenticated) users have no access by default.

Public access is disabled until explicitly enabled. Wiki.js Guest group permissions should remain empty or restricted to prevent unauthorized access.

---

## Content Namespaces

| Namespace       | Accessible by                         | Description                              |
|-----------------|---------------------------------------|------------------------------------------|
| `/`             | All authenticated roles (read)        | Public wiki root                         |
| `/characters/`  | All roles (read); Player, DM (write)  | Character pages                          |
| `/journals/`    | All roles (read); Player, DM (write)  | Session journals                         |
| `/lore/`        | All roles (read); DM (write)          | Published world lore                     |
| `/dm/`          | Platform Administrator, DM only       | Hidden campaign notes, secret encounters, NPC planning, hidden maps |

---

## Hidden Content

The `/dm/` namespace is used for all Dungeon Master-only content:

- Future campaign arcs
- Secret NPC identities
- Encounter planning notes
- Hidden maps and locations
- Secret factions
- Treasure and puzzle solutions
- Worldbuilding notes
- Internal campaign timeline

Players and Viewers are explicitly denied access to all pages and assets under `/dm/`.

---

## Onboarding Process

### Adding a New Platform Administrator

1. User signs in with Google OAuth for the first time.
2. Navigate to **Admin → Users** in the Wiki.js admin panel.
3. Find the user by email.
4. Assign the user to the **Administrators** group.
5. Remove the user from any default group (e.g., Guests) if automatically assigned.

### Adding a New Dungeon Master

1. User signs in with Google OAuth for the first time.
2. Navigate to **Admin → Users**.
3. Find the user by email.
4. Assign the user to the **Dungeon Master** group.
5. Remove the user from any default group.

### Adding a New Player

1. User signs in with Google OAuth for the first time.
2. Navigate to **Admin → Users**.
3. Find the user by email.
4. Assign the user to the **Player** group.
5. Remove the user from any default group.
6. Create a character page for the player under `/characters/<player-name>/`.

### Adding a Viewer

1. User signs in with Google OAuth for the first time.
2. Navigate to **Admin → Users**.
3. Find the user by email.
4. Assign the user to the **Viewer** group.
5. Remove the user from any default group.

---

## Placeholder Accounts

The following placeholder emails are used in bootstrap documentation and seed scripts. Replace each with the actual Google account email address before onboarding that user.

| Role                  | Placeholder Email                   | Replace with                        |
|-----------------------|-------------------------------------|-------------------------------------|
| Dungeon Master        | `placeholder-dm@gmail.com`          | Mitchell's actual Google account    |
| Player (Kevin)        | `placeholder-kevin@gmail.com`       | Kevin's actual Google account       |
| Player (Christian)    | `placeholder-christian@gmail.com`   | Christian's actual Google account   |
| Player (Tom)          | `placeholder-tom@gmail.com`         | Tom's actual Google account         |

Alan's account (`szmyty@gmail.com`) is confirmed and does not require a placeholder.

---

## Bootstrap

The `scripts/bootstrap/seed-groups.sql` script creates the initial groups (Dungeon Master, Player, Viewer) in the Wiki.js PostgreSQL database.

Run this script **after** Wiki.js has completed its first boot and initialized its schema:

```bash
docker compose exec postgres psql \
  -U "${POSTGRES_USER}" \
  -d "${POSTGRES_DB}" \
  -f /path/to/seed-groups.sql
```

Or from the host with the file copied in:

```bash
docker compose exec -T postgres psql \
  -U wikijs \
  -d wikidb \
  < scripts/bootstrap/seed-groups.sql
```

The script is idempotent — it safely skips group creation if a group with the same name already exists.

After running the seed, assign placeholder users to their groups through the Wiki.js Admin panel as described in the [Onboarding Process](#onboarding-process) section above.

---

## RBAC Verification Checklist

Run this checklist after initial onboarding and after any permissions change:

- [ ] `Administrators` group contains `szmyty@gmail.com`.
- [ ] `Dungeon Master` group contains the current DM account (placeholder until final email is known).
- [ ] `Player` group contains:
  - `szmyty@gmail.com` (Alan / Starwhisper)
  - Kevin account (placeholder or final)
  - Christian account (placeholder or final)
  - Tom account (placeholder or final)
- [ ] `Viewer` group contains only explicitly approved read-only users.
- [ ] `/dm/` is accessible only by Platform Administrator and Dungeon Master.
- [ ] Players can write in `/characters/` and `/journals/` but cannot access `/dm/`.
- [ ] Viewers can read public namespaces but cannot write anywhere.

---

## Future Enhancements

- Per-user character page ownership enforced at the application level.
- Multiple campaigns with isolated namespaces and separate DM groups.
- Guest player access with temporary permissions.
- Approval workflows for Player-submitted edits in shared lore sections.
- Fine-grained namespace permissions per campaign arc.
