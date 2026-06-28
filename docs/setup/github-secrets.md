# GitHub Repository Configuration

This document defines the required GitHub repository settings for the 167 Guild Wiki deployment pipeline.

## Actions Permissions

Under **Settings → Actions → General**:

- **Actions permissions**: Allow all actions and reusable workflows
- **Workflow permissions**: Read and write permissions ✅
- **Allow GitHub Actions to create and approve pull requests**: ✅

These settings are required for Release Please to open release PRs and create GitHub Releases.

## Required Secrets

Secrets must be configured in the **`production` environment** under **Settings → Environments → production**.

### SSH Deployment Secrets

| Secret | Description |
|---|---|
| `PRODUCTION_HOST` | Hostname or IP address of the production server |
| `PRODUCTION_USER` | SSH username for the production server (e.g. `ubuntu`) |
| `PRODUCTION_SSH_KEY` | SSH private key with access to the production server |

The production server must have the corresponding SSH public key added to `~/.ssh/authorized_keys` for the deployment user.

Application secrets (database credentials, OAuth keys) remain on the server in `.env.production` and are never stored as GitHub secrets.

### SSH Key Setup

Generate a dedicated deployment keypair (no passphrase — required for unattended automation):

```bash
ssh-keygen -t ed25519 -C "github-deploy@167guild.io" -f ~/.ssh/deploy_key -N ""
```

> **Note:** The empty passphrase (`-N ""`) is intentional. GitHub Actions runs unattended and cannot prompt for a passphrase. The private key is stored as an encrypted GitHub Actions secret and never leaves the runner's memory during a workflow run. Restrict its permissions on the server with a `command=` constraint in `authorized_keys` if additional hardening is desired.

Add the public key to the server:

```bash
ssh-copy-id -i ~/.ssh/deploy_key.pub ubuntu@<PRODUCTION_HOST>
```

Store the private key content (`cat ~/.ssh/deploy_key`) as the `PRODUCTION_SSH_KEY` secret in GitHub.

## Repository Variables

No repository-level variables are required at this time. All environment-specific values are managed through secrets and the server-side `.env.production`.

## Environment Configuration

The `production` environment must exist under **Settings → Environments**.

Recommended environment settings:

- **Required reviewers**: Add maintainers to gate production deployments
- **Deployment branches**: Restrict to `main` and release tags (`v*`)
- **Wait timer**: Optional delay before allowing deployment

## Branch Protection Expectations

For `main`:

- Require pull request reviews before merging
- Require status checks to pass before merging (commitlint, Release Please)
- Restrict who can push to matching branches

These protections ensure every change to `main` is reviewed and passes CI before triggering a release.

## Workflow Summary

| Workflow | File | Trigger | Purpose |
|---|---|---|---|
| Release | `.github/workflows/release.yml` | Push to `main` | Validate commits, run Release Please |
| Deploy Production | `.github/workflows/deploy-production.yml` | `workflow_dispatch`, release published | SSH deploy to production server |

See `.github/workflows/deploy-production.yml` for the deployment workflow and `deploy/README.md` for the deployment runbook.

