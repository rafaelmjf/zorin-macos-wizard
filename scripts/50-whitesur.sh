#!/usr/bin/env bash
# Step 50 — download, compile and install the WhiteSur GTK theme + icon theme
# into the user's home (no sudo). Pinned to known-good upstream tags.
. "$(dirname "$0")/../lib/common.sh"

for c in sassc glib-compile-resources xmllint curl tar; do
  have "$c" || die "Missing '$c'. Run scripts/10-deps.sh first."
done

mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

fetch() { # fetch URL OUTFILE
  [ -s "$2" ] || { log "Downloading $(basename "$2")"; curl -fsSL -o "$2" "$1"; }
}

GTK_SRC="WhiteSur-gtk-theme-$WHITESUR_GTK_TAG"
ICON_SRC="WhiteSur-icon-theme-$WHITESUR_ICON_TAG"

fetch "https://github.com/vinceliuice/WhiteSur-gtk-theme/archive/refs/tags/$WHITESUR_GTK_TAG.tar.gz"  gtk.tar.gz
fetch "https://github.com/vinceliuice/WhiteSur-icon-theme/archive/refs/tags/$WHITESUR_ICON_TAG.tar.gz" icons.tar.gz
[ -d "$GTK_SRC" ]  || tar xzf gtk.tar.gz
[ -d "$ICON_SRC" ] || tar xzf icons.tar.gz

log "Installing WhiteSur GTK theme (all color variants + libadwaita/GTK4 link)"
( cd "$GTK_SRC" && ./install.sh -l )

# The -l flag links the DARK libadwaita css by default. Repoint to light so it
# matches a light desktop (the dark css remains available as gtk-dark.css).
if [ -f "$HOME/.config/gtk-4.0/gtk-Light.css" ]; then
  ln -sf "$HOME/.config/gtk-4.0/gtk-Light.css" "$HOME/.config/gtk-4.0/gtk.css"
  ln -sf "$HOME/.config/gtk-4.0/gtk-Dark.css"  "$HOME/.config/gtk-4.0/gtk-dark.css"
  ok "GTK4/libadwaita link pointed to light"
fi

log "Installing WhiteSur icon theme"
( cd "$ICON_SRC" && ./install.sh )

ok "WhiteSur themes installed. Apply them with scripts/60-apply-theme.sh"
