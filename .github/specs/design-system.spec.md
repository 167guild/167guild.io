# 🎨 Design System Specification

## Purpose

This document defines the visual identity and design language for the 167 Guild Wiki.

The design system transforms a standard Wiki.js installation into an immersive dark fantasy knowledge portal that reflects the atmosphere, tone, and lore of the 167 Guild DnD world.

The design system provides reusable tokens, CSS variables, and component guidelines that ensure visual consistency across every page, section, and element of the wiki.

---

## Design Philosophy

### Immersive Fantasy

The wiki should feel like opening an ancient tome — visually rich, mysterious, and atmospheric.

Every typographic choice, color, and spacing decision should reinforce the sense of entering a living world.

### Readability First

Atmosphere must never compromise legibility. Long-form content — session logs, lore, character histories — must remain comfortable to read for extended periods.

### Dark by Default

The primary visual register is dark. Deep background tones create depth and contrast. Gold, parchment, and worn stone serve as highlights rather than base tones.

### Modular and Maintainable

The design system uses tokens and variables rather than hardcoded values. Changing a color or spacing value in one place propagates consistently through the entire wiki.

---

## Atmosphere

The visual world draws on these core qualities:

- **Atmosphere:** ancient, imposing, mysterious, grand
- **Emotional tone:** melancholic, resolute, curious, tense
- **Lighting:** candlelight, torchlight, moonlight, deep shadow
- **Materials:** weathered stone, polished obsidian, aged wood, rusted iron, cracked leather, parchment
- **Motifs:** ravens, broken chains, twin moons, serpents, crests, seals
- **Anti-patterns:** cartoon, anime, bright cheerful colors, modern technology, sterile white

---

## Color System

### Primary Palette

| Role | Name | Value | Usage |
|------|------|-------|-------|
| Background | Void | `#0f111a` | Page background |
| Surface | Deep Slate | `#1a1f2e` | Cards, panels, sidebar |
| Surface Raised | Stone | `#1e2335` | Raised panels, modals |
| Surface Border | Iron | `#2d3347` | Dividers, borders |
| Primary | Midnight Blue | `#1a2a4a` | Primary interactive elements |
| Accent | Guild Gold | `#c9a84c` | Highlights, links, headings |
| Accent Muted | Aged Gold | `#8a6f2e` | Secondary accents |
| Crimson | Blood Red | `#8b1a1a` | Warnings, important callouts |
| Parchment | Pale Gold | `#e8dfc8` | High-contrast body text |
| Text | Stone White | `#d4cbb8` | Body text |
| Text Muted | Ash | `#8a8278` | Secondary text, captions |
| Text Faint | Deep Ash | `#5a5650` | Placeholder text, disabled |

### Semantic Palette

| Role | Name | Value | Usage |
|------|------|-------|-------|
| Success | Forest | `#2d5a27` | Positive states |
| Warning | Amber | `#b8860b` | Cautionary states |
| Error | Crimson | `#8b1a1a` | Error states |
| Info | Steel Blue | `#4a6fa5` | Informational states |
| Link | Ice Blue | `#6b9bc8` | Hyperlinks |
| Link Visited | Lavender | `#9b88c8` | Visited links |
| Link Hover | Pale Ice | `#9fc5e8` | Link hover state |

### Code Syntax Palette

| Role | Value | Usage |
|------|-------|-------|
| Code Background | `#131620` | Code block background |
| Code Text | `#cdd6f4` | Default code text |
| Code Keyword | `#cba6f7` | Keywords |
| Code String | `#a6e3a1` | String literals |
| Code Comment | `#6c7086` | Comments |
| Code Number | `#fab387` | Numbers |
| Code Operator | `#89dceb` | Operators |

---

## Typography

### Font Stack

| Role | Font | Fallback | Usage |
|------|------|---------|-------|
| Heading | Cinzel | Georgia, serif | All headings (h1–h6) |
| Body | Crimson Text | Georgia, serif | Body text, paragraphs |
| UI | Lato | system-ui, sans-serif | Navigation, labels, buttons |
| Code | JetBrains Mono | Courier New, monospace | Code blocks, inline code |

### Scale

| Token | Size | Usage |
|-------|------|-------|
| `--text-xs` | 0.75rem | Captions, labels |
| `--text-sm` | 0.875rem | Secondary body, metadata |
| `--text-base` | 1rem | Primary body text |
| `--text-lg` | 1.125rem | Lead paragraphs |
| `--text-xl` | 1.25rem | Section labels |
| `--text-2xl` | 1.5rem | h5, h6 |
| `--text-3xl` | 1.875rem | h4 |
| `--text-4xl` | 2.25rem | h3 |
| `--text-5xl` | 3rem | h2 |
| `--text-6xl` | 3.75rem | h1, hero |

### Line Heights

| Token | Value | Usage |
|-------|-------|-------|
| `--leading-tight` | 1.25 | Headings |
| `--leading-snug` | 1.375 | Subheadings |
| `--leading-normal` | 1.5 | Body text |
| `--leading-relaxed` | 1.625 | Long-form reading |
| `--leading-loose` | 2 | Code, preformatted |

### Font Weights

| Token | Value | Usage |
|-------|-------|-------|
| `--font-light` | 300 | Captions, muted |
| `--font-normal` | 400 | Body text |
| `--font-medium` | 500 | UI labels |
| `--font-semibold` | 600 | Subheadings |
| `--font-bold` | 700 | Headings, emphasis |

---

## Spacing

The spacing scale uses a base of `4px` (`0.25rem`).

| Token | Value | Pixels |
|-------|-------|--------|
| `--space-0` | 0 | 0px |
| `--space-1` | 0.25rem | 4px |
| `--space-2` | 0.5rem | 8px |
| `--space-3` | 0.75rem | 12px |
| `--space-4` | 1rem | 16px |
| `--space-5` | 1.25rem | 20px |
| `--space-6` | 1.5rem | 24px |
| `--space-8` | 2rem | 32px |
| `--space-10` | 2.5rem | 40px |
| `--space-12` | 3rem | 48px |
| `--space-16` | 4rem | 64px |
| `--space-20` | 5rem | 80px |
| `--space-24` | 6rem | 96px |

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `--radius-none` | 0 | Sharp corners (stone, iron) |
| `--radius-sm` | 0.125rem | Subtle rounding |
| `--radius-base` | 0.25rem | Default elements |
| `--radius-md` | 0.375rem | Cards, panels |
| `--radius-lg` | 0.5rem | Modals, dialogs |
| `--radius-xl` | 0.75rem | Large containers |
| `--radius-full` | 9999px | Pills, badges |

---

## Shadows

| Token | Value | Usage |
|-------|-------|-------|
| `--shadow-sm` | `0 1px 2px rgba(0, 0, 0, 0.6)` | Subtle depth |
| `--shadow-base` | `0 2px 4px rgba(0, 0, 0, 0.7)` | Default cards |
| `--shadow-md` | `0 4px 8px rgba(0, 0, 0, 0.75)` | Raised panels |
| `--shadow-lg` | `0 8px 16px rgba(0, 0, 0, 0.8)` | Modals, popovers |
| `--shadow-xl` | `0 16px 32px rgba(0, 0, 0, 0.85)` | Overlay layers |
| `--shadow-glow-gold` | `0 0 12px rgba(201, 168, 76, 0.3)` | Gold accent glow |
| `--shadow-glow-crimson` | `0 0 12px rgba(139, 26, 26, 0.4)` | Crimson accent glow |
| `--shadow-inset` | `inset 0 2px 4px rgba(0, 0, 0, 0.5)` | Inset wells |

---

## Borders

| Token | Value | Usage |
|-------|-------|-------|
| `--border-width-thin` | `1px` | Default borders |
| `--border-width-base` | `2px` | Emphasized borders |
| `--border-width-thick` | `4px` | Section dividers |
| `--border-color-default` | `var(--color-iron)` | Standard borders |
| `--border-color-accent` | `var(--color-accent)` | Accent borders |
| `--border-color-muted` | `rgba(45, 51, 71, 0.6)` | Subtle borders |
| `--border-style-solid` | `solid` | Standard |
| `--border-style-ornate` | `double` | Decorative |

---

## Animation

| Token | Value | Usage |
|-------|-------|-------|
| `--duration-instant` | `0ms` | No animation |
| `--duration-fast` | `100ms` | Micro-interactions |
| `--duration-base` | `200ms` | Default transitions |
| `--duration-slow` | `350ms` | Page-level transitions |
| `--duration-slower` | `500ms` | Dramatic reveals |
| `--easing-linear` | `linear` | Continuous motion |
| `--easing-ease` | `ease` | Default |
| `--easing-ease-in` | `ease-in` | Enter animations |
| `--easing-ease-out` | `ease-out` | Exit animations |
| `--easing-ease-in-out` | `ease-in-out` | Balanced transitions |

---

## Icons

The icon system uses SVG-based icons. Icon sources:

- **Phosphor Icons** — primary icon set (MIT licensed)
- **Custom SVG** — world-specific motifs (ravens, crests, moons)

### Icon Sizes

| Token | Value | Usage |
|-------|-------|-------|
| `--icon-xs` | 12px | Inline indicators |
| `--icon-sm` | 16px | Button icons, navigation |
| `--icon-base` | 20px | Default icons |
| `--icon-md` | 24px | Feature icons |
| `--icon-lg` | 32px | Hero icons |
| `--icon-xl` | 48px | Illustration icons |

---

## Component Guidelines

### Buttons

Primary buttons use `--color-accent` (Guild Gold) as the background with dark text.

Destructive buttons use `--color-crimson` with light text.

Ghost buttons use a transparent background with an accent border.

### Tables

Tables use `--color-surface` as the background with alternating `--color-surface-raised` rows.

Header cells use `--color-accent` text on `--color-surface-raised` background.

Borders use `--border-color-default`.

### Cards

Cards use `--color-surface` with `--shadow-md` and `--radius-md`.

A `1px` `--border-color-default` border reinforces depth.

Hover state transitions to `--shadow-lg` with a subtle gold border (`--border-color-accent`).

### Alerts

Alerts use semantic palette backgrounds at 15% opacity over `--color-surface`.

Left border uses the full semantic color at `--border-width-thick`.

### Navigation

Navigation uses `--color-surface` background with `--color-text` for standard items.

Active items use `--color-accent` text.

Hover items use `--color-surface-raised` background.

### Sidebar

The sidebar uses `--color-surface` background with a right border in `--border-color-default`.

Section headings use `--color-accent` with uppercase letter-spacing.

### Code Blocks

Code blocks use `--color-code-bg` background with `--font-code` typeface.

Language labels appear in the top-right corner in `--color-text-muted`.

### Links

Standard links use `--color-link` and transition to `--color-link-hover` on hover.

Visited links use `--color-link-visited`.

---

## Theme Architecture

The theme is organized as follows:

```
theme/
├── README.md                 # Usage and overview
├── tokens/
│   ├── colors.json           # Color design tokens
│   ├── typography.json       # Typography tokens
│   ├── spacing.json          # Spacing scale tokens
│   ├── shadows.json          # Shadow tokens
│   ├── borders.json          # Border tokens
│   ├── radius.json           # Border radius tokens
│   ├── animation.json        # Animation/transition tokens
│   └── icons.json            # Icon size tokens
├── css/
│   ├── variables.css         # All CSS custom properties (compiled from tokens)
│   ├── base.css              # Reset and base element styles
│   ├── typography.css        # Heading hierarchy, body, code
│   └── components.css        # Component-level styles
├── assets/
│   └── (reserved for fonts, SVG icons, textures)
└── components/
    └── README.md             # Component inventory documentation
```

---

## Future Customization

### Expanding the Color System

To add a new color, add it to `tokens/colors.json`, then reference it via `var(--color-<name>)` in CSS.

### New Components

Document new components in `components/README.md` with visual treatment notes before implementing CSS.

### Light Mode

A light parchment mode is possible by overriding `--color-background`, `--color-surface`, and `--color-text` within a `[data-theme="light"]` selector.

### Wiki.js Integration

Theme CSS is injected via the Wiki.js **Custom CSS** field in the Administration panel under **Theming**.

Future integration via Wiki.js theme extensions can load fonts, modular CSS files, and custom JavaScript.

---

## See Also

- [Vision Specification](vision.spec.md)
- [Branding Metadata](../../docs/context/branding-metadata.md)
- [Theme README](../../theme/README.md)
