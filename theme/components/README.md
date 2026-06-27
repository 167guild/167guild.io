# 🎨 Component Inventory

This document catalogs every reusable UI component in the 167 Guild Wiki theme and describes its intended visual treatment.

Implementation status is noted for each component. Placeholder entries document the intended design before CSS is written.

---

## Status Legend

| Status | Meaning |
|--------|---------|
| ✅ Implemented | CSS exists in `theme/css/components.css` |
| 📐 Specified | Design documented; CSS implementation pending |
| 🔮 Planned | Future component; design not yet defined |

---

## Interactive Elements

### Buttons ✅

**Variants:**

| Variant | Background | Text | Border | Use Case |
|---------|-----------|------|--------|----------|
| Primary | Guild Gold (`--color-accent`) | Void (`#0f111a`) | Gold | Primary actions |
| Secondary | Transparent | Guild Gold | Gold | Secondary actions |
| Ghost | Transparent | Stone White | Iron | Tertiary actions |
| Danger | Blood Red (`--color-crimson`) | Parchment | Crimson | Destructive actions |

**States:** default → hover (glow shadow) → focus (gold ring) → disabled (muted opacity)

**Typography:** `--font-ui`, uppercase, `--tracking-wide`, `--text-sm`

**Sizing:** Small (`btn-sm`), Default, Large (`btn-lg`)

---

### Links ✅

**Colors:**

| State | Color |
|-------|-------|
| Default | Ice Blue (`--color-link`) |
| Visited | Lavender (`--color-link-visited`) |
| Hover | Pale Ice (`--color-link-hover`) |
| Focus | Gold ring via `--focus-ring` |

**Style:** underline with `text-underline-offset: 2px`, translucent underline color that intensifies on hover.

---

### Search ✅

**Input:** Dark surface background, iron border, transitions to gold border on focus.

**Results dropdown:** Surface panel with item hover states. Result titles in `--color-accent`, excerpts in `--color-text-muted`.

---

## Layout Components

### Cards ✅

**Structure:**

- Background: `--color-surface`
- Border: 1px `--border-color-default`
- Radius: `--radius-md`
- Shadow: `--shadow-md` → `--shadow-lg` on hover
- Hover border: `--color-accent-muted`

**Subcomponents:**
- `.card-header` — accent color heading with bottom border
- `.card-body` — body text
- `.card-footer` — muted metadata row with top border

---

### Sidebar ✅

**Appearance:**

- Background: `--color-surface`
- Right border: `--border-color-default`
- Section headings: `--color-accent`, uppercase, `--tracking-wider`
- Active item: `--color-accent` text, subtle gold background
- Hover item: `--color-surface-raised`

**Subcomponents:**
- `.sidebar-logo` — gold heading, bottom border
- `.sidebar-section` — grouped nav area
- `.sidebar-footer` — muted attribution/version

---

### Navigation ✅

**Appearance:**

- Font: `--font-ui`
- Default item: `--color-text`
- Active item: `--color-accent`, gold background tint
- Hover: `--color-surface-raised` background
- Section headings: `--color-accent`, uppercase

---

### Breadcrumbs ✅

**Appearance:**

- Font: `--font-ui`, `--text-sm`
- Color: `--color-text-muted`
- Active page: `--color-text`, medium weight
- Separator: `--color-text-faint`
- Link hover: `--color-link`

---

## Content Components

### Tables ✅

**Appearance:**

- Background: `--color-surface`
- Header: `--color-surface-raised`, `--color-accent` text, uppercase heading
- Header border: 2px `--border-color-accent`
- Even rows: `--color-surface-raised`
- Row hover: gold tint (`rgba(201, 168, 76, 0.06)`)
- Cell padding: `--space-3` / `--space-4`

---

### Alerts / Callouts ✅

**Variants:**

| Variant | Background | Border | Text |
|---------|-----------|--------|------|
| Info | Steel blue tint | `--color-info` | `--color-info-text` |
| Success | Forest tint | `--color-success` | `--color-success-text` |
| Warning | Amber tint | `--color-warning` | `--color-warning-text` |
| Danger/Error | Crimson tint | `--color-error` | `--color-error-text` |

**Structure:** 4px left border, subtle background tint, accent-colored title in small caps.

---

### Code Blocks ✅

**Appearance:**

- Background: `--color-code-bg` (deeper than surface)
- Text: `--color-code-text`
- Font: `--font-code`
- Border: 1px `--border-color-default`
- Radius: `--radius-md`
- Shadow: `--shadow-md`
- Line height: `--leading-loose`

**Syntax highlighting roles:** keyword (`#cba6f7`), string (`#a6e3a1`), comment (`#6c7086`), number (`#fab387`), operator (`#89dceb`)

---

### Blockquotes ✅

**Appearance:**

- Left border: 4px `--border-color-accent`
- Background: gold tint (6% opacity)
- Text: italic `--color-parchment`
- Font size: `--text-lg`
- Attribution: `--font-ui`, `--text-sm`, `--color-text-muted`

---

## Metadata Components

### Badges and Tags ✅

**Base:** rounded pill, uppercase, `--text-xs`, muted surface background.

**Accent variant:** gold tint background, gold text and border.

**Semantic variants:** success, warning, danger — each with matching tint and text.

---

### Pagination ✅

**Appearance:**

- Items: bordered boxes, `--font-ui`, `--text-sm`
- Active: gold tint, gold border, gold text
- Hover: surface-raised background

---

### Page Header ✅

**Appearance:**

- Title: `--font-heading`, `--text-5xl`, `--color-accent`
- Description: `--font-body`, `--text-lg`, `--color-text-muted`
- Meta: `--font-ui`, `--text-sm`, `--color-text-muted`
- Bottom border: `--border-color-default`

---

## Planned Components

### Hero Banner 📐

**Intended treatment:**

- Full-width dark image with a gradient overlay from `--color-background`
- Page title in large `--font-heading` with gold color
- Subtitle in `--font-body`, parchment tone
- Optional decorative border or seal motif

Implementation deferred pending artwork assets.

---

### Page Footer 📐

**Intended treatment:**

- Background: `--color-surface`
- Top border: `--border-color-default`
- Wiki name and description: `--font-heading`, `--color-accent`
- Links: `--color-text-muted` → `--color-link` on hover
- Copyright / attribution: `--color-text-faint`

---

### Tooltip ✅

**Appearance:**

- Background: `--color-surface-raised`
- Border: 1px `--border-color-default`
- Shadow: `--shadow-md`
- Font: `--font-ui`, `--text-xs`
- Fade in on hover

---

### Tags / Namespace Pills 🔮

Future component for displaying wiki namespaces or page categories. Will use `.badge-accent` as the base style.

---

### Revision History Table 🔮

Future component for the Wiki.js page history view. Will use existing table styles with diff-coloring extensions.

---

### Media Gallery 🔮

Future component for embedded image galleries within wiki pages. Will use card-style borders with a dark background overlay.

---

## Typography Reference

For typographic component treatments (headings, body text, code, blockquotes, lists), see `theme/css/typography.css` and the [Design System Specification](../../.github/specs/design-system.spec.md).

---

## See Also

- [Theme README](../README.md)
- [Design System Specification](../../.github/specs/design-system.spec.md)
- [CSS Variables](../css/variables.css)
- [Component CSS](../css/components.css)
