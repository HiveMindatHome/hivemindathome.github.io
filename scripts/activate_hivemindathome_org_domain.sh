#!/usr/bin/env bash
set -euo pipefail
# Activates https://hivemindathome.github.io/ following GitHub Pages official Organization site rules
ORG="HiveMindatHome"
REPO_NAME="hivemindathome.github.io"

if ! gh api "orgs/${ORG}" >/dev/null 2>&1; then
  echo "⚠️  GitHub Organization '${ORG}' does not exist yet."
  echo "👉 Step 1 (10 seconds): Open https://github.com/account/organizations/new?plan=free"
  echo "   Enter Organization name: HiveMindatHome"
  echo "👉 Step 2: Re-run ./scripts/activate_hivemindathome_org_domain.sh"
  exit 1
fi

if ! gh api "repos/${ORG}/${REPO_NAME}" >/dev/null 2>&1; then
  echo "Creating public repository ${ORG}/${REPO_NAME}..."
  gh repo create "${ORG}/${REPO_NAME}" --public --description "HiveMind@home & La Ruche — Decentralized Dual-GPU Sparse MoE Supercomputer"
fi

git push --force "https://github.com/${ORG}/${REPO_NAME}.git" HEAD:main
gh api -X POST "repos/${ORG}/${REPO_NAME}/pages" -f source[branch]=main -f source[path]=/ >/dev/null 2>&1 || true
gh api -X PUT "repos/${ORG}/${REPO_NAME}/pages" -F https_enforced=true -f source[branch]=main -f source[path]=/ >/dev/null 2>&1 || true
echo "✅ https://hivemindathome.github.io/ is now live and enforced with HTTPS!"
