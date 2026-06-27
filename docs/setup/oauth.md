# OAuth Configuration Notes

This runbook defines the production Google OAuth setup for Wiki.js.

## Configuration Strategy (v0.1.0)

For production, authentication configuration is managed in the **Wiki.js Admin UI** and persisted in PostgreSQL.

Why this approach is used:

- Wiki.js stores provider enablement and provider options in application data.
- Group and permission bootstrap also happens in the admin experience and database.
- Keeping provider activation in the same UI path as role bootstrap eliminates split-brain configuration and matches first-boot behavior.

Environment variables remain the source of truth for secrets and callback URL values.

## Required Values

- `GOOGLE_OAUTH_CLIENT_ID`
- `GOOGLE_OAUTH_CLIENT_SECRET`
- `GOOGLE_OAUTH_CALLBACK_URL`

Production values come from `.env.production` and must never be committed.

## Local development

- Keep local credentials in `.env` only.
- Use callback: `http://localhost:3000/login/callback`.
- Use separate local credentials from production credentials.

## Production

- Use HTTPS callback: `https://167guild.io/login/callback`
- Ensure callback URL exactly matches:
  - Google Cloud OAuth **Authorized redirect URI**
  - `GOOGLE_OAUTH_CALLBACK_URL` in `.env.production`
  - Wiki.js Google strategy configuration in Admin UI

## Wiki.js Admin Steps (Production)

After first startup and admin login:

1. Open **Administration → Authentication**.
2. Add or edit the **Google** strategy.
3. Set:
   - **Client ID** = `GOOGLE_OAUTH_CLIENT_ID`
   - **Client Secret** = `GOOGLE_OAUTH_CLIENT_SECRET`
   - **Callback / Redirect URI** = `GOOGLE_OAUTH_CALLBACK_URL`
4. Enable:
   - Auto-create users on first sign-in
   - Auto-update user profile on login
5. Save and enable the Google provider.
6. Verify sign-in with an approved Google account.

## Troubleshooting

- `redirect_uri_mismatch`: Callback URI does not exactly match Google Cloud settings.
- OAuth button missing in Wiki.js: Google strategy was saved but not enabled.
- Login succeeds but access is denied: User exists but is not in the expected RBAC group.
