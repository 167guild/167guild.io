# 🧩 Artwork Prompt Templates

## Base Entity Prompt Template

```text
Subject: {{entity.name}} ({{entity.type}})
Description: {{entity.description}}
Visual keywords: {{entity.branding.motifs}}, {{entity.branding.materials}}, {{entity.branding.colors}}
Atmosphere: {{entity.branding.atmosphere}}
Emotional tone: {{entity.branding.emotional_tone}}
Lighting: {{entity.branding.lighting}}
Composition: {{entity.branding.composition}}
Context links: {{relationships.summary}}
Global style: {{global_style_prompt}}
Negative prompt: {{negative_prompt}}
```

---

## Banner Prompt Template

```text
Generate a wide cinematic banner for {{scope}}.
Primary context: {{featured_entities}}
Location context: {{featured_locations}}
Narrative mood: {{session_or_campaign_tone}}
Atmosphere and motifs: {{world.atmosphere}}, {{world.motifs}}
Color and lighting: {{world.color_palette}}, {{world.lighting}}
Composition: panoramic, layered depth, readable negative space for title overlays.
Negative prompt: {{negative_prompt}}
```

---

## Character Prompt Template

```text
Generate a character portrait for {{entity.name}}.
Role and identity: {{entity.description}}
Appearance cues: {{entity.branding.materials}}, {{entity.branding.colors}}, {{entity.branding.motifs}}
Emotion and pose: {{entity.branding.emotional_tone}}, {{entity.branding.composition}}
World context: {{relationships.summary}}
Global style: {{global_style_prompt}}
Negative prompt: {{negative_prompt}}
```

---

## NPC Prompt Template

```text
Generate an NPC portrait for {{entity.name}}.
Occupation/faction context: {{relationships.summary}}
Appearance cues: {{entity.branding.materials}}, {{entity.branding.colors}}, {{entity.branding.motifs}}
Mood and lighting: {{entity.branding.emotional_tone}}, {{entity.branding.lighting}}
Composition: {{entity.branding.composition}}
Global style: {{global_style_prompt}}
Negative prompt: {{negative_prompt}}
```

---

## Map Prompt Template

```text
Generate a stylized fantasy map for {{entity.name}}.
Region description: {{entity.description}}
Terrain and architecture: {{entity.branding.textures}}, {{entity.branding.architecture}}
Climate and weather: {{entity.branding.weather}}
Atmosphere and color language: {{world.atmosphere}}, {{world.color_palette}}
Landmark context: {{relationships.summary}}
Composition: readable top-down cartographic layout with decorative border motifs.
Global style: {{global_style_prompt}}
Negative prompt: {{negative_prompt}}
```

