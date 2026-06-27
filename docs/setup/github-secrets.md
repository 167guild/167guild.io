# GitHub Secrets Mapping

The deployment workflow expects a repository or environment secret named:

- `PRODUCTION_ENV_FILE` — full contents of `.env.production`

Recommended additional secrets management:

- Keep secrets in the **production environment** scope.
- Restrict environment access to maintainers.
- Rotate credentials after any exposure event.

See `.github/workflows/deploy-production.yml` for usage.
