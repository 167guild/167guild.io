# Templates

## Overview

This document describes the wiki content templates used throughout the 167 Guild Wiki.

Templates define the structure of every major entity in the world. They ensure that content remains consistent as the campaign grows, and that related entities are cross-linked to form an interconnected knowledge graph.

Templates live in [`wiki/templates/`](../wiki/templates/). Copy the relevant template when creating a new wiki page and replace the placeholder values with real content.

---

## Philosophy

The 167 Guild Wiki is designed to feel like exploring a living world rather than reading a flat document collection.

Every entity is a node. Every link between entities is an edge. As contributors add content over time, the world becomes richer and more discoverable — not harder to navigate.

Templates enforce this philosophy by:

- Providing consistent field structures across all entity types.
- Embedding cross-link placeholders that guide contributors to reference related entities.
- Separating public content from DM-only content through namespace conventions.

---

## Templates

### [Character](../wiki/templates/character.md)

**Path:** `wiki/templates/character.md`

**Purpose:** Defines the structure for player character pages.

**Wiki namespace:** `/characters/<character-slug>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Name | Character's full name |
| Portrait | Character artwork (uploaded asset) |
| Race | Linked to `/lore/races/` |
| Class | Linked to `/lore/classes/` |
| Background | Character background from the Player's Handbook |
| Biography | Backstory and origin narrative |
| Personality | Traits, ideals, bonds, and flaws |
| Relationships | Links to NPCs, Organizations, and other Characters |
| Inventory | Significant items, linked to `/lore/items/` |
| Abilities | Class features, racial traits, spells |
| Session History | Links to sessions the character participated in |
| Personal Journal | Links to journal entries under `/journals/` |

**Cross-links encouraged:**
- Home city or region → `/lore/locations/`
- Organization membership → `/lore/organizations/`
- Known NPCs → `/lore/npcs/`
- Session appearances → `/campaign/sessions/`
- Owned items → `/lore/items/`

---

### [NPC](../wiki/templates/npc.md)

**Path:** `wiki/templates/npc.md`

**Purpose:** Defines the structure for non-player character pages.

**Wiki namespace:** `/lore/npcs/<npc-slug>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Name | NPC's full name |
| Portrait | NPC artwork (uploaded asset) |
| Biography | Public-facing backstory and role in the world |
| Occupation | What this NPC does — e.g., Merchant, Guard Captain |
| Faction | Linked to `/lore/factions/` |
| Location | Current or home location, linked to `/lore/locations/` |
| Relationships | Links to Characters, other NPCs, and Organizations |

**DM-only content:**

Each NPC template includes a commented-out section referencing the DM namespace. Move any of the following to `/dm/npcs/<npc-slug>/`:

- Secret identity or true allegiance
- Hidden motivations and goals
- Future plot role
- Encounter statistics and tactics
- Private backstory not shared with players

**Cross-links encouraged:**
- Home location → `/lore/locations/`
- Affiliated faction → `/lore/factions/`
- Session appearances → `/campaign/sessions/`

---

### [Location](../wiki/templates/location.md)

**Path:** `wiki/templates/location.md`

**Purpose:** Defines the structure for location pages (cities, dungeons, regions, landmarks, etc.).

**Wiki namespace:** `/lore/locations/<location-slug>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Banner | Establishing landscape or artwork image |
| Description | Narrative description of the location |
| History | Founding story and notable historical events |
| Region | Parent region, linked to `/lore/regions/` |
| Population | Approximate population or settlement descriptor |
| Organizations | Organizations present here, linked to `/lore/organizations/` |
| NPCs | Notable residents, linked to `/lore/npcs/` |
| Points of Interest | Named landmarks or sub-areas within the location |
| Maps | Attached map images |

**Cross-links encouraged:**
- Parent region → `/lore/regions/`
- Resident NPCs → `/lore/npcs/`
- Organizations present → `/lore/organizations/`
- Associated factions → `/lore/factions/`
- Historical events → `/campaign/timeline`

---

### [Organization](../wiki/templates/organization.md)

**Path:** `wiki/templates/organization.md`

**Purpose:** Defines the structure for organizations (guilds, governments, noble houses, religious orders, criminal syndicates, etc.).

**Wiki namespace:** `/lore/organizations/<org-slug>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Crest | Organization emblem or seal (uploaded asset) |
| Description | Purpose, culture, and reputation |
| Leadership | Current and notable past leaders, linked to `/lore/npcs/` |
| Members | Notable members, linked to `/characters/` or `/lore/npcs/` |
| Headquarters | Primary base of operations, linked to `/lore/locations/` |
| Allies | Allied organizations, linked to `/lore/organizations/` |
| Enemies | Rival organizations, linked to `/lore/organizations/` or `/lore/factions/` |
| History | Founding story and major milestones |

**Cross-links encouraged:**
- Headquarters → `/lore/locations/`
- Member characters → `/characters/`
- Allied or rival factions → `/lore/factions/`
- Historical events → `/campaign/timeline`

---

### [Faction](../wiki/templates/faction.md)

**Path:** `wiki/templates/faction.md`

**Purpose:** Defines the structure for political, military, or ideological factions.

**Wiki namespace:** `/lore/factions/<faction-slug>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Banner | Faction heraldry or symbol (uploaded asset) |
| Description | What the faction is and how it operates |
| Goals | Short-term and long-term objectives |
| Territory | Regions or locations controlled, linked to `/lore/locations/` or `/lore/regions/` |
| Allies | Allied factions or organizations |
| Rivals | Opposing factions or organizations |
| Important Members | Key figures, linked to `/lore/npcs/` or `/characters/` |

**Cross-links encouraged:**
- Territory → `/lore/locations/`, `/lore/regions/`
- Ally/rival factions → `/lore/factions/`
- Ally/rival organizations → `/lore/organizations/`
- Member NPCs → `/lore/npcs/`

---

### [Session](../wiki/templates/session.md)

**Path:** `wiki/templates/session.md`

**Purpose:** Defines the structure for campaign session records.

**Wiki namespace:** `/campaign/sessions/session-<number>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Session Number | Sequential session number |
| Summary | Narrative account of events during the session |
| Participants | Players and their characters, linked to `/characters/` |
| Locations | Locations visited, linked to `/lore/locations/` |
| NPCs | NPCs encountered or mentioned, linked to `/lore/npcs/` |
| Loot | Items found or awarded, linked to `/lore/items/` |
| Notes | Loose threads and important details |
| Journal | Links to character journal entries in `/journals/` |

**Cross-links encouraged:**
- Characters present → `/characters/`
- Locations visited → `/lore/locations/`
- NPCs encountered → `/lore/npcs/`
- Items obtained → `/lore/items/`
- Timeline events → `/campaign/timeline`

---

### [Timeline Event](../wiki/templates/timeline-event.md)

**Path:** `wiki/templates/timeline-event.md`

**Purpose:** Defines the structure for individual entries on the world timeline.

**Wiki namespace:** `/campaign/timeline/<event-slug>/` or anchors on a single timeline page.

**Fields:**

| Field | Description |
|-------|-------------|
| Date | In-world date, era, or relative descriptor |
| Event | Concise one-sentence summary of what happened |
| Description | Full account of the event and its context |
| Related Entities | Characters, NPCs, Locations, Organizations, and Factions involved |
| Session | The session where this event occurred, if applicable |

**Cross-links encouraged:**
- Involved characters → `/characters/`
- Involved NPCs → `/lore/npcs/`
- Location where it occurred → `/lore/locations/`
- Organizations involved → `/lore/organizations/`
- Originating session → `/campaign/sessions/`

---

### [Item](../wiki/templates/item.md)

**Path:** `wiki/templates/item.md`

**Purpose:** Defines the structure for item pages (weapons, armor, artifacts, consumables, etc.).

**Wiki namespace:** `/lore/items/<item-slug>/`

**Fields:**

| Field | Description |
|-------|-------------|
| Name | Item name |
| Artwork | Item illustration (uploaded asset) |
| Description | What it looks like and what makes it notable |
| Type | Weapon / Armor / Consumable / Tool / Artifact / Misc |
| Owner | Current owner, linked to `/characters/` or `/lore/npcs/` |
| Location | Where the item is currently kept, linked to `/lore/locations/` |
| History | Provenance, how it changed hands, and where it was found |

**Cross-links encouraged:**
- Current owner → `/characters/` or `/lore/npcs/`
- Location where kept or found → `/lore/locations/`
- Session where obtained → `/campaign/sessions/`

---

## Cross-Linking Strategy

The following relationships are the most important cross-links to establish as the wiki grows:

| Source | Links to | Field |
|--------|----------|-------|
| Character | Organization | Membership |
| Character | Location | Home city / region |
| Character | NPC | Known associates |
| Character | Session | Session history |
| NPC | Location | Home / current location |
| NPC | Faction | Faction membership |
| NPC | Session | Session appearances |
| Session | Character | Participants |
| Session | Location | Locations visited |
| Session | NPC | Encounters |
| Session | Timeline Event | Events produced |
| Location | NPC | Residents |
| Location | Organization | Organizations present |
| Location | Faction | Territorial control |
| Organization | Location | Headquarters |
| Faction | Location | Territory |
| Faction | Organization | Allies / Enemies |
| Timeline Event | Session | Originating session |
| Item | Character | Owner |
| Item | Location | Where kept or found |

---

## Contributing Guidelines

1. **Copy the template.** Do not edit the template file itself. Copy its content to a new wiki page.
2. **Replace all placeholders.** Every `[placeholder]` should be replaced with real content or removed if not applicable.
3. **Link generously.** Every mention of a named entity (character, NPC, location, etc.) should be a wiki link if a page for that entity exists.
4. **Use the correct namespace.** Place pages in the namespace that matches their type (see each template's **Wiki namespace** above).
5. **Keep DM content separate.** Any information intended only for the Dungeon Master belongs in the `/dm/` namespace, not in the public-facing page.
6. **Do not add campaign lore to templates.** The template files in `wiki/templates/` are structural scaffolding only. Campaign content lives in Wiki.js pages.

---

## Namespace Reference

| Namespace | Content |
|-----------|---------|
| `/characters/` | Player character pages |
| `/lore/npcs/` | Non-player character pages |
| `/lore/locations/` | Location pages |
| `/lore/regions/` | Region overview pages |
| `/lore/organizations/` | Organization pages |
| `/lore/factions/` | Faction pages |
| `/lore/items/` | Item pages |
| `/lore/races/` | Race pages |
| `/lore/classes/` | Class pages |
| `/campaign/sessions/` | Session records |
| `/campaign/timeline` | World timeline |
| `/journals/` | Player and character journals |
| `/dm/` | DM-only content (restricted access) |

---

## See Also

- [Authorization](authorization.md) — Role-based access control and namespace permissions.
- [Content Model Specification](../.github/specs/content-model.spec.md) — Source of truth for the information architecture.
