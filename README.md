# zorin-macos-wizard

Turn a stock **Zorin OS** desktop into a **macOS-style** look — the dock, the
left-side "traffic light" window buttons, and the WhiteSur Big Sur theme —
**without Zorin Pro**. Everything here uses only free/open-source components and
files that already ship with Zorin OS.

> **Key insight:** Zorin Pro's "macOS layout" is not special software. It is just
> a preset configuration of free GNOME extensions that already exist on every
> Zorin install. The Pro-only `.py` layout files are missing, but the underlying
> `zorin-dash` (a Dash-to-Dock fork) is present in
> `/usr/share/gnome-shell/extensions`. This project re-creates the layout from
> those parts and layers the open-source **WhiteSur** theme on top.

## Tested target

| | |
|---|---|
| OS | Zorin OS 18.1 (Ubuntu 24.04 "noble" base) |
| Shell | GNOME Shell 46, X11 |
| Theme | [WhiteSur](https://github.com/vinceliuice/WhiteSur-gtk-theme) GTK + icons (pinned tags) |

It will likely work on nearby Zorin 18.x / GNOME 46 systems. On non-Zorin GNOME
the **dock step needs `zorin-dash` and will be skipped**; the WhiteSur + window
button steps still work.

## What it changes (5 independent layers)

| Layer | macOS trait | Mechanism |
|---|---|---|
| Layout | top bar + floating centered dock | disable `zorin-taskbar`, enable `zorin-dash`, configure the dock |
| Window buttons | traffic lights on the **left** | `org.gnome.desktop.wm.preferences button-layout` |
| App/widget theme | rounded Big Sur windows & menus | WhiteSur GTK theme (`~/.themes`) |
| Icons | macOS-style icons | WhiteSur icon theme (`~/.local/share/icons`) |
| GNOME Shell | themed top bar + dock | WhiteSur shell theme via the `user-theme` extension |

Every change is plain `gsettings` + files in `$HOME`. **Fully reversible** — step
20 writes a one-command rollback script to `~/macos-look-backup.sh`.

## Two ways to use this

### A. Agent-assisted (recommended for a new/unknown machine)
Point a coding agent (e.g. Claude Code) at this repo and tell it to follow
[`AGENT.md`](AGENT.md). The agent runs each step, **verifies** the result,
handles the GNOME Shell restart, and adapts if the machine differs (different
Zorin version, Wayland vs X11, missing extension, etc.). This is the safest path
because the one fiddly part — the shell needing a restart before `zorin-dash`
registers — benefits from a human/agent in the loop to confirm the dock loaded.

### B. Scripted installer (for a machine you know matches the target)
```bash
git clone <this-repo> && cd zorin-macos-wizard
./install.sh            # or:  ./install.sh dark
# then restart GNOME Shell:  Alt+F2 , r , Enter   (or log out/in)
```

Run steps individually if you prefer:
```bash
scripts/00-preflight.sh       # check the machine
scripts/10-deps.sh            # sudo: sassc, libglib2.0-dev-bin, libxml2-utils
scripts/20-backup.sh          # write ~/macos-look-backup.sh  (run FIRST!)
scripts/30-dock-layout.sh     # panel -> dock   (needs shell restart after)
scripts/40-window-buttons.sh  # traffic lights left
scripts/50-whitesur.sh        # download + compile + install WhiteSur
scripts/60-apply-theme.sh light   # apply (or: dark)
```

## Undo
```bash
bash ~/macos-look-backup.sh
# then restart GNOME Shell (Alt+F2, r, Enter)
```

## Notes / gotchas
- **First-run dock:** `zorin-dash` only registers after a GNOME Shell restart,
  because the shell scans the system extension folder at startup. Expect to
  restart the shell once.
- **GTK4/libadwaita apps** (Settings, Files) must be reopened to restyle.
- **Wayland:** `Alt+F2 r` to restart the shell is X11-only; on Wayland, log out
  and back in instead.
- **Dock tuning:** edit the `gsettings` lines in `scripts/30-dock-layout.sh`
  (e.g. `intellihide true` to hide only when a window overlaps;
  `require-pressure-to-show false` for instant reveal).

## License
Scripts: MIT. WhiteSur and the Zorin extensions are GPL and remain under their
own licenses; this project only downloads/configures them.
