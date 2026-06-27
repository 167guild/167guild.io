# 🖼️ Branding Assets

This directory contains the foundational visual assets for the 167 Guild Wiki.

These assets establish the visual identity of the world and are reused throughout the wiki.

All placeholder assets are SVG files styled to match the [Design System Specification](../.github/specs/design-system.spec.md).

---

## Directory Structure

```
assets/
├── branding/              # Core brand identity files
│   ├── favicon.svg        # Site favicon (32×32)
│   ├── social-preview.svg # Social preview / Open Graph image (1200×630)
│   ├── seal-placeholder.svg          # Organization seal placeholder
│   └── seal-faction-placeholder.svg  # Faction seal placeholder
├── banners/               # Header and hero artwork
│   ├── readme-banner.svg  # README and documentation banner (1200×400)
│   └── hero-banner.svg    # Homepage hero artwork (1440×480)
├── logos/                 # Logo variants
│   ├── logo.svg           # Full logo with emblem and wordmark (320×80)
│   ├── logo-mark.svg      # Emblem/mark only (64×64)
│   └── wordmark.svg       # Text-only wordmark (240×48)
└── backgrounds/           # Background textures and artwork
    ├── loading-artwork.svg # Loading screen artwork (800×600)
    └── hero-bg.svg         # Homepage hero background texture (1920×1080)
```

---

## Design Language

All assets follow the 167 Guild design system:

| Attribute | Value |
|-----------|-------|
| **Background** | `#0f111a` (Void) |
| **Surface** | `#1a1f2e` (Deep Slate) |
| **Accent** | `#c9a84c` (Guild Gold) |
| **Text** | `#d4cbb8` (Stone White) |
| **Text Muted** | `#8a8278` (Ash) |
| **Heading Font** | Cinzel / Georgia, serif |
| **Motifs** | Hexagons, seals, crests, chains |
| **Atmosphere** | Ancient, imposing, mysterious |

---

## Asset Status

These are **placeholder assets**. They establish visual structure and naming conventions for future AI-generated or hand-crafted artwork.

| Asset | Status | Notes |
|-------|--------|-------|
| `logos/logo.svg` | ✅ Placeholder | Full logo with emblem and wordmark |
| `logos/logo-mark.svg` | ✅ Placeholder | Icon-only mark |
| `logos/wordmark.svg` | ✅ Placeholder | Text-only wordmark |
| `branding/favicon.svg` | ✅ Placeholder | To be converted to `.ico` / `.png` for production |
| `branding/social-preview.svg` | ✅ Placeholder | To be exported as 1200×630 PNG |
| `branding/seal-placeholder.svg` | ✅ Placeholder | Base template for organization seals |
| `branding/seal-faction-placeholder.svg` | ✅ Placeholder | Base template for faction seals |
| `banners/readme-banner.svg` | ✅ Placeholder | Used in README.md |
| `banners/hero-banner.svg` | ✅ Placeholder | Homepage hero artwork |
| `backgrounds/loading-artwork.svg` | ✅ Placeholder | Loading screen |
| `backgrounds/hero-bg.svg` | ✅ Placeholder | Hero section background texture |

---

## Usage

### Wiki.js

Upload assets via the **File Manager** in the Wiki.js administration panel, or reference them by URL from the static file server.

### README

```markdown
![167 Guild Wiki](assets/banners/readme-banner.svg)
```

### HTML / Wiki Pages

```html
<img src="/assets/logos/logo.svg" alt="167 Guild Wiki" width="320" height="80">
<link rel="icon" href="/assets/branding/favicon.svg" type="image/svg+xml">
```

---

## See Also

- [Design System Specification](../.github/specs/design-system.spec.md) — visual identity guidelines
- [Branding Metadata](../docs/context/branding-metadata.md) — AI prompt guidance for artwork generation
- [Theme README](../theme/README.md) — CSS design tokens and component styles
