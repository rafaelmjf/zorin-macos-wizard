#!/usr/bin/env bash
# Step 20 — snapshot every setting this wizard changes into a single, runnable
# rollback script. Run BEFORE making changes. Re-running overwrites the backup,
# so only run it on a pristine machine (or keep your first backup safe).
. "$(dirname "$0")/../lib/common.sh"

BK="$BACKUP_FILE"
log "Writing rollback script to $BK"

{
  echo "#!/usr/bin/env bash"
  echo "# Rollback for linux-macos-zorin-wizard — generated $(date)"
  echo "# Restores settings to their values BEFORE the wizard ran."
  echo "# After running this, restart GNOME Shell (Alt+F2, r, Enter) or log out/in."
  echo "set -x"

  # window buttons
  printf 'gsettings set org.gnome.desktop.wm.preferences button-layout "%s"\n' \
    "$(gsettings get org.gnome.desktop.wm.preferences button-layout)"

  # extension enable/disable lists
  printf 'gsettings set org.gnome.shell enabled-extensions "%s"\n' \
    "$(gsettings get org.gnome.shell enabled-extensions)"
  printf 'gsettings set org.gnome.shell disabled-extensions "%s"\n' \
    "$(gsettings get org.gnome.shell disabled-extensions)"

  # every key of both dock engines
  for schema in org.gnome.shell.extensions.zorin-taskbar org.gnome.shell.extensions.zorin-dash; do
    if gsettings list-schemas | grep -qx "$schema"; then
      for k in $(gsettings list-keys "$schema"); do
        printf 'gsettings set %s %s "%s"\n' "$schema" "$k" "$(gsettings get "$schema" "$k")"
      done
    fi
  done

  # theme-related interface keys
  for kv in \
    "org.gnome.desktop.interface gtk-theme" \
    "org.gnome.desktop.interface icon-theme" \
    "org.gnome.desktop.interface cursor-theme" \
    "org.gnome.desktop.interface color-scheme" \
    "org.gnome.shell.extensions.user-theme name"; do
    schema=${kv% *}; key=${kv#* }
    printf 'gsettings set %s %s "%s"\n' "$schema" "$key" "$(gsettings get "$schema" "$key" 2>/dev/null)"
  done

  echo "echo 'Rollback applied. Now restart GNOME Shell: Alt+F2, r, Enter (or log out/in).'"
} > "$BK"

chmod +x "$BK"
ok "Backup written ($(wc -l < "$BK") lines). Undo anytime with: bash $BK"
