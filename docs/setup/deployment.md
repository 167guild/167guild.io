# Deployment Runbook

1. Copy `deploy/examples/.env.production.example` to `.env.production`.
2. Replace placeholders with real production values.
3. Validate configuration:

```bash
bash deploy/scripts/validate-env.sh .env.production
docker compose --env-file .env.production -f docker-compose.yml -f deploy/production/docker-compose.production.yml config >/dev/null
```

4. Deploy:

```bash
task deploy:production
```

5. Verify:

```bash
task status
task health
task logs
```

## First Boot Workflow (Brand-New Deployment)

After containers are healthy for the first time:

1. Open the wiki URL (`https://167guild.io`).
2. Complete the Wiki.js setup wizard and create the initial emergency admin account.
3. Sign in to the Wiki.js Admin panel.
4. Configure Google OAuth in **Administration → Authentication** (see `docs/setup/oauth.md`).
5. Sign out of the emergency admin account.
6. Sign in with `szmyty@gmail.com` via Google.
7. Sign back in with the emergency admin account, open **Administration → Users**, and assign `szmyty@gmail.com` to **Administrators**.
8. Confirm `szmyty@gmail.com` can access the full Admin area.

## Group Bootstrap

After first boot initializes the Wiki.js schema, seed custom groups:

```bash
docker compose exec -T postgres psql \
  -U "${POSTGRES_USER}" \
  -d "${POSTGRES_DB}" \
  < scripts/bootstrap/seed-groups.sql
```

Then assign users in **Administration → Users**:

- Platform Administrator: `szmyty@gmail.com` → `Administrators`
- Dungeon Master: placeholder DM account from `docs/authorization.md#placeholder-accounts` → `Dungeon Master`
- Players (Alan/Starwhisper, Kevin, Christian, Tom): accounts listed in `docs/authorization.md#placeholder-accounts` → `Player`

Replace placeholder emails with real Google accounts when known.

## Deployment Validation Checklist

- [ ] Google OAuth button is visible on login page.
- [ ] Google login succeeds for `szmyty@gmail.com`.
- [ ] `szmyty@gmail.com` can access Wiki.js Administration.
- [ ] `Dungeon Master`, `Player`, and `Viewer` groups exist after seed.
- [ ] DM account can read/write `/dm/`.
- [ ] Player account cannot read `/dm/` and can write `/characters/` and `/journals/`.
- [ ] Viewer account can read public pages and cannot write.
- [ ] Create first content pages:
  - `/lore/welcome`
  - `/characters/starwhisper`
  - `/journals/session-001`
  - `/dm/private-seed-note` (DM-only)
- [ ] Verify DM-only page is hidden from Player and Viewer accounts.

## v0.1.0 Deployment Execution Record

Date: 2026-06-28

- [x] Google OAuth button visible on login page.
- [x] Google login succeeds for `szmyty@gmail.com`.
- [x] `szmyty@gmail.com` can access Wiki.js Administration.
- [x] `Dungeon Master`, `Player`, and `Viewer` groups exist after seed.
- [x] DM account can read/write `/dm/`.
- [x] Player account cannot read `/dm/` and can write `/characters/` and `/journals/`.
- [x] Viewer account can read public pages and cannot write.
- [x] Created first content pages:
  - `/lore/welcome`
  - `/characters/starwhisper`
  - `/journals/session-001`
  - `/dm/private-seed-note` (DM-only)
- [x] Verified DM-only page is hidden from Player and Viewer accounts.

## Manual Steps to Automate in Future Releases

- Automate first-login group assignment checks after OAuth sign-in.
- Automate namespace permission smoke tests for DM/Player/Viewer roles.
- Automate release checklist execution evidence capture in CI/CD.

## GitHub Actions Deployment

### Manual Deployment (workflow_dispatch)

Trigger a production deployment from the GitHub Actions UI:

1. Go to **Actions → Deploy Production** in the repository.
2. Click **Run workflow**.
3. Optionally specify a branch or tag to deploy (default: `main`).
4. Click **Run workflow** to confirm.

The workflow SSHes into the production server and runs `task deploy:production` followed by `task health`.

### Automated Deployment (release event)

When a GitHub Release is published (triggered by merging a Release Please PR), the deployment workflow automatically:

1. SSHes into the production server.
2. Checks out the release tag.
3. Runs `task deploy:production`.
4. Runs `task health` to verify the deployment.

### Required GitHub Secrets

Configure in **Settings → Environments → production**:

| Secret | Description |
|---|---|
| `PRODUCTION_HOST` | Production server hostname or IP |
| `PRODUCTION_USER` | SSH username on the production server |
| `PRODUCTION_SSH_KEY` | SSH private key for the deployment user |

See `docs/setup/github-secrets.md` for full setup instructions.

### Rollback via GitHub Actions

To roll back to a previous release:

1. Go to **Actions → Deploy Production**.
2. Click **Run workflow**.
3. Enter the previous release tag (e.g. `v0.1.0`) in the `ref` field.
4. Click **Run workflow**.

## Authentication Troubleshooting

- `redirect_uri_mismatch`: update Google Cloud redirect URI and `.env.production` to the exact same callback.
- Google button missing: Google strategy is not enabled in Wiki.js Admin.
- Login works but no access: user not assigned to the expected group.
- Admin lockout: use emergency admin account from setup wizard to repair group assignments.

Backup/restore automation is available via `scripts/backup/backup.sh` and `scripts/restore/restore.sh`.
