#!/usr/bin/env bash
# Step 40 — move the window control buttons to the left ("traffic lights").
. "$(dirname "$0")/../lib/common.sh"

log "Moving window buttons to the left (macOS traffic lights)"
gset org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:appmenu'
ok "Window buttons set: $(gsettings get org.gnome.desktop.wm.preferences button-layout)"
