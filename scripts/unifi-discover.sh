#!/usr/bin/env bash
set -euo pipefail

OUTDIR="stacks/unifi/network/.discovery"
mkdir -p "$OUTDIR"

UNIFI_HOST="${UNIFI_HOST:-$(doppler secrets get INFRA_UNIFI_HOST --plain -p infra-ops -c prd)}"
UNIFI_API_KEY="${UNIFI_API_KEY:-$(doppler secrets get INFRA_UNIFI_API_KEY --plain -p infra-ops -c prd)}"

BASE_URL="${UNIFI_HOST}/integration"

fetch() {
  local path="$1"
  local outfile="$2"
  echo "Fetching ${path} ..."
  curl -sSf -k \
    -H "X-API-Key: ${UNIFI_API_KEY}" \
    "${BASE_URL}${path}" | python3 -m json.tool > "${OUTDIR}/${outfile}"
  echo "  → ${OUTDIR}/${outfile} ($(python3 -c "import json; d=json.load(open('${OUTDIR}/${outfile}')); print(len(d) if isinstance(d,list) else len(d.get('data',d)))" 2>/dev/null || echo '?') entries)"
}

# Get site ID first
echo "=== Discovering UniFi configuration ==="
fetch "/v1/sites" "sites.json"
SITE_ID=$(python3 -c "import json; sites=json.load(open('${OUTDIR}/sites.json')); print(sites[0]['id'] if isinstance(sites,list) else sites['data'][0]['id'])")
echo "Site ID: ${SITE_ID}"
echo ""

# Fetch all resource types
fetch "/v1/sites/${SITE_ID}/networks" "networks.json"
fetch "/v1/sites/${SITE_ID}/wifi/broadcasts" "wifi-broadcasts.json"
fetch "/v1/sites/${SITE_ID}/firewall/zones" "firewall-zones.json"
fetch "/v1/sites/${SITE_ID}/firewall/policies" "firewall-policies.json"
fetch "/v1/sites/${SITE_ID}/firewall/policies/ordering" "firewall-policy-ordering.json"
fetch "/v1/sites/${SITE_ID}/dns/policies" "dns-policies.json"
fetch "/v1/sites/${SITE_ID}/acl-rules" "acl-rules.json"
fetch "/v1/sites/${SITE_ID}/traffic-matching-lists" "traffic-matching-lists.json"

# DHCP reservations (legacy endpoint)
echo "Fetching DHCP reservations (legacy endpoint) ..."
UNIFI_TF_USER="${UNIFI_TF_USER:-$(doppler secrets get INFRA_UNIFI_TF_USERNAME --plain -p infra-ops -c prd)}"
UNIFI_TF_PASS="${UNIFI_TF_PASS:-$(doppler secrets get INFRA_UNIFI_TF_PASSWORD --plain -p infra-ops -c prd)}"

# Login to get session cookie
COOKIE_JAR=$(mktemp)
trap "rm -f $COOKIE_JAR" EXIT
curl -sSf -k -c "$COOKIE_JAR" \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"${UNIFI_TF_USER}\",\"password\":\"${UNIFI_TF_PASS}\"}" \
  "${UNIFI_HOST}/api/auth/login" > /dev/null

curl -sSf -k -b "$COOKIE_JAR" \
  "${UNIFI_HOST}/proxy/network/v2/api/site/default/rest/user" \
  | python3 -m json.tool > "${OUTDIR}/dhcp-reservations.json"
echo "  → ${OUTDIR}/dhcp-reservations.json"

echo ""
echo "=== Discovery complete ==="
echo "Site ID: ${SITE_ID}"
echo "Output: ${OUTDIR}/"
echo ""
echo "Review the JSON files, then proceed with generating .tf resources."
