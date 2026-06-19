#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BLOCKLIST="$REPO_ROOT/.githooks/blocklist.txt"

if [ -z "${DOPPLER_TOKEN:-}" ]; then
  echo "ERROR: DOPPLER_TOKEN not set. Source .env.doppler or set it in your environment." >&2
  exit 1
fi

echo "Generating blocklist from Doppler..."
doppler secrets download --project infra-ops --config prd --no-file --format json \
  | jq -r 'to_entries[] | select(.value | length > 3) | .value' \
  | sort -u \
  > "$BLOCKLIST"

LINE_COUNT=$(wc -l < "$BLOCKLIST" | tr -d ' ')
echo "Blocklist written to $BLOCKLIST ($LINE_COUNT patterns)"
