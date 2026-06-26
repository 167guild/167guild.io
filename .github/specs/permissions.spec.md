# 👑 Permissions Specification

## Purpose

This document defines the permission model for all users of the 167 Guild Wiki.

Permissions determine which users may view, create, edit, delete, or administer content throughout the wiki.

The permission model should be intuitive, secure, and require minimal ongoing administration.

---

# Roles

The wiki defines the following primary roles:

- Administrator
- Dungeon Master
- Player
- Viewer
- Anonymous (optional)

Roles inherit no permissions unless explicitly granted.

---

# Administrator

Purpose:

Platform administration.

Responsibilities:

- Configure the wiki.
- Manage authentication.
- Manage users.
- Manage roles.
- Configure backups.
- Configure integrations.
- Maintain infrastructure.

Administrators have unrestricted access.

---

# Dungeon Master

Purpose:

Campaign administration.

Responsibilities:

- Build the world.
- Maintain lore.
- Create NPCs.
- Prepare encounters.
- Manage hidden information.
- Review player submissions.

The Dungeon Master has full access to campaign content.

The Dungeon Master can view and edit hidden campaign information that Players cannot access.

---

# Player

Purpose:

Participate in the campaign.

Players may:

- View campaign content.
- Edit their own character.
- Create session journals.
- Upload artwork.
- Comment where enabled.
- Suggest edits.

Players may never access hidden DM content.

---

# Viewer

Purpose:

Read-only access.

Viewers may:

- Browse public campaign information.
- Read published lore.
- View maps.
- View artwork.

Viewers cannot modify content.

---

# Anonymous

Purpose:

Unauthenticated visitor.

Anonymous users should have no access by default.

Public access may be enabled later if desired.

---

# Permission Matrix

Administrator

- Full access

Dungeon Master

- Full campaign management
- Hidden world notes
- Hidden NPC notes
- Hidden encounter planning
- Hidden maps
- Hidden lore
- Hidden factions
- Review player edits

Player

- Read published lore
- Edit own character
- Create session notes
- Upload media
- Suggest edits

Viewer

- Read-only

Anonymous

- No access

---

# Hidden Content

The following content should support DM-only visibility:

- Future campaign arcs
- Secret NPC identities
- Encounter planning
- Hidden maps
- Secret locations
- Secret factions
- Treasure planning
- Puzzle solutions
- Worldbuilding notes
- Internal campaign timeline

Players must never see hidden content unless explicitly published.

---

# Ownership

Character pages should be owned.

The owner may:

- Edit biography
- Update inventory
- Update portrait
- Update character journal

Campaign-wide content remains owned by the Dungeon Master.

---

# Future Permissions

Potential future capabilities include:

- Multiple campaigns
- Multiple Dungeon Masters
- Guest players
- Temporary permissions
- Approval workflows
- Content review queues
- Archived campaigns

---

# Guiding Principle

The permission model should support collaborative storytelling while preserving the mystery and surprise that make tabletop roleplaying enjoyable.

The Dungeon Master should always have the tools necessary to prepare the world without exposing future events to the players.
