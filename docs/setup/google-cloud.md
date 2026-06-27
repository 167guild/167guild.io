# Google Cloud Setup

Use Google Cloud Console to create OAuth credentials for Wiki.js.

## Steps

1. Create/select a Google Cloud project.
2. Configure OAuth consent screen.
3. Create OAuth Client ID (**Web application**).
4. Register callback URL(s):
   - Local: `http://localhost:3000/login/callback`
   - Production: `https://167guild.io/login/callback`
5. Store generated client ID and client secret in environment files or secrets.

Do not commit real OAuth credentials.
