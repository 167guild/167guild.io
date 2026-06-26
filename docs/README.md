# Documentation

## Caddy Reverse Proxy

### Purpose

Caddy is the public entrypoint for the stack. It terminates HTTPS, redirects HTTP to HTTPS, applies baseline security headers, enables compression, and reverse-proxies requests to Wiki.js.

### Directory Layout

```text
config/
└── caddy/
    └── Caddyfile
```

`/config/caddy/Caddyfile` contains production-oriented reverse proxy behavior using environment-driven placeholders.

### Configuration Philosophy

- Keep configuration environment-driven (`DOMAIN`, `EMAIL`, `WIKI_UPSTREAM`).
- Prefer reusable Caddy snippets for easy extension.
- Keep security defaults in the proxy layer while keeping app and database concerns separate.
