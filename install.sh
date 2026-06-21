#!/usr/bin/env bash
# linux-macos-zorin-wizard — one-shot orchestrator.
# Runs every step in order. Idempotent: safe to re-run.
#
# Usage:
#   ./install.sh            # full setup, light theme
#   ./install.sh dark       # full setup, dark theme
#   ./install.sh --no-deps  # skip the sudo apt step (deps already installed)
#
# After it finishes you MUST restart GNOME Shell (Alt+F2, r, Enter) or log out/in
# the first time, so the shell registers the zorin-dash dock.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
. "$HERE/lib/common.sh"

VARIANT=light
RUN_DEPS=1
for a in "$@"; do
  case "$a" in
    light|dark) VARIANT="$a" ;;
    --no-deps)  RUN_DEPS=0 ;;
    *) die "Unknown argument: $a (use: light|dark|--no-deps)" ;;
  esac
done

bash "$HERE/scripts/00-preflight.sh"
[ "$RUN_DEPS" -eq 1 ] && bash "$HERE/scripts/10-deps.sh"
bash "$HERE/scripts/20-backup.sh"
bash "$HERE/scripts/30-dock-layout.sh"
bash "$HERE/scripts/40-window-buttons.sh"
bash "$HERE/scripts/50-whitesur.sh"
bash "$HERE/scripts/60-apply-theme.sh" "$VARIANT"

cat <<EOF

$(_c '1;32')All steps complete.$(_c 0)

  Next:  Restart GNOME Shell  ->  Alt+F2, type r, Enter   (or log out/in)
         This is REQUIRED the first time so the dock (zorin-dash) loads.

  Undo everything:  bash "$BACKUP_FILE"   (then restart the shell again)

  Switch theme later:  ./scripts/60-apply-theme.sh dark   (or: light)
EOF
