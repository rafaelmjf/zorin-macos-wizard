#!/usr/bin/env bash
# Step 10 — install the build tools WhiteSur needs. Requires sudo (will prompt).
# Safe to re-run; apt is idempotent.
. "$(dirname "$0")/../lib/common.sh"

log "Installing build dependencies (sassc, glib-compile-resources, xmllint)"

pkgs=(sassc libglib2.0-dev-bin libxml2-utils)
# (libxml2-utils provides xmllint, which WhiteSur's installer otherwise tries to
#  auto-install mid-run via polkit — installing it up front avoids that prompt.)

if [ "$(id -u)" -eq 0 ]; then
  apt-get update && apt-get install -y "${pkgs[@]}"
else
  sudo apt-get update && sudo apt-get install -y "${pkgs[@]}"
fi

ok "Dependencies installed"
