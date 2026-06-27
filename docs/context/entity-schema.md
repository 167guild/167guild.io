# 📋 Entity Schema

## Overview

This document defines the common metadata fields shared across world entities.

These fields form the canonical vocabulary used to describe any entity in the 167 Guild world, independently of how or where it is rendered.

---

## Design Principles

- **Portable.** Metadata is defined independently of Wiki.js or any other content platform.
- **Composable.** Fields are layered — core fields apply to all entities, type-specific fields extend them.
- **AI-ready.** Fields are chosen to produce rich, useful context for prompt generation and artwork workflows.
- **Human-readable.** Documentation-first: every field is described in plain language for contributors.

---

## Core Fields

These fields apply to every entity type in the world.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `name` | string | yes | The canonical name of the entity |
| `slug` | string | yes | URL-safe identifier, unique within the entity type |
| `entity_type` | enum | yes | The type of entity (see [Entity Types](#entity-types)) |
| `description` | string | yes | A concise summary of the entity (1–3 sentences) |
| `visibility` | enum | yes | `public`, `dm_only`, or `archived` |
| `tags` | string[] | no | Free-form labels for search and grouping |
| `relationships` | Relationship[] | no | Links to related entities (see [relationship-model.md](relationship-model.md)) |
| `associated_artwork` | string[] | no | Paths or URLs to artwork associated with this entity |
| `created_at` | date | no | When this entity record was first created |
| `updated_at` | date | no | When this entity record was last modified |

---

## Entity Types

The following entity types are supported by the content model.

| Entity Type | Description |
|-------------|-------------|
| `world` | The top-level world container |
| `campaign` | A campaign running within the world |
| `session` | A single play session within a campaign |
| `character` | A player-controlled character |
| `npc` | A non-player character |
| `organization` | A guild, government, order, or other formal group |
| `faction` | A politically or ideologically aligned group |
| `location` | A named place in the world |
| `region` | A large geographic area containing multiple locations |
| `city` | A populated settlement |
| `landmark` | A notable feature within a location or region |
| `dungeon` | An explorable underground or enclosed structure |
| `item` | A physical object with significance in the world |
| `weapon` | A weapon carried or used by a character or NPC |
| `armor` | Protective gear worn by a character or NPC |
| `spell` | A magical effect or formula |
| `ability` | A special skill, trait, or power |
| `deity` | A god, demigod, or divine entity |
| `creature` | A monster, beast, or non-sentient entity |
| `race` | A playable or notable species in the world |
| `class` | A character class or archetype |
| `event` | A significant occurrence in the world or campaign |
| `timeline_entry` | A dated entry on the world timeline |
| `map` | A geographic or architectural map |
| `artwork` | A piece of artwork associated with the world |
| `journal` | A personal record written by a character or NPC |

---

## Extended Fields by Entity Type

### Character

Fields extending the core schema for player-controlled characters.

| Field | Type | Description |
|-------|------|-------------|
| `race` | ref → `race` | Linked race entity |
| `class` | ref → `class` | Linked class entity |
| `background` | string | Character background from the Player's Handbook |
| `biography` | string | Backstory and origin narrative |
| `personality_traits` | string[] | Defining personality traits |
| `ideals` | string[] | Core beliefs and driving principles |
| `bonds` | string[] | Connections that anchor the character |
| `flaws` | string[] | Weaknesses or vulnerabilities |
| `home_location` | ref → `location` | Home city or region |
| `session_history` | ref[] → `session` | Sessions the character appeared in |
| `visual_keywords` | string[] | Descriptive visual terms for artwork generation |
| `mood` | string[] | Emotional tone or atmosphere associated with the character |
| `color_palette` | string[] | Dominant colors associated with the character |
| `symbols` | string[] | Emblems, insignia, or recurring motifs |

---

### NPC

Fields extending the core schema for non-player characters.

| Field | Type | Description |
|-------|------|-------------|
| `occupation` | string | Role or profession in the world |
| `status` | enum | `alive`, `dead`, `unknown`, `missing` |
| `home_location` | ref → `location` | Where the NPC currently resides |
| `faction_membership` | ref[] → `faction` | Factions the NPC belongs to |
| `session_appearances` | ref[] → `session` | Sessions the NPC appeared in |
| `visual_keywords` | string[] | Descriptive visual terms for artwork generation |
| `mood` | string[] | Emotional tone associated with the NPC |
| `color_palette` | string[] | Dominant colors associated with the NPC |

---

### Location

Fields extending the core schema for named places.

| Field | Type | Description |
|-------|------|-------------|
| `location_type` | enum | `region`, `city`, `landmark`, `dungeon`, `wilderness`, `other` |
| `parent_region` | ref → `region` | Containing region, if any |
| `population` | string | Approximate population or occupancy |
| `terrain` | string[] | Physical terrain characteristics (e.g., `forested`, `mountainous`, `coastal`) |
| `climate` | string | Prevailing climate (e.g., `temperate`, `arctic`, `arid`) |
| `architecture_style` | string[] | Dominant architectural styles present |
| `magic_affinity` | string[] | Magical properties or affinities of the location |
| `technology_level` | string | Relative level of technology or advancement |
| `culture` | string[] | Cultural influences shaping the location |
| `visual_keywords` | string[] | Descriptive visual terms for artwork generation |
| `mood` | string[] | Atmospheric and emotional tone |
| `color_palette` | string[] | Dominant colors in the environment |
| `symbols` | string[] | Recurring motifs, emblems, or landmarks |

---

### Organization

Fields extending the core schema for formal groups.

| Field | Type | Description |
|-------|------|-------------|
| `org_type` | enum | `guild`, `government`, `noble_house`, `criminal`, `religious`, `military`, `other` |
| `headquarters` | ref → `location` | Primary base of operations |
| `founding_date` | string | In-world founding date or era |
| `status` | enum | `active`, `disbanded`, `secret`, `legendary` |
| `visual_keywords` | string[] | Descriptive visual terms for artwork generation |
| `color_palette` | string[] | Organizational colors |
| `symbols` | string[] | Crests, insignia, or heraldry |

---

### Session

Fields extending the core schema for play sessions.

| Field | Type | Description |
|-------|------|-------------|
| `session_number` | integer | Sequential session number within the campaign |
| `date_played` | date | Real-world date the session occurred |
| `in_world_date` | string | In-world date or era of the session events |
| `summary` | string | Brief summary of what occurred during the session |
| `dm_notes` | string | DM-only notes (visibility: `dm_only`) |

---

## Visibility Values

| Value | Description |
|-------|-------------|
| `public` | Visible to all authenticated users |
| `dm_only` | Visible to Dungeon Masters only |
| `archived` | Retired content, hidden from default navigation |

---

## See Also

- [relationship-model.md](relationship-model.md) — how entities link to one another.
- [branding-metadata.md](branding-metadata.md) — visual and atmospheric metadata for artwork generation.
- [Content Model Specification](../../.github/specs/content-model.spec.md) — source of truth for entity types and philosophy.
