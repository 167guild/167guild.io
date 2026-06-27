# 🎨 167 Guild Wiki — Theme

This directory contains the custom visual theme for the 167 Guild Wiki.

The theme transforms a standard [Wiki.js](https://js.wiki) installation into an immersive dark fantasy knowledge portal that reflects the atmosphere, tone, and lore of the 167 Guild DnD world.

---

## Directory Structure

```
theme/
├── README.md               ← You are here
├── tokens/
│   ├── colors.json         ← Color design tokens
│   ├── typography.json     ← Typography tokens (fonts, sizes, weights)
│   ├── spacing.json        ← Spacing scale tokens
│   ├── shadows.json        ← Shadow tokens
│   ├── borders.json        ← Border width, color, and style tokens
│   ├── radius.json         ← Border radius tokens
│   ├── animation.json      ← Animation duration and easing tokens
│   └── icons.json          ← Icon size and source tokens
├── css/
│   ├── variables.css       ← All CSS custom properties (generated from tokens)
│   ├── base.css            ← Reset, root styles, links, scrollbars
│   ├── typography.css      ← Headings, body, code, tables, blockquotes
│   └── components.css      ← Buttons, cards, alerts, sidebar, search, etc.
├── assets/
│   └── (reserved for fonts, SVG icons, textures)
└── components/
    └── README.md           ← Component inventory and visual treatment docs
```

---

## Design Philosophy

### Dark by Default

The primary visual register is dark — deep void backgrounds with parchment, gold, and stone white as foreground tones. This creates depth and atmosphere reminiscent of reading by candlelight.

### Immersive Fantasy

The theme evokes the physical world of the 167 Guild — aged manuscripts, carved stone, torchlit halls. Every design decision reinforces the sense of entering a living world.

### Readability First

Atmosphere must never compromise legibility. Long-form content — session logs, lore entries, character histories — must remain comfortable to read for extended periods.

### Modular and Token-Driven

All values derive from design tokens. No hardcoded color, spacing, or typography values exist in component CSS. Changing a token propagates consistently through the entire theme.

---

## Color System

| Role | Name | Value |
|------|------|-------|
| Page background | Void | `#0f111a` |
| Surface | Deep Slate | `#1a1f2e` |
| Surface raised | Stone | `#1e2335` |
| Border | Iron | `#2d3347` |
| Accent | Guild Gold | `#c9a84c` |
| Body text | Stone White | `#d4cbb8` |
| High-contrast text | Parchment | `#e8dfc8` |
| Links | Ice Blue | `#6b9bc8` |
| Errors / warnings | Blood Red | `#8b1a1a` |

See `tokens/colors.json` for the full palette and `css/variables.css` for all CSS custom properties.

---

## Typography

| Role | Font | Usage |
|------|------|-------|
| Headings | [Cinzel](https://fonts.google.com/specimen/Cinzel) | h1–h6 |
| Body | [Crimson Text](https://fonts.google.com/specimen/Crimson+Text) | Paragraphs, long-form reading |
| UI | [Lato](https://fonts.google.com/specimen/Lato) | Navigation, labels, buttons |
| Code | [JetBrains Mono](https://fonts.google.com/specimen/JetBrains+Mono) | Code blocks, inline code |

Fonts are loaded from Google Fonts via `css/variables.css`. All font families are defined as CSS variables and can be overridden.

---

## Applying the Theme to Wiki.js

### Method: Custom CSS

Wiki.js supports injecting custom CSS through the administration panel.

1. Navigate to **Administration → Theming**.
2. Open the **Custom CSS** field.
3. Paste the contents of `css/variables.css` first, then `css/base.css`, `css/typography.css`, and `css/components.css`.

The order matters:

```
variables.css   ← must load first (defines all variables)
base.css        ← depends on variables.css
typography.css  ← depends on variables.css
components.css  ← depends on variables.css
```

### Method: Combined Inject (recommended for production)

Concatenate all four files into a single `theme.css` and inject it as one block:

```sh
cat css/variables.css css/base.css css/typography.css css/components.css > theme.css
```

Then paste the contents into the Wiki.js Custom CSS field.

---

## Design Tokens

Design tokens are stored as JSON files in `tokens/`. Each file corresponds to a design dimension:

| File | Contents |
|------|----------|
| `colors.json` | Full color palette, semantic colors, code syntax |
| `typography.json` | Font families, sizes, weights, line heights, tracking |
| `spacing.json` | Spacing scale (0–96px, base 4px) |
| `shadows.json` | Box shadows, glows, insets |
| `borders.json` | Widths, colors, styles |
| `radius.json` | Border radius scale |
| `animation.json` | Duration and easing values |
| `icons.json` | Icon sizes and source definitions |

Tokens follow the [Design Tokens Community Group](https://design-tokens.github.io/community-group/format-spec/) naming conventions.

---

## Component Inventory

See `components/README.md` for documentation of every visual component, its design treatment, and implementation status.

Implemented components:

- ✅ Buttons (primary, secondary, ghost, danger)
- ✅ Cards
- ✅ Alerts / Callouts (info, success, warning, danger)
- ✅ Navigation
- ✅ Sidebar
- ✅ Breadcrumbs
- ✅ Search input and results
- ✅ Badges and Tags
- ✅ Pagination
- ✅ Tooltips
- ✅ Page Header
- ✅ Tables
- ✅ Code Blocks
- ✅ Blockquotes
- ✅ Links

---

## Future Customization

### Adding Colors

1. Add the color to `tokens/colors.json`.
2. Add the corresponding CSS variable to `css/variables.css` under the color section.
3. Reference it as `var(--color-<name>)` in component CSS.

### Light Mode

A parchment light mode can be added by overriding base variables within a `[data-theme="light"]` selector in `css/variables.css`:

```css
[data-theme="light"] {
  --color-background: #f5f0e8;
  --color-surface: #ede6d5;
  --color-text: #2a2520;
}
```

### New Components

1. Document the component's visual treatment in `components/README.md`.
2. Add the CSS to `css/components.css`.
3. Use only existing token variables — do not hardcode values.

---

## See Also

- [Design System Specification](../.github/specs/design-system.spec.md)
- [Branding Metadata](../docs/context/branding-metadata.md)
- [Component Inventory](components/README.md)
- [ROADMAP.md](../ROADMAP.md) — Phase 3: Design & Branding
