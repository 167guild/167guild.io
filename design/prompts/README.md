# 🤖 Artwork Prompt Generation Pipeline

## Goal

Define a deterministic, world-aware prompt assembly pipeline that converts structured world metadata into reusable artwork prompts.

This document specifies architecture only. It does not generate final artwork.

---

## Deterministic Assembly Order

Prompts MUST be assembled in the following order:

1. Prompt type selection (`entity`, `banner`, `character`, `npc`, `map`)
2. Core entity metadata injection (name, type, description)
3. Relationship context injection (linked entities)
4. World branding injection (global style constraints)
5. Prompt template rendering (type-specific)
6. Negative prompt merge (global + entity-level, deduplicated)

This fixed order ensures repeatable output from the same metadata input.

---

## Context Injection Contract

All generators consume a normalized context object:

```yaml
world:
  atmosphere: []
  emotional_tone: []
  color_palette: []
  lighting: []
  motifs: []
  negative_prompts: []
entity:
  id: ""
  type: ""
  name: ""
  description: ""
  branding:
    atmosphere: []
    emotional_tone: []
    lighting: []
    materials: []
    architecture: []
    colors: []
    motifs: []
    composition: []
    textures: []
    weather: []
    negative_prompts: []
relationships: []
```

---

## Prompt Types

- `entity`: base entity visual generation
- `banner`: campaign/session/world banners
- `character`: player character portraits
- `npc`: NPC portraits
- `map`: location and world map visuals

Type-specific templates are defined in:
- `../templates/artwork-prompt-templates.md`
- `../styles/global-style-prompts.md`

