# Google Cloud Setup

Use Google Cloud Console to create OAuth credentials for Wiki.js.

## Steps

1. Create/select a Google Cloud project.
2. Configure OAuth consent screen.
3. Create OAuth Client ID (**Web application**).
4. Configure **Authorized JavaScript origins**:
   - Local: `http://localhost:3000`
   - Production: `https://167guild.io`
5. Configure **Authorized redirect URIs**:
   - Local: `http://localhost:3000/login/callback`
   - Production: `https://167guild.io/login/callback`
6. Copy the generated client ID and client secret.
7. Store values in environment files/secrets:
   - `GOOGLE_OAUTH_CLIENT_ID`
   - `GOOGLE_OAUTH_CLIENT_SECRET`
   - `GOOGLE_OAUTH_CALLBACK_URL`
8. In Wiki.js Admin, enable Google authentication using these same values.
9. Verify Google login in the running deployment.

The production deployment process requires exact URL matches across Google Cloud, `.env.production`, and Wiki.js Admin UI.

Do not commit real OAuth credentials.
