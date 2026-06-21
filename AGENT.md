# AGENT.md — instructions for an AI agent replicating this setup

You are setting up a **macOS-style look on Zorin OS** on a (possibly new)
machine, using this repo. Work methodically and **verify after every step**.
Do not assume; check the live state with `gsettings`/`gnome-extensions`.

## Ground rules
- **Back up first.** Run `scripts/20-backup.sh` before any change. Confirm
  `~/macos-look-backup.sh` exists and is non-trivial. Tell the user the undo
  command: `bash ~/macos-look-backup.sh`.
- **One sudo step.** Only `scripts/10-deps.sh` needs root. If sudo needs a
  password, you cannot run it non-interactively — ask the user to run it
  themselves and continue once they confirm.
- **Verify, don't trust.** After each step read back the relevant keys.
- **Be reversible & honest.** If something fails, report it and point at the
  rollback rather than pressing on.

## Procedure
1. **Preflight** — `bash scripts/00-preflight.sh`. Confirm: OS is Zorin (warn if
   not), GNOME Shell present, and the dir
   `/usr/share/gnome-shell/extensions/zorin-dash@zorinos.com` exists. If
   `zorin-dash` is absent, the dock step is impossible on this machine — tell the
   user and skip step 4 (still do buttons + WhiteSur).
2. **Dependencies** — ensure `sassc`, `glib-compile-resources`, `xmllint` exist.
   If missing, run `scripts/10-deps.sh` (or hand the user the
   `sudo apt install -y sassc libglib2.0-dev-bin libxml2-utils` command).
3. **Backup** — `bash scripts/20-backup.sh`.
4. **Dock layout** — `bash scripts/30-dock-layout.sh`. Then check:
   `gnome-extensions info zorin-dash@zorinos.com`. If it says the extension does
   not exist / is not registered, that is EXPECTED on first run — the shell must
   restart. Ask the user to **restart GNOME Shell (Alt+F2, r, Enter on X11; log
   out/in on Wayland)** and confirm the dock appears before continuing.
5. **Window buttons** — `bash scripts/40-window-buttons.sh`. Verify
   `button-layout` is `'close,minimize,maximize:appmenu'`.
6. **Install WhiteSur** — `bash scripts/50-whitesur.sh`. Verify
   `~/.themes/WhiteSur-Light` exists and `~/.local/share/icons/WhiteSur-light`
   exists.
7. **Apply** — `bash scripts/60-apply-theme.sh light` (or `dark`). Verify
   `gtk-theme`, `user-theme name`, `icon-theme`, `color-scheme`. Remind the user
   that open GTK4 apps must be reopened.

## Known pitfalls (learned the hard way)
- `zorin-dash` ships in the **system** extensions dir but is **not** in
  `gnome-extensions list` until the shell restarts after a fresh
  install/update — `gnome-extensions enable` will say "doesn't exist". Edit the
  `enabled-extensions`/`disabled-extensions` gsettings arrays directly (the
  Python snippet in `scripts/30-dock-layout.sh` does this) and restart the shell.
- Zorin force-enables `zorin-taskbar` via the **session mode**
  (`/usr/share/gnome-shell/modes/zorin.json` + the `enabled-extensions` key), not
  only the normal key — disabling it means adding it to `disabled-extensions`.
- WhiteSur's `-l` (libadwaita) link defaults to **dark**; repoint
  `~/.config/gtk-4.0/gtk.css` to `gtk-Light.css` for a light desktop.
- WhiteSur's installer may try to `apt install xmllint` mid-run via polkit —
  installing `libxml2-utils` up front (step 2) avoids that prompt.

## When done
Summarize what changed, give the rollback command, and offer optional polish:
Apple "Activities" icon (WhiteSur `--shell -i apple`), WhiteSur cursor theme,
macOS wallpaper, or a different accent color (`install.sh -t <color>` in the GTK
theme source).
