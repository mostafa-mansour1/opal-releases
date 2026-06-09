#!/usr/bin/env bash
# Full local release to opal-releases — builds everything from the private OPAL
# source and publishes directly to GitHub from this machine.
#
# Usage:
#   ./opal-releases/publish.sh                 → patch bump (auto)
#   ./opal-releases/publish.sh minor           → minor bump
#   ./opal-releases/publish.sh major           → major bump
#   ./opal-releases/publish.sh 1.2.3           → exact version
#
# Requirements: gh CLI authenticated, Python 3.11+, Node 20+, PyInstaller
set -euo pipefail

PUBLIC_REPO="mostafa-mansour1/opal-releases"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"   # private OPAL root

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'
step() { echo -e "\n${CYAN}▶ $*${RESET}"; }
ok()   { echo -e "${GREEN}✓ $*${RESET}"; }
warn() { echo -e "${YELLOW}⚠ $*${RESET}"; }
fail() { echo -e "${RED}✗ $*${RESET}" >&2; exit 1; }

cd "$ROOT_DIR"

# ── Determine version ─────────────────────────────────────────────────────────
BUMP=${1:-patch}
CURRENT=$(node -p "require('./package.json').version")

case "$BUMP" in
  major) IFS='.' read -r a b c <<< "$CURRENT"; VERSION="$((a+1)).0.0" ;;
  minor) IFS='.' read -r a b c <<< "$CURRENT"; VERSION="$a.$((b+1)).0" ;;
  patch) IFS='.' read -r a b c <<< "$CURRENT"; VERSION="$a.$b.$((c+1))" ;;
  [0-9]*.[0-9]*.[0-9]*) VERSION="$BUMP" ;;
  *) fail "Unrecognised bump type: $BUMP  (use major / minor / patch / x.y.z)" ;;
esac

TAG="v${VERSION}"

echo ""
echo -e "${BOLD}OPAL local release${RESET}"
echo -e "  From: ${CURRENT}  →  ${BOLD}${VERSION}${RESET}"
echo -e "  Tag:  ${TAG}"
echo -e "  Repo: ${PUBLIC_REPO}"
echo ""
read -rp "  Continue? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || fail "Aborted."

# ── Pre-flight checks ─────────────────────────────────────────────────────────
step "Checking tools …"
command -v gh        >/dev/null || fail "'gh' CLI not found. Install: https://cli.github.com"
command -v python3   >/dev/null || fail "python3 not found"
command -v node      >/dev/null || fail "node not found"
command -v pyinstaller >/dev/null || fail "pyinstaller not found (pip install pyinstaller)"
gh auth status --hostname github.com >/dev/null 2>&1 || fail "gh not authenticated. Run: gh auth login"
ok "All tools present."

# ── Checks ────────────────────────────────────────────────────────────────────
step "Prettier format …"
npm run format

if [[ -n "$(git status --porcelain)" ]]; then
  warn "Prettier changed files — committing automatically."
  git add -A
  git commit -m "style: apply prettier format"
fi

step "TypeScript …"
(cd frontend && npx tsc --noEmit)
ok "No type errors."

step "ESLint …"
(cd frontend && npx eslint src/)
ok "No lint errors."

# ── Build frontend ────────────────────────────────────────────────────────────
step "Building frontend …"
(cd frontend && npm run build)
ok "Frontend built."

# ── Build Python backend ──────────────────────────────────────────────────────
step "Building Python backend …"
python3 -m pip install -r backend/requirements.txt pyinstaller --quiet
pyinstaller scripts/opal-backend.spec \
  --distpath dist \
  --workpath build/pyinstaller \
  --noconfirm
ok "Backend built."

# ── Build Electron installers (macOS native) ──────────────────────────────────
step "Building Electron installers for macOS …"
npm run dist -- --mac dmg zip --arm64 --x64 --publish=never
ok "macOS installers built."

# ── Collect and rename artifacts ──────────────────────────────────────────────
step "Renaming artifacts to version-less filenames …"
ARTIFACTS="$ROOT_DIR/dist/installers"
TMP=$(mktemp -d)

rename_if_exists() {
  local src="$1" dst="$2"
  if [[ -f "$src" ]]; then
    cp "$src" "$TMP/$dst"
    ok "  $dst"
  else
    warn "  Skipped (not found): $(basename "$src")"
  fi
}

rename_if_exists "$ARTIFACTS/OPAL-${VERSION}-arm64.dmg"  "OPAL-arm64.dmg"
rename_if_exists "$ARTIFACTS/OPAL-${VERSION}-arm64.zip"  "OPAL-arm64.zip"
rename_if_exists "$ARTIFACTS/OPAL-${VERSION}-x64.dmg"    "OPAL-x64.dmg"
rename_if_exists "$ARTIFACTS/OPAL-${VERSION}-x64.zip"    "OPAL-x64.zip"

# Windows / Linux artifacts (present if cross-compiled or built in CI)
rename_if_exists "$ARTIFACTS/OPAL.Setup.${VERSION}.exe"  "OPAL-Setup.exe"
rename_if_exists "$ARTIFACTS/OPAL-${VERSION}.AppImage"   "OPAL-x64.AppImage"
rename_if_exists "$ARTIFACTS/opal_${VERSION}_amd64.deb"  "OPAL-amd64.deb"

ls "$TMP"

# ── Bump version in package.json (no git tag yet) ────────────────────────────
step "Bumping version to ${VERSION} …"
npm version "$VERSION" --no-git-tag-version
git add package.json package-lock.json
git commit -m "chore: release ${TAG}"
git tag "$TAG"

# ── Publish release to opal-releases ─────────────────────────────────────────
step "Creating GitHub release ${TAG} on ${PUBLIC_REPO} …"
gh release create "$TAG" "$TMP"/* \
  --repo "$PUBLIC_REPO" \
  --title "OPAL ${TAG}" \
  --notes "## OPAL ${TAG}

| Platform | File |
|---|---|
| macOS Apple Silicon | \`OPAL-arm64.dmg\` · \`OPAL-arm64.zip\` |
| macOS Intel | \`OPAL-x64.dmg\` · \`OPAL-x64.zip\` |
| Windows 64-bit | \`OPAL-Setup.exe\` |
| Linux x64 | \`OPAL-x64.AppImage\` · \`OPAL-amd64.deb\` |"

rm -rf "$TMP"

# ── Push private repo tag ─────────────────────────────────────────────────────
step "Pushing tag ${TAG} to private repo …"
git push
git push origin "$TAG"

# ── Done ─────────────────────────────────────────────────────────────────────
echo ""
ok "Released ${TAG}"
echo "   Public:  https://github.com/${PUBLIC_REPO}/releases/tag/${TAG}"
echo "   Private: https://github.com/mostafa-mansour1/opal/releases/tag/${TAG}"
