# DNS Setup

DNS configuration is required before first production TLS issuance.

## Minimum records

- `A` record: `@` -> production server IPv4
- Optional `AAAA` record: `@` -> production server IPv6
- Optional aliases (`www`, `wiki`) -> `167guild.io`

## Validation checklist

- Domain resolves to the deployment host
- Ports `80` and `443` are reachable
- Caddy is the only public-facing service

Detailed deployment assumptions are documented in `deploy/README.md`.
