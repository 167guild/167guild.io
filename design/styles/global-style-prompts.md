# 🎨 Global Style and Branding Prompts

## Branding Metadata Mapping

Global style prompts are derived from world-level metadata:

- `atmosphere`
- `emotional_tone`
- `color_palette`
- `lighting`
- `motifs`
- `materials`

These fields define the shared visual language for all generated artwork.

---

## Global Style Prompt Template

```text
Style: dark fantasy worldbuilding illustration.
Atmosphere: {{world.atmosphere}}.
Emotional tone: {{world.emotional_tone}}.
Color language: {{world.color_palette}}.
Lighting language: {{world.lighting}}.
Recurring motifs: {{world.motifs}}.
Material language: {{world.materials}}.
Rendering quality: high detail, cinematic composition, cohesive art direction.
```

---

## Global Negative Prompt Template

```text
Avoid: {{merge(world.negative_prompts, entity.branding.negative_prompts)}}.
```

Minimum global exclusions:

- cartoon
- anime
- bright cheerful colors
- modern technology
- science fiction elements
- low quality
- blurry

