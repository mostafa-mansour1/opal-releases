#!/usr/bin/env bash
# Manual publish to opal-releases — use when CI fails or for a hotfix.
# Requires: gh CLI authenticated, OPAL built locally (dist/installers/ populated).
#
# Usage:
#   ./opal-releases/publish.sh v1.2.3
set -euo pipefail

PUBLIC_REPO="mostafa-mansour1/opal-releases"

GREEN='\033[0;32m'; CYAN='\033[0;36m'; RED='\033[0;31m'; RESET='\033[0m'
step() { echo -e "\n${CYAN}▶ $*${RESET}"; }
ok()   { echo -e "${GREEN}✓ $*${RESET}"; }
fail() { echo -e "${RED}✗ $*${RESET}" >&2; exit 1; }

TAG=${1:-}
[[ -z "$TAG" ]] && fail "Usage: $0 <tag>  (e.g. v1.2.3)"
[[ "$TAG" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]] || fail "Tag must match vX.Y.Z"
VERSION="${TAG#v}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ARTIFACTS="$ROOT_DIR/dist/installers"

step "Checking built artifacts in $ARTIFACTS …"
required=(
  "OPAL-${VERSION}-arm64.dmg"
  "OPAL-${VERSION}-arm64.zip"
  "OPAL-${VERSION}-x64.dmg"
  "OPAL-${VERSION}-x64.zip"
  "OPAL.Setup.${VERSION}.exe"
  "OPAL-${VERSION}.AppImage"
  "opal_${VERSION}_amd64.deb"
)
for f in "${required[@]}"; do
  [[ -f "$ARTIFACTS/$f" ]] || fail "Missing: $ARTIFACTS/$f  — run 'npm run dist' first"
done
ok "All artifacts present."

step "Staging renamed files …"
TMP=$(mktemp -d)
cp "$ARTIFACTS/OPAL-${VERSION}-arm64.dmg"  "$TMP/OPAL-arm64.dmg"
cp "$ARTIFACTS/OPAL-${VERSION}-arm64.zip"  "$TMP/OPAL-arm64.zip"
cp "$ARTIFACTS/OPAL-${VERSION}-x64.dmg"    "$TMP/OPAL-x64.dmg"
cp "$ARTIFACTS/OPAL-${VERSION}-x64.zip"    "$TMP/OPAL-x64.zip"
cp "$ARTIFACTS/OPAL.Setup.${VERSION}.exe"  "$TMP/OPAL-Setup.exe"
cp "$ARTIFACTS/OPAL-${VERSION}.AppImage"   "$TMP/OPAL-x64.AppImage"
cp "$ARTIFACTS/opal_${VERSION}_amd64.deb"  "$TMP/OPAL-amd64.deb"

step "Creating release $TAG on $PUBLIC_REPO …"
gh release create "$TAG" "$TMP"/* \
  --repo "$PUBLIC_REPO" \
  --title "OPAL $TAG" \
  --notes "Manual release. See https://github.com/mostafa-mansour1/opal/releases/tag/${TAG} for changelog."

rm -rf "$TMP"
ok "Published $TAG → https://github.com/$PUBLIC_REPO/releases/tag/$TAG"
