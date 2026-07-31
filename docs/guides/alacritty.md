## Alacritty 0.17.0

The minimalist of the four: no tabs, no splits, just the fastest possible grid
of cells plus a proper Vi mode. Config: `~/.config/alacritty/alacritty.toml`
(TOML 1.1), symlinked from this repo.

The repo config opens a 120x32 window with full decorations, runs `/bin/bash`,
sets `TERM=xterm-256color`, and carries the Catppuccin Mocha palette inline.

### Install

```bash
sudo apt install alacritty   # universe repo; may lag upstream (0.16.x)
```

For the latest release, use `cargo install alacritty` instead. The repo
installer handles either case and links the config. Validate after edits (from
the repo root):

```bash
alacritty migrate --config-file configs/alacritty/alacritty.toml --dry-run
```

### Essential Shortcuts

All of these come straight from the repo config.

| Shortcut            | Action                        |
|---------------------|-------------------------------|
| Ctrl+Shift+N        | New window                    |
| Ctrl+Shift+C / V    | Copy / paste                  |
| Ctrl+Shift+F        | Search forward in scrollback  |
| Ctrl+Shift+B        | Search backward               |
| Shift+PageUp / Down | Scroll a page up / down       |
| Ctrl+= / - / 0      | Font bigger / smaller / reset |
| Ctrl+Shift+Space    | Toggle Vi mode (default)      |

### Pro Tips

- Save the config and the window updates instantly; `live_config_reload` is
  on. Perfect for tweaking colors without restarting.
- Vi mode (Ctrl+Shift+Space) turns the scrollback into a vim buffer: `/` to
  search, `v` to select, `y` to yank, `hjkl` to move.
- `osc52 = "OnlyCopy"` is set, so yanking inside tmux or nvim on a remote SSH
  host lands in your local clipboard.
- Search accepts regex. Ctrl+Shift+F, type a pattern, press Enter to jump, and
  Esc leaves the match selected.
- Want more themes? Clone
  [alacritty-theme](https://github.com/alacritty/alacritty-theme) and uncomment
  the `import` line in `[general]`. This repo already inlines Catppuccin Mocha.

### Advanced Learning

- Config reference: <https://alacritty.org/config-alacritty.html> (every
  option, with defaults)
- Hints: bind hint actions to open URLs or run commands on screen text
- IPC: `alacritty msg` creates windows and pushes config changes into a
  running instance
- Pair Alacritty with tmux or zellij for tabs and splits; that combo is the
  intended workflow
