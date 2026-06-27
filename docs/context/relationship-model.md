# 🔗 Relationship Model

## Overview

This document defines the typed relationships that connect world entities to one another.

Relationships are directed edges in the world context graph. Each relationship has a source entity type, a target entity type, and a relationship label that describes the nature of the connection.

---

## Design Principles

- **Directed.** Every relationship has a clear source and target.
- **Typed.** Relationship labels are drawn from a defined vocabulary to enable programmatic traversal.
- **Bidirectional where practical.** Inverse relationships are noted so traversal can proceed in either direction.
- **Extensible.** New relationship types may be added as the world grows without invalidating existing ones.

---

## Relationship Record Format

Each relationship stored on an entity uses the following structure:

| Field | Type | Description |
|-------|------|-------------|
| `target_id` | string | The slug of the target entity |
| `target_type` | enum | The entity type of the target |
| `relationship_type` | string | The label describing the relationship |
| `notes` | string | Optional additional context |
| `visibility` | enum | `public` or `dm_only` — defaults to the source entity's visibility |

---

## Relationships by Entity Type

### Character

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `member_of` | Organization | The character is a member of this organization |
| `resides_in` | Location | The character's home city, town, or region |
| `allied_with` | Character | A fellow adventurer or trusted ally |
| `knows` | NPC | A named NPC the character has a relationship with |
| `participated_in` | Session | A session the character appeared in |
| `carries` | Item | A significant item in the character's possession |
| `worships` | Deity | A deity the character follows |

---

### NPC

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `resides_in` | Location | The NPC's current or home location |
| `member_of` | Faction | A faction the NPC belongs to |
| `affiliated_with` | Organization | An organization the NPC is associated with |
| `appeared_in` | Session | Sessions the NPC was encountered in |
| `allied_with` | NPC | Another NPC this one is friendly with |
| `rivals` | NPC | Another NPC this one is hostile to or competes with |
| `knows` | Character | A player character this NPC has a relationship with |

---

### Location

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `contained_in` | Region | The region this location belongs to |
| `contains` | Location | Sub-locations or points of interest within this location |
| `home_to` | NPC | Named NPCs who reside here |
| `base_of` | Organization | Organizations headquartered here |
| `controlled_by` | Faction | Factions with territorial control |
| `connected_to` | Location | Nearby locations reachable from here |
| `site_of` | Event | Historical or campaign events that occurred here |

---

### Organization

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `headquartered_in` | Location | Primary base of operations |
| `has_member` | Character | Player characters who belong to this organization |
| `has_member` | NPC | NPCs who belong to this organization |
| `allied_with` | Organization | Allied organizations |
| `rivals` | Organization | Rival or enemy organizations |
| `rivals` | Faction | Rival or enemy factions |
| `controls` | Location | Locations under organizational control |

---

### Faction

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `allied_with` | Faction | Factions this faction cooperates with |
| `rivals` | Faction | Factions this faction opposes |
| `controls_territory` | Location | Locations within this faction's territory |
| `allied_with` | Organization | Organizations aligned with this faction |
| `has_member` | NPC | Notable NPCs belonging to this faction |

---

### Session

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `featured_character` | Character | Player characters who participated |
| `took_place_in` | Location | Locations visited during the session |
| `encountered_npc` | NPC | NPCs the party interacted with |
| `produced_event` | Event | Campaign events that arose from this session |
| `involves_item` | Item | Significant items that appeared in the session |

---

### Item

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `owned_by` | Character | The current possessor |
| `found_in` | Location | Where the item was discovered |
| `crafted_by` | NPC | The NPC who created this item |
| `associated_with` | Organization | Organizations tied to this item's history |

---

### Event / Timeline Entry

| Relationship | Target Type | Description |
|-------------|-------------|-------------|
| `involved_character` | Character | Player characters involved |
| `involved_npc` | NPC | NPCs involved |
| `occurred_in` | Location | Where the event took place |
| `caused_by` | Event | A prior event that led to this one |
| `resulted_in` | Event | A subsequent event that this one caused |
| `recorded_in` | Session | The session where this event was played out |

---

## Relationship Vocabulary

The following labels are the canonical relationship type strings to use when recording relationships.

| Label | Meaning |
|-------|---------|
| `member_of` | Entity belongs to a group or organization |
| `has_member` | Group or organization contains this entity |
| `resides_in` | Entity's home or current location |
| `home_to` | Location hosts this entity as a resident |
| `allied_with` | Friendly or cooperative relationship |
| `rivals` | Hostile or competing relationship |
| `knows` | Acquaintance or named relationship |
| `participated_in` | Entity was present or active in a session or event |
| `featured_character` | Session included this character |
| `carries` | Entity possesses this item |
| `owned_by` | Item is in this entity's possession |
| `found_in` | Item was located here |
| `crafted_by` | Item was created by this NPC |
| `headquartered_in` | Organization's primary base |
| `base_of` | Location is the base for this organization |
| `controls` | Entity exercises authority over this location |
| `controls_territory` | Faction holds this location as territory |
| `controlled_by` | Location is under this entity's control |
| `contained_in` | Entity exists within this larger entity |
| `contains` | Entity encompasses these sub-entities |
| `connected_to` | Location is geographically adjacent or reachable |
| `site_of` | Location is where this event occurred |
| `occurred_in` | Event took place at this location |
| `took_place_in` | Session events occurred at this location |
| `involved_character` | Character was part of this event |
| `involved_npc` | NPC was part of this event |
| `encountered_npc` | Session included an encounter with this NPC |
| `produced_event` | Session generated this event |
| `involves_item` | Session featured this item |
| `associated_with` | General association or connection |
| `affiliated_with` | Loose or informal affiliation |
| `worships` | Character or NPC follows this deity |
| `caused_by` | This event was preceded by the referenced event |
| `resulted_in` | This event led to the referenced event |
| `recorded_in` | Event was played out in this session |

---

## See Also

- [entity-schema.md](entity-schema.md) — field definitions for each entity type.
- [branding-metadata.md](branding-metadata.md) — visual metadata attached to entities.
- [Content Model Specification](../../.github/specs/content-model.spec.md) — source of truth for entity types and cross-linking philosophy.
- [Templates](../templates.md) — wiki templates that express these relationships as human-readable cross-links.
