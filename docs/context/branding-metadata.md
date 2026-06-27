# 🎨 Branding Metadata

## Overview

This document defines the visual and atmospheric metadata fields used to describe world entities for the purpose of future artwork generation.

Branding metadata captures how an entity *looks* and *feels* — independent of any specific artwork tool or generation pipeline. When AI generation workflows are implemented, they will draw on these fields as primary inputs.

---

## Design Principles

- **Descriptive, not prescriptive.** Fields describe qualities of the entity, not instructions to a specific model or tool.
- **Composable.** Multiple fields combine to produce a rich, multidimensional description.
- **Separated from lore.** Branding metadata supplements the entity schema — it does not replace narrative descriptions.
- **Negative space matters.** Negative prompts (things to avoid) are as important as positive descriptors.

---

## Branding Metadata Fields

These fields extend the entity schema for any entity where visual generation is anticipated.

| Field | Type | Description |
|-------|------|-------------|
| `atmosphere` | string[] | Overall atmospheric qualities (e.g., `haunting`, `grand`, `intimate`, `desolate`) |
| `emotional_tone` | string[] | The emotional experience evoked (e.g., `melancholic`, `triumphant`, `mysterious`, `serene`) |
| `lighting` | string[] | Lighting conditions and quality (e.g., `candlelight`, `harsh noon sun`, `bioluminescent`, `overcast`) |
| `materials` | string[] | Dominant physical materials (e.g., `weathered stone`, `polished obsidian`, `aged wood`, `rusted iron`) |
| `architecture` | string[] | Architectural styles or influences (e.g., `gothic spires`, `brutalist fortifications`, `elven organic curves`) |
| `colors` | string[] | Dominant color descriptors (e.g., `deep crimson`, `pale silver`, `earthy ochre`, `midnight blue`) |
| `motifs` | string[] | Recurring visual themes and symbols (e.g., `ravens`, `broken chains`, `twin moons`, `serpents`) |
| `composition` | string[] | Framing and compositional guidance (e.g., `wide establishing shot`, `low angle`, `portrait`, `aerial view`) |
| `textures` | string[] | Surface and environmental textures (e.g., `mossy cobblestones`, `cracked parchment`, `smooth marble`) |
| `weather` | string[] | Weather or environmental conditions present in scenes (e.g., `heavy fog`, `blizzard`, `golden dusk`) |
| `negative_prompts` | string[] | Visual qualities to explicitly avoid (e.g., `cartoonish`, `modern technology`, `bright cheerful colors`) |

---

## Entity-Type Branding Guidance

### Characters and NPCs

Branding metadata for characters captures the visual qualities a viewer should immediately associate with that individual.

**Key fields:** `atmosphere`, `emotional_tone`, `lighting`, `materials`, `colors`, `motifs`, `negative_prompts`

**Example:**

```yaml
name: "The Iron Warden"
entity_type: npc
branding:
  atmosphere: ["imposing", "stoic", "ancient"]
  emotional_tone: ["resolute", "melancholic"]
  lighting: ["harsh torchlight", "deep shadows"]
  materials: ["rusted iron", "cracked leather", "tarnished brass"]
  colors: ["dark grey", "deep rust", "faded gold"]
  motifs: ["broken chains", "worn crest", "sealed doors"]
  composition: ["three-quarter portrait", "low angle"]
  negative_prompts: ["cartoon", "bright colors", "modern armor"]
```

---

### Locations

Branding metadata for locations captures the sense of place — atmosphere, environment, and the emotional weight of being there.

**Key fields:** `atmosphere`, `emotional_tone`, `lighting`, `materials`, `architecture`, `colors`, `textures`, `weather`, `composition`, `negative_prompts`

**Example:**

```yaml
name: "The Sunken Market"
entity_type: location
branding:
  atmosphere: ["labyrinthine", "decaying grandeur", "underworld bazaar"]
  emotional_tone: ["uneasy", "curious", "desperate"]
  lighting: ["bioluminescent fungi", "oil lanterns", "no natural light"]
  materials: ["waterlogged timber", "crumbling plaster", "corroded copper"]
  architecture: ["subterranean arches", "improvised stalls", "collapsed vaulting"]
  colors: ["sickly green", "amber orange", "deep brown", "pale grey"]
  textures: ["mossy stone", "damp fabric", "rusted metal"]
  weather: ["perpetual mist", "dripping condensation"]
  composition: ["wide establishing shot", "low horizon", "figures in foreground"]
  negative_prompts: ["daylight", "cheerful crowds", "clean surfaces", "modern architecture"]
```

---

### Organizations and Factions

Branding metadata for organizations captures the visual identity — colors, symbols, and the impression they project.

**Key fields:** `colors`, `motifs`, `materials`, `emotional_tone`, `atmosphere`, `negative_prompts`

**Example:**

```yaml
name: "The Pale Accord"
entity_type: organization
branding:
  atmosphere: ["secretive", "aristocratic", "clinical"]
  emotional_tone: ["cold", "calculating", "controlled"]
  materials: ["white marble", "silver thread", "sealed wax"]
  colors: ["pale white", "silver", "ice blue"]
  motifs: ["balance scales", "sealed letters", "clasped hands"]
  negative_prompts: ["chaos", "fire", "blood", "warmth"]
```

---

## World-Level Branding

The world itself carries overarching branding metadata that individual entities inherit or complement.

World-level branding defines the visual register for the entire setting.

| Field | Value guidance |
|-------|---------------|
| `atmosphere` | The dominant feeling of being in this world |
| `emotional_tone` | The emotional register of the campaign overall |
| `color_palette` | The world's core color language |
| `lighting` | The dominant lighting conditions across the world |
| `motifs` | Symbols and themes that recur throughout the world |
| `negative_prompts` | Visual qualities that should never appear in world artwork |

---

## Negative Prompts

Negative prompts describe visual qualities to explicitly exclude from generated artwork.

They are as important as positive descriptors. Consistently applied negative prompts ensure that all generated artwork stays within the intended visual register of the world.

**Common global negative prompts for a dark fantasy world:**

- `cartoon`
- `anime`
- `photorealistic modern photography`
- `bright cheerful colors`
- `modern technology`
- `science fiction elements`
- `flat illustration`
- `low quality`
- `blurry`
- `oversaturated`

These should be defined at the world level and may be overridden or extended at the entity level.

---

## See Also

- [entity-schema.md](entity-schema.md) — base fields that branding metadata extends.
- [prompt-generation.md](prompt-generation.md) — how branding metadata is assembled into AI prompts.
- [relationship-model.md](relationship-model.md) — relationship context that informs scene composition.
- [Design System Specification](../../.github/specs/design-system.spec.md) — visual identity guidelines.
