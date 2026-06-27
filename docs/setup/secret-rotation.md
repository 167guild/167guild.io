# Secret Rotation Runbook

Rotate secrets when credentials are exposed, shared in error, or as part of scheduled maintenance.

## Targets

- `POSTGRES_PASSWORD`
- `GOOGLE_OAUTH_CLIENT_SECRET`
- Any deployment environment secrets in GitHub

## Rotation flow

1. Generate replacement credentials.
2. Update `.env.production` and GitHub `PRODUCTION_ENV_FILE` secret.
3. Redeploy with `task deploy:production`.
4. Verify login and database connectivity.
5. Revoke old credentials.

Record the rotation date and operator in your internal operations log.
