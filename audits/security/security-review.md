# Security Review

**Date:** 2026-06-27
**Scope:** Secrets management, authentication, authorization, exposed services, network security, backup security
**Target:** v0.1.0 production release

---

## Summary

The repository's overall security posture is good for an initial release. Secrets are externalized. Network architecture isolates database and wiki services behind Caddy. Security headers are applied globally. Authentication is delegated to Google OAuth. However, several gaps require attention before production.

---

## Secrets Management

### ✅ Strengths

- `.env.example` and `.env.production.example` contain only placeholder values. Real credentials are never committed.
- `validate-env.sh` actively rejects known placeholder strings (`REPLACE_WITH_STRONG_PASSWORD`, `replace-with-google-client-id`, etc.) before deployment.
- The `backups/.gitignore` excludes backup archives from version control.
- `.gitignore` excludes `.env` from version control.

### ⚠️ Gaps

**SEG-1: `.env.production` is not explicitly excluded in `.gitignore`**

The `.gitignore` file contains `.env` which covers `.env.production` by pattern matching. However, this is implicit. If the `.env` entry is ever modified or a developer adds a negation rule for a different `.env.*` variant, `.env.production` could become tracked.

**Resolution:** Add an explicit entry:
```
.env.production
.env.local
.env.staging
```

**SEG-2: No secret rotation procedure is documented**

There is no runbook for rotating the PostgreSQL password or Google OAuth credentials. In practice, rotating the OAuth client secret requires:
1. Generating a new secret in Google Cloud Console
2. Updating `.env.production`
3. Redeploying
4. Verifying authentication

**Resolution:** Add a secret rotation section to `deploy/README.md` or a dedicated operational runbook.

**SEG-3: Google OAuth credentials are passed as plain environment variables**

Docker environment variables are visible to anyone with `docker inspect` access on the host. On a shared VM or if the Docker socket is exposed, the OAuth credentials could be read.

**Resolution:** For v0.1.0 on a single dedicated VM, this is an acceptable risk. For future hardening, consider Docker secrets or a secrets manager (HashiCorp Vault, AWS Secrets Manager).

---

## Authentication

### ✅ Strengths

- Google OAuth is the sole authentication provider. No password storage or management.
- `GOOGLE_OAUTH_CALLBACK_URL` is validated by `validate-env.sh` to use HTTPS and to match `WIKI_BASE_URL/login/callback` exactly.
- HTTPS is enforced globally by Caddy with HSTS headers.

### ⚠️ Gaps

**AUTH-1: OAuth provider is not configured in Wiki.js**

See BLOCKER-2 in the production readiness review. Without an activated OAuth strategy, authentication will fail on first boot.

**AUTH-2: Invite-only access is not enforced by default**

The authentication spec recommends "invite-only access" for the initial deployment. The authorization model relies on administrators manually assigning users to groups after sign-in. There is no mechanism to prevent an unauthorized Google account from signing in and landing in the Guests group.

**Risk level:** Low. The Guests group has no permissions by default, so unauthorized users cannot access content. However, they can create an account, which may be undesirable.

**Resolution:** Wiki.js supports restricting Google OAuth to specific email domains. Document this configuration step in the deployment checklist. Example: restrict to `@gmail.com` accounts with a specific verified domain, or configure an allow-list of authorized email addresses.

**AUTH-3: Session security is not explicitly configured**

Wiki.js manages session cookies. There is no documentation confirming that:
- Cookies are set with `Secure` flag (guaranteed by HTTPS)
- Cookies are set with `HttpOnly` flag
- Session timeout is configured

**Resolution:** Verify Wiki.js session defaults after first production boot and document the observed behavior.

---

## Authorization

### ✅ Strengths

- RBAC model is well-defined with four explicit roles.
- The `/dm/` namespace has explicit deny rules for Player and Viewer groups.
- The SQL seed script is idempotent and includes inline documentation.
- The deny-by-default principle is documented for the Anonymous (Guest) group.

### ⚠️ Gaps

**AUTHZ-1: Player ownership is not technically enforced**

All Players can write to `/characters/` and `/journals/` namespaces. Wiki.js does not enforce per-user page ownership natively. A Player can edit another Player's character page.

This limitation is documented in `docs/authorization.md` and the seed script, which is appropriate. However, it should be explicitly noted in any user-facing onboarding documentation.

**AUTHZ-2: Administrators group initially contains no members**

Until an administrator manually assigns a user to the `Administrators` group after first boot, no one has administrative access. There is a brief window where the wiki may accept sign-ins but no one can administer it.

**Resolution:** On first boot, the Wiki.js setup wizard prompts for an admin account. This is the expected flow. Confirm the deployment checklist includes this step explicitly.

---

## Network Security

### ✅ Strengths

- Only Caddy publishes host ports (80 and 443).
- Wiki.js and PostgreSQL are on an `internal: true` Docker network.
- The `edge` network (Caddy only) is separate from the `internal` network.

### ⚠️ Gaps

**NET-1: No rate limiting on the authentication endpoint**

Caddy does not currently apply rate limiting to the `/login/` path. An attacker could trigger many OAuth callback attempts.

**Resolution:** This is low priority for an invite-only guild wiki with Google OAuth (which has its own rate limiting). For future hardening, consider adding a Caddy rate limit policy on `/login/callback`.

**NET-2: No IP allowlisting for the wiki**

Access to the wiki is globally open (anyone can visit `https://167guild.io`). If invite-only access is desired at the network level, Caddy could restrict access to specific IP ranges or VPN exit nodes.

**Resolution:** For a D&D guild wiki, this is likely acceptable. Document the decision explicitly in deployment documentation.

---

## Security Headers

The Caddyfile applies the following security headers globally:

| Header | Value |
|---|---|
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` |
| `X-Content-Type-Options` | `nosniff` |
| `X-Frame-Options` | `SAMEORIGIN` |
| `Referrer-Policy` | `strict-origin-when-cross-origin` |
| `Permissions-Policy` | `geolocation=(), microphone=(), camera=()` |
| `Server` | Removed |

### Assessment

These headers are a good baseline. Consider adding:

| Header | Recommendation |
|---|---|
| `Content-Security-Policy` | A CSP policy would prevent XSS. Wiki.js renders rich content, so CSP is complex. Defer to post-v0.1.0. |
| `X-Permitted-Cross-Domain-Policies` | `none` |

---

## Backup Security

### ⚠️ Gaps

**BCK-1: Backup scripts are stubs**

No data is currently being backed up. This is the most critical security/reliability risk in the repository.

**BCK-2: No backup encryption is documented for v0.1.0**

The spec defers encryption to a future issue. For v0.1.0, backup archives stored on the same server as the application provide limited protection against server compromise.

**Resolution:** At minimum, document that backup archives should be stored outside the production server (e.g., on a separate VM or cloud storage bucket). Encryption is deferred per spec.

**BCK-3: Backup archives include the config/ directory but not `.env.production`**

This is intentional (secrets must not be backed up to source-controlled locations). However, without an external secrets backup strategy, losing `.env.production` means OAuth credentials must be regenerated and all encrypted/hashed data may be unrecoverable.

**Resolution:** Document that `.env.production` should be stored in a separate secrets vault (1Password, Bitwarden, etc.) outside of the server and repository.

---

## Exposed Services Inventory

| Service | Port | Exposed Externally | Notes |
|---|---|---|---|
| Caddy | 80 | Yes | HTTP → HTTPS redirect only |
| Caddy | 443 | Yes | HTTPS; terminates TLS |
| Wiki.js | 3000 | No | Internal Docker network only |
| PostgreSQL | 5432 | No | Internal Docker network only |

This is the correct configuration. No changes recommended.

---

## Threat Model Summary

| Threat | Likelihood | Impact | Mitigation |
|---|---|---|---|
| Unauthorized wiki access | Low | Medium | Anonymous access denied by default; Google OAuth required |
| OAuth credential exposure | Low | High | Env vars in Docker; acceptable for single-VM deployment |
| Database credential exposure | Low | High | Internal Docker network; env vars only |
| Data loss from server failure | Medium | Critical | **No mitigation today** — backup scripts are stubs (C1) |
| Player accessing DM content | Low | High | Explicit page rule deny on `/dm/`; enforced at wiki level |
| Player editing another player's page | Medium | Low | Accepted limitation; documented in authorization docs |
| Container image compromise | Low | High | Official images from `ghcr.io/requarks/wiki`, `postgres`, `caddy` — pin versions for production |
