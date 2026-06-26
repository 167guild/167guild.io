# 📚 Content Model Specification

## Purpose

This document defines how information is organized within the 167 Guild Wiki.

The goal is to create a living world where information is interconnected, discoverable, and enjoyable to explore.

The content model should support storytelling rather than simply storing documents.

---

# Philosophy

The world should behave like a knowledge graph.

Every piece of information is an entity.

Entities relate to other entities.

As the campaign grows, the world becomes richer instead of more difficult to navigate.

---

# Primary Entity Types

The initial content model consists of:

- World
- Campaign
- Session
- Character
- NPC
- Organization
- Faction
- Location
- Region
- City
- Landmark
- Dungeon
- Item
- Weapon
- Armor
- Spell
- Ability
- Deity
- Creature
- Race
- Class
- Event
- Timeline Entry
- Map
- Artwork
- Journal

Additional entity types may be introduced over time.

---

# Relationships

Entities should reference one another whenever practical.

Examples:

Character

- belongs to Organization
- located in City
- possesses Item
- knows NPC

NPC

- lives in Location
- member of Faction
- appears during Session

Item

- owned by Character
- found in Dungeon

Location

- contains NPCs
- contains Items
- contains Landmarks

Session

- references Characters
- references Locations
- references Events

---

# Content Categories

## World

Permanent world information.

Examples:

- History
- Geography
- Cosmology
- Religions
- Languages

---

## Campaign

Campaign-specific information.

Examples:

- Active quests
- Session summaries
- Party members

---

## Characters

Player-controlled characters.

Each character should have:

- Portrait
- Biography
- Statistics
- Inventory
- Relationships
- Journal
- Session history

---

## NPCs

Non-player characters.

Each NPC may contain:

- Portrait
- Biography
- Occupation
- Faction
- Location
- Relationships
- Status

---

## Locations

Each location may contain:

- Description
- Maps
- History
- Population
- Organizations
- NPCs
- Points of interest

---

## Organizations

Examples:

- Guilds
- Governments
- Noble Houses
- Criminal Syndicates
- Religious Orders

---

## Timeline

The timeline should capture important events.

Examples:

- Historical events
- Campaign milestones
- Wars
- Discoveries
- Character deaths

---

# Media

Supported media should include:

- Maps
- Character artwork
- NPC artwork
- World artwork
- Session illustrations
- Documents

Media should be reusable across multiple pages.

---

# Cross Linking

Every page should encourage discovery.

Examples:

A Character page should link to:

- Home city
- Organization
- Inventory
- Known NPCs
- Session appearances

A Location should link to:

- Residents
- Nearby locations
- Historical events
- Organizations

---

# Hidden Content

Some entities may contain DM-only information.

Examples:

- Secret identities
- Hidden encounters
- Future events
- Hidden maps
- Secret organizations
- Internal notes

Players should never see hidden sections unless explicitly published.

---

# Future Expansion

Future entity types may include:

- Kingdoms
- Continents
- Pantheons
- Languages
- Crafting recipes
- Bestiary
- Shops
- Random encounter tables
- Homebrew rules

The content model should evolve naturally as the world grows.

---

# Guiding Principle

The wiki should feel less like a collection of pages and more like exploring a living world where every discovery leads naturally to another.
