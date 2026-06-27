# Open Source Readiness Review

**Date:** 2026-06-27
**Scope:** Campaign-specific components, reusable components, extraction opportunities, OSS packaging
**Target:** Phase 7 — Productization

---

## Summary

The 167 Guild Wiki is explicitly designed as a dual-purpose project: a private D&D campaign wiki for the 167 Guild, and a reusable template for future self-hosted knowledge platforms. The repository `README.md` and `ROADMAP.md` both document this intent.

This review assesses which components are campaign-specific (requiring extraction or generalization) and which are already reusable or nearly ready for OSS packaging.

---

## What Is Reusable Today

The following components are already generic or near-generic and could be extracted with minimal effort:

### Infrastructure Layer (High Reusability)

| Component | File(s) | Status | Notes |
|---|---|---|---|
| Docker Compose stack | `docker-compose.yml` | ✅ Reusable | Domain and credentials are externalized. Remove `167guild-wiki` default project name. |
| Caddy configuration | `config/caddy/Caddyfile` | ✅ Reusable | Fully parameterized via env vars. |
| Production overlay | `deploy/production/docker-compose.production.yml` | ✅ Reusable | Minimal; no campaign-specific content. |
| Env templates | `.env.example`, `deploy/examples/.env.production.example` | ⚠️ Nearly reusable | Replace `167guild.io` domain defaults with `your-domain.com` placeholders. |
| Validation script | `deploy/scripts/validate-env.sh` | ✅ Reusable | Fully generic. |
| Health check script | `deploy/scripts/health-check.sh` | ✅ Reusable | Fully generic. |
| Taskfile | `Taskfile.yml` | ⚠️ Nearly reusable | Remove `167guild-wiki` defaults once dev tasks are implemented. |
| Dev Container | `.devcontainer/devcontainer.json` | ✅ Reusable | Fully generic. |
| Release workflow | `.github/workflows/release.yml` | ✅ Reusable | Fully generic once repository-specific config is parameterized. |

### Design System (High Reusability)

The design system is the most complete reusable artifact in the repository.

| Component | File(s) | Campaign-Specific Elements |
|---|---|---|
| Design tokens | `theme/tokens/*.json` | Colors use "Guild Gold" and "Blood Red" names — rename tokens to generic equivalents |
| CSS variables | `theme/css/variables.css` | None — variable names are semantic |
| Base CSS | `theme/css/base.css` | None |
| Typography CSS | `theme/css/typography.css` | Font references (Cinzel, Crimson Text) are fantasy-appropriate but not 167-Guild-specific |
| Components CSS | `theme/css/components.css` | None |

**Extraction opportunity:** Package the Wiki.js dark fantasy theme as a standalone installable CSS module. Add a `README.md` explaining how to apply it via Wiki.js Admin → Theming → Custom CSS. This would be a standalone OSS project.

### Authorization Model (High Reusability)

| Component | Campaign-Specific Elements |
|---|---|
| `docs/authorization.md` | Role names (Dungeon Master, Player, Viewer) and email addresses |
| `scripts/bootstrap/seed-groups.sql` | Role names, email addresses, namespace paths (`/dm/`, `/characters/`) |

**Extraction opportunity:** Generalize role names to `Editor`, `Contributor`, `Reader` with configurable namespace rules. The seed script pattern (idempotent INSERT ... WHERE NOT EXISTS) is an excellent template.

### Content Templates (High Reusability)

| Template | Campaign-Specific Elements |
|---|---|
| `wiki/templates/character.md` | D&D-specific fields (class, race, background, stats) |
| `wiki/templates/npc.md` | Generic enough |
| `wiki/templates/location.md` | Generic |
| `wiki/templates/organization.md` | Generic |
| `wiki/templates/faction.md` | Generic |
| `wiki/templates/session.md` | D&D-specific (session number, in-game date) |
| `wiki/templates/item.md` | D&D-specific (magical properties, attunement) |
| `wiki/templates/timeline-event.md` | Generic |

**Extraction opportunity:** Create a "generic knowledge world" template set with placeholder field names, and a separate "D&D campaign" extension set.

---

## What Is Campaign-Specific

The following components contain 167 Guild campaign-specific content that must be removed or generalized before OSS extraction:

### Branding Assets

| Asset | Campaign-Specific | Notes |
|---|---|---|
| `assets/logos/logo.svg` | Yes — 167 Guild logo | Replace with placeholder logo |
| `assets/logos/logo-mark.svg` | Yes — Guild mark | Replace with placeholder |
| `assets/logos/wordmark.svg` | Yes — "167 Guild" wordmark | Replace with placeholder |
| `assets/branding/favicon.svg` | Yes | Replace with placeholder |
| `assets/branding/social-preview.svg` | Yes | Replace with placeholder |
| `assets/branding/seal-placeholder.svg` | Partially | The "placeholder" suffix suggests it is not final |
| `assets/branding/seal-faction-placeholder.svg` | Partially | Same as above |
| `assets/banners/readme-banner.svg` | Yes | Replace with generic "Knowledge World" banner |
| `assets/banners/hero-banner.svg` | Yes | Replace with generic banner |
| `assets/backgrounds/hero-bg.svg` | Potentially | Generic dark texture; review for campaign-specific iconography |
| `assets/backgrounds/loading-artwork.svg` | Potentially | Review for campaign-specific elements |

### Documentation Content

| File | Campaign-Specific | Notes |
|---|---|---|
| `wiki/home.md` | Yes | References 167 Guild lore |
| `docs/landing-page.md` | Yes | References 167 Guild world |
| `docs/context/branding-metadata.md` | Yes | 167 Guild atmospheric metadata |
| `docs/context/entity-schema.md` | Partially | Generic schema with 167-Guild-specific examples |
| `docs/context/relationship-model.md` | Partially | Generic model with campaign examples |
| `docs/context/prompt-generation.md` | Yes | References 167 Guild world context |

### Configuration Defaults

| File | Campaign-Specific Elements |
|---|---|
| `.env.example` | `167guild-wiki` project name |
| `.env.production.example` | `167guild.io` domain, `167guild-wiki` project name |
| `docker-compose.yml` | `167guild-wiki` default project name |
| `docs/authorization.md` | Player names (Alan, Kevin, Christian, Tom, Mitchell), email addresses |
| `scripts/bootstrap/seed-groups.sql` | Player names, email addresses in comments |

---

## Extraction Opportunities

### Opportunity 1: `wiki-world` — A Reusable Self-Hosted Knowledge World Template

**What it is:** A turnkey Docker Compose stack with Wiki.js, PostgreSQL, and Caddy, plus environment templates, deployment scripts, Taskfile automation, and a dark fantasy Wiki.js theme.

**What to remove:** 167 Guild branding, campaign-specific content, player names.

**What to generalize:** Role names (DM → Editor), namespace paths (`/dm/` → `/private/`), domain defaults.

**Packaging target:** GitHub Template Repository with a one-command quickstart.

**Effort estimate:** Medium (4–8 issues).

---

### Opportunity 2: `wiki.js-dark-fantasy-theme` — Standalone Wiki.js CSS Theme

**What it is:** The design tokens, CSS variables, and component styles from `theme/`.

**What to remove:** Any 167-Guild-specific color names or asset references.

**What to generalize:** Rename `Guild Gold` to `accent-gold`, document CSS injection via Wiki.js Admin UI.

**Packaging target:** NPM package or GitHub Releases with CSS file download. README with installation instructions and design token reference.

**Effort estimate:** Low (2–3 issues).

---

### Opportunity 3: `wiki-rbac-seed` — RBAC Bootstrap Script Pattern

**What it is:** The idempotent SQL seed pattern from `scripts/bootstrap/seed-groups.sql`.

**What to remove:** 167-Guild-specific role names and email addresses.

**What to generalize:** Parameterized role names, configurable namespace rules.

**Packaging target:** Standalone SQL template with a README explaining the pattern and how to adapt it.

**Effort estimate:** Low (1–2 issues).

---

### Opportunity 4: `world-prompt-pipeline` — AI Context and Prompt Generation Pipeline

**What it is:** The entity schema (`docs/context/entity-schema.md`), relationship model, branding metadata, and prompt generation architecture.

**Status:** Currently documentation and architecture only — no implementation.

**What to remove:** 167-Guild-specific entity examples and branding values.

**Packaging target:** A Python or Node.js CLI tool that accepts world entity YAML files and generates prompt packs. Eventually published to PyPI or npm.

**Effort estimate:** High (Phase 4 implementation first, then extraction).

---

## OSS Readiness Checklist

Before the repository or any extracted component is published as OSS:

- [ ] Remove all real email addresses from all files (search: `@gmail.com`, `szmyty`)
- [ ] Replace campaign-specific branding assets with placeholders or remove
- [ ] Generalize `167guild-wiki` project name in all configuration defaults
- [ ] Generalize `167guild.io` domain in all configuration defaults
- [ ] Generalize role names and namespace paths in authorization documents
- [ ] Remove or replace player character names in all template content
- [ ] Add installation guide for the template repository
- [ ] Add a demo world with fictional placeholder content
- [ ] Add OSS-specific contributing guide distinct from the campaign wiki contribution guide
- [ ] Review license compatibility of all dependencies and design assets
- [ ] Confirm Wiki.js is MIT-compatible for template bundling
- [ ] Add `ATTRIBUTION.md` for third-party assets (fonts, icons)

---

## License Compatibility Assessment

| Component | License | Compatible with MIT |
|---|---|---|
| Wiki.js | AGPL-3.0 | ⚠️ AGPL requires source disclosure for network use. The Docker container is consumed as a service, not modified. Bundling configuration/templates alongside it in a repository is likely acceptable, but verify with a license specialist before commercial OSS distribution. |
| PostgreSQL | PostgreSQL License (MIT-like) | ✅ Compatible |
| Caddy | Apache 2.0 | ✅ Compatible |
| Cinzel font | SIL Open Font License | ✅ Compatible |
| Crimson Text font | SIL Open Font License | ✅ Compatible |
| JetBrains Mono font | SIL Open Font License | ✅ Compatible |
| Lato font | SIL Open Font License | ✅ Compatible |
| Phosphor Icons | MIT | ✅ Compatible |
| Repository code | MIT | ✅ |

**Note on Wiki.js AGPL:** The AGPL applies to modifications of the Wiki.js source code distributed over a network. Using Wiki.js as a Docker container without modifying its source is standard practice and does not trigger the AGPL's network distribution clause. However, the OSS template should clearly document that Wiki.js itself is AGPL-licensed and link to its source repository.
