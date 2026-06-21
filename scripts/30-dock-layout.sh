#!/usr/bin/env bash
# Step 30 — replace the Windows-style panel with the macOS-style dock.
# Disables zorin-taskbar (dash-to-panel) and enables zorin-dash (dash-to-dock),
# then configures the dock to look/behave like the macOS dock.
#
# IMPORTANT: enabling zorin-dash for the first time requires a GNOME Shell
# restart so the shell scans the extension folder. This script flips the
# settings; you must then restart the shell (Alt+F2, r, Enter) or log out/in.
. "$(dirname "$0")/../lib/common.sh"

if [ ! -d "/usr/share/gnome-shell/extensions/$EXT_DASH" ]; then
  die "zorin-dash extension not present on this machine — cannot build the dock. (This is a Zorin-only component.)"
fi

log "Swapping panel -> dock (enable $EXT_DASH, disable $EXT_TASKBAR)"
python3 - "$EXT_TASKBAR" "$EXT_DASH" <<'PY'
import sys
from gi.repository import Gio
TASK, DASH = sys.argv[1], sys.argv[2]
s = Gio.Settings.new("org.gnome.shell")
en = [x for x in s.get_strv("enabled-extensions")  if x not in (TASK, DASH)] + [DASH]
di = [x for x in s.get_strv("disabled-extensions") if x != DASH]
if TASK not in di:
    di.append(TASK)
s.set_strv("enabled-extensions", en)
s.set_strv("disabled-extensions", di)
Gio.Settings.sync()
print("  enabled :", en)
print("  disabled:", di)
PY

log "Configuring the dock to look like macOS"
D=org.gnome.shell.extensions.zorin-dash
gset $D dock-position 'BOTTOM'
gset $D extend-height false              # floating (not full width) -> auto-centers
gset $D dock-fixed false                 # not always-on...
gset $D autohide true                    # ...hide and reveal on mouse-over
gset $D intellihide false                # pure autohide (not "hide only when overlapped")
gset $D require-pressure-to-show true    # deliberate edge-push to reveal
gset $D custom-theme-shrink true         # compact, floating pill
gset $D transparency-mode 'FIXED'
gset $D background-opacity 0.45
gset $D running-indicator-style 'DOTS'
gset $D show-trash false
gset $D show-mounts false
gset $D show-apps-at-top false
gset $D dash-max-icon-size 52

ok "Dock configured."
if gnome-extensions info "$EXT_DASH" >/dev/null 2>&1; then
  ok "zorin-dash is already registered with the running shell."
else
  warn "zorin-dash is NOT registered yet — RESTART GNOME SHELL now: Alt+F2, type r, Enter (X11) or log out/in."
fi
