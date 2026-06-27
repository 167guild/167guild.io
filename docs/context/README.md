# 🧠 World Context Graph

## Overview

This directory establishes the canonical metadata model for the 167 Guild world.

It provides structured, machine-readable context that future AI workflows — artwork generation, prompt packs, world-aware branding, and search — will consume as a primary source of truth.

This documentation does **not** implement AI generation. It defines the foundation that makes generation possible.

---

## Purpose

The world context graph separates the *meaning* of world entities from their *presentation* in Wiki.js.

By defining entities, relationships, and branding metadata in a structured, portable format, the project gains:

- A reusable context layer independent of any specific wiki engine.
- A stable foundation for AI prompt generation pipelines.
- A shared vocabulary for contributors describing the world.
- A clear upgrade path toward vector search and RAG-based tooling.

---

## Contents

| Document | Purpose |
|----------|---------|
| [entity-schema.md](entity-schema.md) | Common metadata fields shared across all world entity types |
| [relationship-model.md](relationship-model.md) | Typed relationships that connect entities to one another |
| [branding-metadata.md](branding-metadata.md) | Visual and atmospheric metadata intended for artwork generation |
| [prompt-generation.md](prompt-generation.md) | Strategy for transforming structured metadata into AI prompts |

---

## Philosophy

Every entity in the world is a node.

Every link between entities is an edge.

The context graph captures both — giving AI tools a rich, interconnected view of the world rather than isolated facts.

---

## See Also

- [Content Model Specification](../../.github/specs/content-model.spec.md) — information architecture and entity type definitions.
- [Design System Specification](../../.github/specs/design-system.spec.md) — visual identity and branding guidelines.
- [Templates](../templates.md) — wiki content templates that implement the entity schema in practice.
