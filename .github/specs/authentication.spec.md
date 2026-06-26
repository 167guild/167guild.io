# 🔐 Authentication Specification

## Purpose

This document defines how users authenticate with the 167 Guild Wiki.

Authentication answers the question:

"Who is this user?"

Authorization is intentionally documented separately.

---

# Design Goals

- Simple login experience.
- No password management.
- Secure by default.
- Minimal administrative overhead.
- Support future identity providers.

---

# Authentication Provider

Initial provider:

- Google OAuth

Future providers may include:

- GitHub
- Discord
- Microsoft
- Keycloak
- Generic OpenID Connect

Google OAuth is the only provider required for v1.

---

# Login Flow

1. User visits the wiki.
2. User selects "Sign in with Google".
3. Google authenticates the user.
4. Wiki.js creates or updates the local user.
5. User is assigned to one or more authorization groups.
6. User is redirected back to the requested page.

---

# User Identity

Each authenticated user should have:

- Display name
- Email address
- Google account identifier
- Profile picture (optional)

The email address is the primary identity.

---

# User Provisioning

Users may be:

- Created automatically on first login.
- Invited by an administrator.
- Restricted to approved email addresses.

Initial deployment should favor invite-only access.

---

# Session Management

Authenticated sessions should:

- Expire after inactivity.
- Support logout.
- Use secure cookies.
- Require HTTPS.

---

# Security Requirements

Authentication must:

- Never expose OAuth secrets.
- Never store user passwords.
- Use HTTPS exclusively.
- Validate OAuth callbacks.
- Reject invalid authentication attempts.

---

# Environment Variables

Authentication configuration should originate from environment variables.

Examples:

- Google Client ID
- Google Client Secret
- OAuth Callback URL

Production secrets must never be committed.

---

# Future Enhancements

Potential future additions:

- Multi-factor authentication
- Multiple OAuth providers
- Single Sign-On
- Identity federation
- Organization-based access

These enhancements should remain compatible with the existing authentication model.

---

# Success Criteria

A new guild member should be able to:

1. Receive an invitation.
2. Sign in using Google.
3. Automatically receive the correct permissions.
4. Begin using the wiki immediately.

Authentication should be invisible once configured.
