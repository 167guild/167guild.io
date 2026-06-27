🗺️ Roadmap

«A living roadmap for building the 167 Guild Wiki. This document tracks the project's progress from repository bootstrap to a fully immersive, self-hosted Dungeons & Dragons knowledge platform.»

---

Phase 0 — Foundation

Repository

- [x] Create repository
- [x] Create specification library
- [x] Bootstrap repository structure
- [x] Configure community health files
- [x] Create `docs/architecture.md` (referenced in README but missing)
- [x] Expand `SECURITY.md` with vulnerability reporting policy and threat model
- [x] Add `SUPPORT.md` with community support channels

Developer Experience

- [x] Configure local development environment
- [x] Configure Taskfile
- [x] Configure Dev Container
- [x] Configure VS Code recommendations
- [x] Implement `task up` / `task down` (currently stubs)
- [x] Implement `task init` (currently a stub)
- [x] Implement `task lint` / `task format` (currently stubs)
- [x] Add `task` installation to Dev Container
- [x] Add auto-copy of `.env.example` → `.env` in Dev Container `postCreateCommand`

---

Phase 1 — Infrastructure

Docker

- [x] Bootstrap Docker Compose stack
- [x] Configure Caddy reverse proxy
- [x] Configure PostgreSQL
- [x] Configure Wiki.js
- [ ] Implement Wiki.js Google OAuth provider configuration (YAML or documented UI steps)
- [ ] Pin container image versions in production overlay for reproducible deployments
- [ ] Add resource limits and log driver limits to production Compose overlay

Authentication

- [x] Configure Google OAuth
- [x] Configure role model
- [x] Configure RBAC permissions

Operations

- [x] Configure backup strategy
- [x] Configure restore procedures
- [x] Configure deployment workflow
- [x] Configure production environment
- [x] Connect "167guild.io"
- [x] Production hardening
- [x] Release validation checklist
- [ ] Implement backup scripts (PostgreSQL dump, volume backup, config archive)
- [ ] Implement restore scripts and validate against a real backup archive
- [ ] Wire SSH deployment step in GitHub Actions deploy workflow

Release Management

- [x] Configure Semantic Versioning (SemVer)
- [x] Configure Conventional Commits enforcement
- [x] Configure automated release workflow
- [x] Configure automated changelog generation
- [x] Configure GitHub Releases automation
- [x] Document versioning strategy and release lifecycle

---

Phase 2 — World Foundation

Campaign Structure

- [x] Create landing page
- [x] Create world overview
- [x] Create campaign overview

Templates

- [x] Character template
- [x] NPC template
- [x] Location template
- [x] Organization template
- [x] Faction template
- [x] Session template
- [x] Timeline template
- [x] Item template
- [ ] Spell template
- [ ] Journal template

Navigation

- [ ] Sidebar organization
- [x] Home navigation
- [x] Interactive world navigation scaffold
- [ ] Search optimization
- [ ] Cross-linking strategy

---

Phase 3 — Design & Branding

Visual Identity

- [x] Global design system
- [x] Wiki.js custom theme
- [x] Typography
- [x] Color palette
- [x] Icons
- [x] Design tokens

Branding Assets

- [x] Wiki logo
- [x] Favicon
- [x] Social preview image
- [x] README banner
- [x] Organization seal placeholders
- [x] Loading artwork

Artwork

- [x] Homepage hero
- [ ] Section banners
- [ ] Character art
- [ ] NPC art
- [ ] Maps
- [ ] Organization crests
- [ ] Faction heraldry
- [x] Background textures

---

Phase 4 — AI & Knowledge Graph

Context Engine

- [x] World knowledge graph
- [x] Entity relationship model
- [ ] Context export pipeline
- [x] Prompt generation pipeline architecture
- [ ] Prompt generation pipeline implementation

AI Workflows

- [ ] Character artwork generation
- [ ] NPC artwork generation
- [ ] Banner generation
- [ ] Theme generation
- [ ] Prompt packs
- [ ] World-aware branding

---

Phase 5 — Campaign Experience

Content

- [ ] Populate world lore
- [ ] Populate player characters
- [ ] Populate NPCs
- [ ] Populate locations
- [ ] Populate organizations
- [ ] Populate factions
- [ ] Populate session history

Dungeon Master

- [ ] Hidden lore
- [ ] Encounter planning
- [ ] Secret maps
- [ ] Campaign notes

---

Phase 6 — Polish

Documentation

- [ ] Architecture diagrams
- [ ] User guide
- [ ] Administrator guide
- [ ] Dungeon Master guide
- [ ] Player onboarding guide

Operations

- [ ] Monitoring
- [ ] Logging
- [ ] Log rotation configuration
- [ ] Disaster recovery
- [ ] Security review
- [ ] Secret rotation runbook
- [ ] Scheduled backups (cron or GitHub Actions)
- [ ] Offsite backup storage
- [ ] Backup encryption
- [ ] Backup retention policy

---

Future Ideas

- [ ] Interactive world map
- [ ] Character relationship graph
- [ ] Timeline visualization
- [ ] AI-powered lore assistant
- [ ] World search with RAG
- [ ] Multi-campaign support
- [ ] Mobile-friendly experience
- [ ] Reusable "Knowledge World" template

---

Guiding Philosophy

The goal is not simply to build a wiki.

The goal is to build a beautiful, living world that grows alongside the campaign while remaining easy to maintain, enjoyable to explore, and reusable as a foundation for future knowledge-driven projects.

---

# Phase 7 — Open Source Extraction

## Productization

- [x] Audit repository for reusable components
- [ ] Remove campaign-specific assets
- [ ] Extract reusable configuration
- [ ] Generalize templates
- [ ] Replace 167 Guild branding with placeholders
- [ ] Package the Wiki.js theme
- [ ] Package the prompt generation pipeline
- [ ] Package the context graph
- [ ] Publish documentation
- [ ] Create installation guide
- [ ] Create demo world
- [ ] Publish OSS template repository
- [ ] Review Wiki.js AGPL license implications for OSS bundling
- [ ] Add `ATTRIBUTION.md` for third-party fonts and icons

## Community

- [ ] Create project website
- [ ] Publish documentation
- [ ] Create example campaigns
- [ ] Accept community themes
- [ ] Accept community templates
- [ ] Publish extension API

---

# Long-Term Vision

Transform the 167 Guild Wiki into a reusable open-source platform that enables anyone to create beautiful, self-hosted knowledge worlds for tabletop RPGs and collaborative storytelling.
