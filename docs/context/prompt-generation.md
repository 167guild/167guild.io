# ✨ Prompt Generation Strategy

## Overview

This document describes how structured world context metadata will eventually be assembled into AI prompts for artwork generation and other AI-assisted workflows.

No implementation is required at this stage. This document establishes the conceptual model and vocabulary so that future tooling has a clear specification to implement against.

---

## Guiding Principle

A prompt is not a sentence — it is an assembly of structured context.

The world context graph provides rich, typed metadata for every entity: names, descriptions, visual keywords, emotional tones, materials, colors, motifs, and relationships.

A prompt generation pipeline takes these structured fields and assembles them into coherent, model-appropriate prompts — one or more per entity, per use case.

The quality of the output depends on the quality of the structured input.

---

## Prompt Types

The following prompt types are anticipated for future implementation.

| Prompt Type | Purpose | Primary Source Fields |
|-------------|---------|----------------------|
| Character portrait | Generate artwork depicting a character | `visual_keywords`, `mood`, `color_palette`, `symbols`, `emotional_tone`, `composition` |
| NPC portrait | Generate artwork depicting an NPC | `visual_keywords`, `mood`, `color_palette`, `lighting`, `atmosphere` |
| Location scene | Generate an establishing shot of a location | `atmosphere`, `architecture`, `terrain`, `climate`, `lighting`, `weather`, `colors`, `textures` |
| Organization crest | Generate heraldry or insignia | `symbols`, `colors`, `motifs`, `materials` |
| Session banner | Generate a banner or header for a session recap | `locations`, `featured_characters`, `emotional_tone`, `atmosphere` |
| World banner | Generate a hero image for the world or campaign | World-level branding fields |
| Theme generation | Generate a CSS/design theme inspired by the world | `color_palette`, `motifs`, `atmosphere`, `materials` |

---

## Assembly Strategy

### Step 1: Select Entity and Prompt Type

Identify the entity to generate for and the type of prompt to produce.

**Example:** Generate a portrait for the character "Kael Ashford".

---

### Step 2: Gather Entity Fields

Extract the relevant fields from the entity's context record.

**Example fields for a character portrait:**

```
name: Kael Ashford
entity_type: character
description: A disgraced knight who now operates as a wandering sellsword.
visual_keywords: [scarred face, heavy cloak, broken sword hilt, weathered armor]
mood: [brooding, vigilant, weary]
color_palette: [dark charcoal, faded grey, deep burgundy]
symbols: [broken sword, crow feather]
emotional_tone: [melancholic, resolute]
composition: [three-quarter portrait, dramatic lighting, close on face]
```

---

### Step 3: Gather Relationship Context

Traverse the relationship graph to enrich the prompt with context from related entities.

**Examples:**

- If the character is `member_of` an organization → include the organization's `symbols` and `color_palette`.
- If the character `resides_in` a location → include the location's `atmosphere` and `lighting`.
- If the character has appeared in recent sessions → include events or moods from those sessions.

This step makes prompts world-aware, not just entity-aware.

---

### Step 4: Apply World-Level Branding

Layer the world's global branding metadata onto the prompt.

This ensures all generated artwork shares a consistent visual language regardless of which entity is being depicted.

**Global branding fields to apply:**

- World `atmosphere`
- World `emotional_tone`
- World `negative_prompts`
- World `lighting` defaults

---

### Step 5: Assemble the Prompt

Combine the collected fields into a structured prompt string appropriate for the target model.

**Assembled portrait prompt example:**

```
A brooding, weary sellsword with a scarred face, wearing weathered charcoal armor
and a heavy faded grey cloak. A broken sword hilt hangs at his hip. A crow feather
is tucked into his collar. Deep burgundy accents. Dramatic side lighting.
Three-quarter portrait composition. Melancholic and resolute mood.
Dark fantasy illustration. Highly detailed. Cinematic lighting.

Negative prompt: cartoon, anime, bright colors, modern clothing, low quality, blurry.
```

---

### Step 6: Apply Negative Prompts

Append negative prompts from:

1. The entity's own `negative_prompts` field (if any).
2. The world-level `negative_prompts`.

Merge and deduplicate before appending.

---

## Context Export Format

When the prompt generation pipeline is implemented, entities should be exported in a structured format suitable for programmatic assembly.

The anticipated export format is JSON or YAML, with one file per entity or one bundled context file per entity type.

**Example entity export (YAML):**

```yaml
slug: kael-ashford
name: Kael Ashford
entity_type: character
description: A disgraced knight who now operates as a wandering sellsword.
visibility: public
branding:
  visual_keywords: [scarred face, heavy cloak, broken sword hilt, weathered armor]
  mood: [brooding, vigilant, weary]
  color_palette: [dark charcoal, faded grey, deep burgundy]
  symbols: [broken sword, crow feather]
  atmosphere: [dark, gritty, introspective]
  emotional_tone: [melancholic, resolute]
  lighting: [dramatic side lighting, torchlight]
  composition: [three-quarter portrait, close on face]
  negative_prompts: [cartoon, bright colors]
relationships:
  - target_id: the-iron-warden
    target_type: npc
    relationship_type: knows
    notes: Former commanding officer
  - target_id: sunken-market
    target_type: location
    relationship_type: resides_in
    notes: Current base of operations
```

---

## Future Pipeline Components

When implementation begins, the prompt generation pipeline is expected to include the following components.

| Component | Responsibility |
|-----------|---------------|
| Context exporter | Serializes entity records from the wiki database to structured files |
| Relationship resolver | Traverses the graph to collect related entity context |
| Prompt assembler | Combines entity fields and relationship context into a prompt string |
| Model adapter | Formats the assembled prompt for a specific target model (e.g., Stable Diffusion, DALL·E, Midjourney) |
| Negative prompt merger | Merges and deduplicates entity and world-level negative prompts |
| Prompt pack publisher | Bundles prompts for batch generation or community sharing |

---

## Out of Scope (This Document)

The following are intentionally deferred:

- Implementing the context exporter.
- Implementing the prompt assembler.
- Integrating with any image generation API or model.
- Implementing vector search or RAG workflows.
- Generating any actual artwork.

These will be addressed in Phase 4 of the roadmap.

---

## See Also

- [entity-schema.md](entity-schema.md) — entity field definitions used as prompt source material.
- [relationship-model.md](relationship-model.md) — relationship traversal for enriched context.
- [branding-metadata.md](branding-metadata.md) — visual and atmospheric fields that form the core of generated prompts.
- [ROADMAP.md](../../ROADMAP.md) — Phase 4 tracks the AI and knowledge graph implementation.
