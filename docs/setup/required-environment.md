# Required Environment Variables

## Local (`.env`)

Create `.env` from `.env.example` and set:

- `APP_ENV`
- `WIKI_BASE_URL`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `GOOGLE_OAUTH_CLIENT_ID`
- `GOOGLE_OAUTH_CLIENT_SECRET`
- `GOOGLE_OAUTH_CALLBACK_URL`

## Production (`.env.production`)

Create from `deploy/examples/.env.production.example` and set:

- `DOMAIN`
- `EMAIL`
- `WIKI_BASE_URL`
- `POSTGRES_DB`
- `POSTGRES_USER`
- `POSTGRES_PASSWORD`
- `GOOGLE_OAUTH_CLIENT_ID`
- `GOOGLE_OAUTH_CLIENT_SECRET`
- `GOOGLE_OAUTH_CALLBACK_URL`

Validate production configuration with:

```bash
bash deploy/scripts/validate-env.sh .env.production
```
