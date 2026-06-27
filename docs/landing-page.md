# Landing Page Architecture

This document defines the initial landing page structure for the 167 Guild Wiki and how it should evolve as content and artwork are added.

---

## Purpose

The landing page acts as the world entry point. It should feel like opening an ancient codex while remaining readable, navigable, and easy to extend.

Current implementation is placeholder-first: layout, hierarchy, and navigation are established now, while final art and lore population are deferred.

---

## Component Hierarchy

```text
wiki/home.md
└── .landing-page
    ├── .landing-hero
    │   ├── .landing-hero-media (placeholder artwork layer)
    │   └── .landing-hero-content
    │       ├── .landing-kicker
    │       ├── .landing-title
    │       ├── .landing-subtitle
    │       ├── .landing-introduction
    │       └── .landing-navigation
    │           └── .landing-nav-grid
    │               └── .nav-item links to world entities
    ├── .landing-section (World Overview)
    │   └── .landing-grid
    │       └── .card × 3 (World, Campaign, Adventuring Party)
    └── .landing-section (Featured Content)
        └── .landing-grid
            └── .card × 5 (Sessions, Character, Location, Campaign, Discoveries)
```

---

## Layout and Visual Strategy

- Uses theme tokens from the design system for spacing, typography, color, borders, and shadows.
- Hero section establishes atmosphere with a layered placeholder background and high-contrast heading stack.
- Navigation uses existing `.navigation`, `.nav-list`, and `.nav-item` patterns to stay consistent with global components.
- Overview and featured areas use reusable `.card` components in responsive grids.
- Responsive behavior:
  - 3-column navigation on desktop
  - 2-column navigation on tablet
  - 1-column navigation on small screens

---

## Future Expansion Strategy

1. Replace `.landing-hero-media` placeholder gradients with final campaign artwork.
2. Convert featured cards into data-driven blocks backed by real world entities.
3. Add dynamic "recent sessions" and "latest discoveries" queries once content volume grows.
4. Introduce optional thematic flourishes (crests, seals, ornaments) without reducing readability.
5. Extend navigation with context-aware discovery links as cross-link density increases.

---

## Implementation Files

- Page content: `wiki/home.md`
- Landing page styling: `theme/css/components.css` (Landing Page section)
