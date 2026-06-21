#!/usr/bin/env bash
# Step 60 — apply WhiteSur to GTK apps, GNOME Shell, and icons.
# Usage: 60-apply-theme.sh [light|dark]   (default: light)
. "$(dirname "$0")/../lib/common.sh"

VARIANT="${1:-light}"
case "$VARIANT" in
  light) GTK=WhiteSur-Light; ICON=WhiteSur-light; SCHEME=prefer-light; G4=gtk-Light.css ;;
  dark)  GTK=WhiteSur-Dark;  ICON=WhiteSur-dark;  SCHEME=prefer-dark;  G4=gtk-Dark.css ;;
  *) die "Unknown variant '$VARIANT' (use: light | dark)" ;;
esac

if [ ! -d "$HOME/.themes/$GTK" ]; then
  die "$GTK not found in ~/.themes — run scripts/50-whitesur.sh first."
fi

log "Applying WhiteSur ($VARIANT)"
gset org.gnome.desktop.interface gtk-theme    "$GTK"
gset org.gnome.shell.extensions.user-theme name "$GTK"   # requires user-theme ext (on by default in Zorin)
gset org.gnome.desktop.interface icon-theme   "$ICON"
gset org.gnome.desktop.interface color-scheme "$SCHEME"
[ -f "$HOME/.config/gtk-4.0/$G4" ] && ln -sf "$HOME/.config/gtk-4.0/$G4" "$HOME/.config/gtk-4.0/gtk.css"

ok "Applied. GTK4/libadwaita apps that are open must be reopened to restyle."
ok "If the shell looks half-themed, restart GNOME Shell: Alt+F2, r, Enter."
