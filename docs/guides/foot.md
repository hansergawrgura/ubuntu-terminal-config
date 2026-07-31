## Foot 1.25.0

A lightweight, Wayland-native terminal. No GPU acceleration, but fast enough
that you won't notice. Config: `~/.config/foot/foot.ini` (INI format),
symlinked from this repo. Foot is Wayland-only; it will not run under X11.

### Install

```bash
sudo apt install foot
```

Or run `./scripts/install.sh` from the repo root. Validate after edits:

```bash
foot --config=configs/foot/foot.ini --check-config
```

### Essential Shortcuts

Foot's defaults are minimal. The config adds copy/paste/search bindings.

| Shortcut            | Action                        |
|---------------------|-------------------------------|
| Ctrl+Shift+C / V    | Copy / paste                  |
| Ctrl+Shift+F        | Search scrollback             |
| PageUp / PageDown   | Scroll up / down a page       |
| Ctrl+Shift+Plus     | Increase font size            |
| Ctrl+Shift+Minus    | Decrease font size            |
| Ctrl+Shift+0        | Reset font size               |
| Ctrl+Shift+N        | New terminal (server mode)    |

### Pro Tips

- Foot runs a server mode: `foot --server` starts one process, then
  `footclient` opens instant windows sharing that process. Faster startup, less
  RAM. Put `foot --server` in your compositor autostart.
- Foot supports Sixel graphics out of the box. Tools like `img2sixel` render
  images inline without any extra config.
- The config live-reloads on SIGHUP: `pkill -SIGHUP foot` after editing, no
  restart needed.
- `dpi-aware=no` is set so font size stays consistent across HiDPI and LoDPI
  monitors. Change to `yes` if you want per-monitor scaling.
- Foot is the lightest terminal in this repo. If your compositor is wlroots
  based (Sway, Hyprland, River), foot is the native choice.

### Advanced Learning

- Docs: `man foot.ini` (exhaustive, every option with defaults)
- Server mode: `man footclient` for the client/server architecture
- Sixel graphics: `img2sixel file.png` renders inline
- Prompt marking: foot supports OSC 133 for prompt-aware scrollback search
- URL detection: foot highlights URLs and opens them on click by default
