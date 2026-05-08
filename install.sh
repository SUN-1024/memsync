#!/usr/bin/env bash
# install.sh — one-line installer for repomemo.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/SUN-1024/repomemo/main/install.sh | bash
#
# Environment overrides:
#   REPOMEMO_VERSION   Tag to install (e.g. v1.0.0). Default: latest release.
#   REPOMEMO_PREFIX    Install prefix. Default: /usr/local. Falls back to
#                     PREFIX if REPOMEMO_PREFIX is unset.
#
# After install, `repomemo` lives at $PREFIX/bin/repomemo and templates/ live
# at $PREFIX/share/repomemo/templates.

set -euo pipefail

REPO="SUN-1024/repomemo"
VERSION="${REPOMEMO_VERSION:-latest}"
PREFIX="${REPOMEMO_PREFIX:-${PREFIX:-/usr/local}}"
TMP=""

cleanup() {
  if [ -n "$TMP" ] && [ -d "$TMP" ]; then
    rm -rf "$TMP"
  fi
}
trap cleanup EXIT

err() { echo "repomemo-install: $*" >&2; }

resolve_version() {
  if [ "$VERSION" != "latest" ]; then
    printf '%s' "$VERSION"
    return
  fi
  curl -fsSL --retry 5 --retry-delay 2 --retry-all-errors "https://api.github.com/repos/${REPO}/releases/latest" \
    | awk -F'"' '/"tag_name":/{print $4; exit}'
}

main() {
  for cmd in curl tar awk install; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      err "required command not found: $cmd"
      exit 1
    fi
  done

  local tag
  tag="$(resolve_version)"
  if [ -z "$tag" ]; then
    err "could not resolve a version tag from ${REPO}"
    exit 1
  fi

  local src url
  TMP="$(mktemp -d -t repomemo-install.XXXXXX)"

  url="https://github.com/${REPO}/archive/refs/tags/${tag}.tar.gz"
  echo "==> Downloading ${url}"
  curl -fsSL --retry 5 --retry-delay 2 --retry-all-errors "$url" -o "$TMP/m.tgz"
  tar -xzf "$TMP/m.tgz" -C "$TMP"
  src="$TMP/repomemo-${tag#v}"

  if [ ! -x "$src/bin/repomemo" ]; then
    err "archive missing bin/repomemo (looked at $src/bin/repomemo)"
    exit 1
  fi
  if [ ! -d "$src/templates" ]; then
    err "archive missing templates/ (looked at $src/templates)"
    exit 1
  fi

  # Probe for write access; fall back to sudo on a system prefix.
  local sudo=""
  if ! mkdir -p "$PREFIX/bin" 2>/dev/null; then
    if ! command -v sudo >/dev/null 2>&1; then
      err "${PREFIX} is not writable and sudo is not available"
      exit 1
    fi
    sudo="sudo"
    echo "==> ${PREFIX} is not writable; using sudo (you may be prompted)"
  fi
  local share="$PREFIX/share/repomemo"
  $sudo mkdir -p "$PREFIX/bin" "$share"

  echo "==> Installing templates to ${share}/templates"
  $sudo rm -rf "$share/templates"
  $sudo cp -R "$src/templates" "$share/templates"

  echo "==> Installing repomemo to ${PREFIX}/bin/repomemo"
  # Rewrite TEMPLATE_DIR so the installed script resolves the share path
  # instead of looking for a sibling templates/ directory.
  awk -v target="$share/templates" '
    /^TEMPLATE_DIR=/ && !patched {
      print "TEMPLATE_DIR=\"" target "\""
      patched = 1
      next
    }
    { print }
  ' "$src/bin/repomemo" > "$TMP/repomemo_patched"

  $sudo install -m 0755 "$TMP/repomemo_patched" "$PREFIX/bin/repomemo"

  echo
  echo "==> Installed."
  "$PREFIX/bin/repomemo" --version

  case ":$PATH:" in
    *":$PREFIX/bin:"*) ;;
    *) echo "Note: ${PREFIX}/bin is not on your PATH; add it before running 'repomemo'." ;;
  esac

  cat <<MSG

Next:
  cd /path/to/your/repo
  repomemo init       # create .ai/, CLAUDE.md, AGENTS.md
  repomemo check      # validate the scaffold

Docs: https://github.com/${REPO}
MSG
}

main "$@"
