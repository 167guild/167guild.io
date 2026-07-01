# `guild` Platform CLI

`guild` is the operational CLI for provisioning, deploying, and running the platform.

## Installation

From repository root:

```bash
chmod +x ./guild
./guild help
```

Optional shell alias:

```bash
alias guild="$PWD/guild"
```

## Architecture

The CLI is a dispatcher (`./guild`) that routes to modular scripts:

- `scripts/common/` shared config and logging helpers
- `scripts/doctor/` local diagnostics
- `scripts/gcp/` Google Cloud provisioning and VM access
- `scripts/vm/` VM bootstrap and lifecycle maintenance
- `scripts/deploy/` deployment, redeploy, rollback, verification
- `scripts/release/` release readiness checks
- `scripts/ops/` runtime status/log/health operations
- `scripts/backup/` and `scripts/restore/` backup lifecycle wrappers

## Configuration

Override defaults with environment variables:

- `GUILD_PROJECT_ID`
- `GUILD_REGION`
- `GUILD_ZONE`
- `GUILD_VM_NAME`
- `GUILD_MACHINE_TYPE`
- `GUILD_IP_NAME`
- `GUILD_NETWORK_TAG`
- `GUILD_FIREWALL_RULE`
- `GUILD_SSH_USER`
- `GUILD_DEPLOY_REF`
- `GUILD_DEPLOY_DIR`
- `GUILD_DOMAIN`
- `GUILD_PRODUCTION_ENV_FILE`
- `GUILD_PRODUCTION_COMPOSE_FILE`

## Command Reference

```bash
guild help
guild version
guild doctor

guild gcp doctor
guild gcp enable-apis
guild gcp reserve-ip
guild gcp create-vm
guild gcp delete-vm --yes
guild gcp firewall
guild gcp ip
guild gcp ssh

guild vm bootstrap
guild vm update
guild vm verify
guild vm info

guild deploy
guild redeploy
guild rollback <git-ref>
guild verify

guild release doctor
guild release verify

guild backup
guild restore <backup-dir>

guild status
guild ps
guild logs
guild logs caddy
guild logs wikijs
guild logs postgres
guild restart
guild restart caddy
guild health
```

## Deployment Workflow

After initial VM provisioning and bootstrap, deploy with a single command:

```bash
git pull
guild deploy
```

`guild deploy` handles the complete remote deployment lifecycle:

1. Connects to the production VM via `gcloud compute ssh`.
2. Bootstraps `/opt/167guild.io` (clones the repository) on first run.
3. Syncs the repository (`git fetch`, `git checkout main`, `git pull --ff-only`) on subsequent runs.
4. Uploads `.env.production` from local if not already present on the remote.
5. Executes `task deploy:production` on the remote VM.
6. Runs health checks remotely and prints a deployment summary.

For initial provisioning only:

```bash
guild doctor
guild gcp enable-apis
guild gcp reserve-ip
guild gcp create-vm
guild gcp firewall
guild vm bootstrap
guild deploy
```

## VM Lifecycle

- Provision: `guild gcp create-vm`
- Bootstrap runtime: `guild vm bootstrap`
- Patch system packages: `guild vm update`
- Verify prerequisites: `guild vm verify`
- Inspect metadata: `guild vm info`
- Decommission: `guild gcp delete-vm --yes`

## Troubleshooting

- `guild doctor` for local prerequisites.
- `guild gcp doctor` for GCP account and project checks.
- `guild release doctor` for release config checks.
- `guild logs` or `guild logs wikijs` for service logs.
- `guild health` for runtime health verification.

## Extension Guide

Add new namespaces by creating `scripts/<namespace>/<command>.sh`, then add routing in `./guild`.

Recommended conventions:

- `set -Eeuo pipefail`
- source `scripts/common/lib.sh` and `scripts/common/config.sh`
- idempotent, rerunnable operations
- input validation with clear error messages
