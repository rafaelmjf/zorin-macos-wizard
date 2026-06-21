#!/usr/bin/env bash
# Step 00 — verify this machine is a supported target and the tools exist.
. "$(dirname "$0")/../lib/common.sh"

log "Preflight checks"

# OS
if [ -r /etc/os-release ]; then
  . /etc/os-release
  echo "    OS        : ${PRETTY_NAME:-unknown}"
  case "${PRETTY_NAME:-}" in
    *Zorin*) ok "Zorin OS detected" ;;
    *) warn "Not Zorin OS — this was built/tested on Zorin OS 18.1. The dock step relies on Zorin's bundled 'zorin-dash' extension and will not work elsewhere." ;;
  esac
  [ "${VERSION_ID:-}" = "18" ] || warn "Tested on Zorin 18; you have VERSION_ID=${VERSION_ID:-?}. Extension keys may differ."
else
  warn "/etc/os-release missing — cannot identify OS."
fi

# Desktop / session
echo "    Desktop   : ${XDG_CURRENT_DESKTOP:-?}   Session: ${XDG_SESSION_TYPE:-?}"
case "${XDG_CURRENT_DESKTOP:-}" in
  *GNOME*) ok "GNOME-based shell" ;;
  *) warn "Not a GNOME session — the dock + shell-theme steps assume GNOME Shell." ;;
esac
have gnome-shell && echo "    Shell     : $(gnome-shell --version)"

# Required tooling for the gsettings/layout steps (always present on GNOME)
for c in gsettings gnome-extensions python3; do
  have "$c" || die "Missing required command: $c"
done
ok "Core tooling present (gsettings, gnome-extensions, python3)"

# The zorin-dash extension must physically exist for the dock step
if [ -d "/usr/share/gnome-shell/extensions/$EXT_DASH" ]; then
  ok "zorin-dash extension found ($EXT_DASH)"
else
  warn "zorin-dash extension NOT found — the macOS dock step will be skipped/fail on this machine."
fi

# Build tools for WhiteSur (installed by 10-deps.sh)
missing=()
for c in sassc glib-compile-resources xmllint; do have "$c" || missing+=("$c"); done
if [ ${#missing[@]} -eq 0 ]; then
  ok "WhiteSur build tools present"
else
  warn "WhiteSur build tools missing: ${missing[*]} — run scripts/10-deps.sh (needs sudo)."
fi

ok "Preflight done"
