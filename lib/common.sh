#!/usr/bin/env bash
# Shared helpers for the linux-macos-zorin-wizard scripts.
# Source this from every step script: . "$(dirname "$0")/../lib/common.sh"

set -euo pipefail

# --- pretty logging -------------------------------------------------------
_c() { printf '\033[%sm' "$1"; }
log()  { printf '%s==>%s %s\n' "$(_c '1;34')" "$(_c 0)" "$*"; }
ok()   { printf '%s  ✓%s %s\n' "$(_c '1;32')" "$(_c 0)" "$*"; }
warn() { printf '%s  !%s %s\n' "$(_c '1;33')" "$(_c 0)" "$*" >&2; }
err()  { printf '%s  ✗%s %s\n' "$(_c '1;31')" "$(_c 0)" "$*" >&2; }
die()  { err "$*"; exit 1; }

# --- helpers --------------------------------------------------------------
have() { command -v "$1" >/dev/null 2>&1; }

# gset SCHEMA KEY VALUE  — set a gsettings key (logs it)
gset() {
  local schema="$1" key="$2" value="$3"
  gsettings set "$schema" "$key" "$value"
}

# Pinned upstream versions so installs are reproducible across machines.
WHITESUR_GTK_TAG="${WHITESUR_GTK_TAG:-2025-07-24}"
WHITESUR_ICON_TAG="${WHITESUR_ICON_TAG:-2025-12-27}"

# Where we download/extract WhiteSur sources.
BUILD_DIR="${BUILD_DIR:-$HOME/.cache/zorin-macos-wizard}"

# The per-machine rollback script produced by 20-backup.sh
BACKUP_FILE="${BACKUP_FILE:-$HOME/macos-look-backup.sh}"

# Extension UUIDs
EXT_TASKBAR="zorin-taskbar@zorinos.com"   # Windows-style dash-to-panel (default)
EXT_DASH="zorin-dash@zorinos.com"         # Dash-to-Dock fork (the macOS dock)
