#!/usr/bin/env bash
# install.sh — one-line installer for memsync.
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/SUN-1024/memsync/main/install.sh | bash
#
# Environment overrides:
#   MEMSYNC_VERSION   Tag to install (e.g. v1.0.0). Default: latest release.
#   MEMSYNC_PREFIX    Install prefix. Default: /usr/local. Falls back to
#                     PREFIX if MEMSYNC_PREFIX is unset.
#
# After install, `memsync` lives at $PREFIX/bin/memsync and templates/ live
# at $PREFIX/share/memsync/templates.

set -euo pipefail

REPO="SUN-1024/memsync"
VERSION="${MEMSYNC_VERSION:-latest}"
PREFIX="${MEMSYNC_PREFIX:-${PREFIX:-/usr/local}}"
TMP=""

cleanup() {
  if [ -n "$TMP" ] && [ -d "$TMP" ]; then
    rm -rf "$TMP"
  fi
}
trap cleanup EXIT

err() { echo "memsync-install: $*" >&2; }

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
  TMP="$(mktemp -d -t memsync-install.XXXXXX)"

  url="https://github.com/${REPO}/archive/refs/tags/${tag}.tar.gz"
  echo "==> Downloading ${url}"
  curl -fsSL --retry 5 --retry-delay 2 --retry-all-errors "$url" -o "$TMP/m.tgz"
  tar -xzf "$TMP/m.tgz" -C "$TMP"
  src="$TMP/memsync-${tag#v}"

  if [ ! -x "$src/bin/memsync" ]; then
    err "archive missing bin/memsync (looked at $src/bin/memsync)"
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
  local share="$PREFIX/share/memsync"
  $sudo mkdir -p "$PREFIX/bin" "$share"

  echo "==> Installing templates to ${share}/templates"
  $sudo rm -rf "$share/templates"
  $sudo cp -R "$src/templates" "$share/templates"

  echo "==> Installing memsync to ${PREFIX}/bin/memsync"
  # Rewrite TEMPLATE_DIR so the installed script resolves the share path
  # instead of looking for a sibling templates/ directory.
  awk -v target="$share/templates" '
    /^TEMPLATE_DIR=/ && !patched {
      print "TEMPLATE_DIR=\"" target "\""
      patched = 1
      next
    }
    { print }
  ' "$src/bin/memsync" > "$TMP/memsync_patched"

  $sudo install -m 0755 "$TMP/memsync_patched" "$PREFIX/bin/memsync"

  echo
  echo "==> Installed."
  "$PREFIX/bin/memsync" --version

  case ":$PATH:" in
    *":$PREFIX/bin:"*) ;;
    *) echo "Note: ${PREFIX}/bin is not on your PATH; add it before running 'memsync'." ;;
  esac

  cat <<MSG

Next:
  cd /path/to/your/repo
  memsync init       # create .ai/, CLAUDE.md, AGENTS.md
  memsync check      # validate the scaffold

Docs: https://github.com/${REPO}
MSG
}

main "$@"
