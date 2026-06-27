# OAuth Configuration Notes

## Local development

- Keep local credentials in `.env` only.
- Use callback: `http://localhost:3000/login/callback`.

## Production

- Use HTTPS callback: `https://167guild.io/login/callback`.
- Ensure callback URL exactly matches Google Cloud and Wiki.js configuration.
- Use separate local and production OAuth credentials.

## Wiki.js admin steps

After first startup, configure Google provider in Wiki.js Admin -> Authentication and enable auto-create/auto-update for users as needed.
