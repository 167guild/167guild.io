# 🐉 167 Guild Wiki Vision Spec

## Purpose

167 Guild Wiki is a private, beautiful, self-hosted knowledge portal for the 167 Guild DnD world.

It should help the group preserve lore, session history, characters, maps, artwork, and world context while giving the Dungeon Master private space for hidden world notes.

## Goals

- Provide a beautiful DnD world wiki at `167guild.io`.
- Support Google authentication.
- Give the DM the highest content authority.
- Allow players to edit their own character and campaign-facing notes.
- Keep DM-only worldbuilding notes hidden from players.
- Use open-source, self-hostable infrastructure.
- Keep deployment simple, secure, and reproducible.
- Treat this repo as a reusable template for future private knowledge worlds.

## Non-Goals

- Do not build a custom wiki application from scratch for v1.
- Do not expose private campaign data publicly by default.
- Do not over-engineer Kubernetes before the Docker Compose deployment is validated.
- Do not store secrets in Git.

## Guiding Principles

- Ship a working wiki quickly.
- Harden security iteratively.
- Prefer simple, inspectable infrastructure.
- Use specs to guide GitHub issues and Copilot implementation.
- Preserve the magic and atmosphere of the world.
