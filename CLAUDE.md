# CLAUDE.md

## What This Repo Is

Public homelab infrastructure-as-code repository. Manages Synology NAS, Cloudflare, UniFi, and other homelab infrastructure via Terraform. All site-specific configuration lives in Doppler — this repo contains zero hardcoded IPs, hostnames, domains, paths, usernames, or email addresses.

## Repository Structure

- `stacks/<target>/<stack>/` — Terraform stacks grouped by infrastructure target
- `modules/` — Reusable Terraform modules (extracted from stacks when duplication emerges)
- `scripts/` — Setup and utility scripts
- `.githooks/` — Git hooks for leakage prevention

## Stack File Convention

Every stack follows this layout:
- `providers.tf` — Doppler + target-specific providers
- `backend.tf` — S3-compatible backend (Backblaze B2)
- `versions.tf` — Terraform and provider version constraints
- `doppler.tf` — `data "doppler_secrets" "this" {}` + `locals` mapping
- `variables.tf` — Only generic defaults (image tags). No site-specific defaults.
- `*.tf` — Resources referencing `local.*` exclusively

## MANDATORY: No Site-Specific Values

**NEVER hardcode any of the following in .tf, .tftpl, or any other tracked file:**
- IP addresses or hostnames
- Domain names
- File/volume paths
- Usernames or email addresses
- Network CIDRs or subnets
- Health check URLs or UUIDs
- Timezone strings
- Any value that identifies a specific deployment

**All such values MUST come from Doppler via `local.*` references in `doppler.tf`.**

Before committing, run `mise run setup` to generate the blocklist, then verify your changes pass the pre-commit hook.

## Validation

```bash
# First-time setup (git hooks + blocklist)
mise run setup

# Init a stack
mise run terraform:init:synology-firewall

# Plan a stack
mise run terraform:plan:synology-firewall

# Apply a stack
mise run terraform:apply:synology-firewall
```

## Secrets & Configuration

All configuration lives in Doppler project `infra-ops`, config `prd`. Both secrets (passwords, API keys) and non-secret config (IPs, domains, paths) are stored there.

The `.env.doppler` file (gitignored) contains:
- `DOPPLER_TOKEN` — read-only service token for `infra-ops/prd`
- `INFRA_B2_*` — Backblaze B2 backend credentials for Terraform state

## Conventions

- **mise** is the task runner for all Terraform operations
- **Doppler** is the single source of truth for all configuration
- **Terraform state** is stored remotely in Backblaze B2 (`infra-ops-tfstate` bucket)
- **No local file dependencies** — the repo is fully reconstructable from Doppler + B2
- **Commit trailers** — always include `Assisted-by: Claude Code` and `Co-Authored-By`
