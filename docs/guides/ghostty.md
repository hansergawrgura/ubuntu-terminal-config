## Ghostty 1.3.1

A fast, native, GPU-accelerated terminal. Config lives at
`~/.config/ghostty/config` as plain `key=value` lines, symlinked from this
repo by the installer.

### Install

```bash
sudo add-apt-repository ppa:mkasberg/ghostty
sudo apt update && sudo apt install ghostty
```

Or run `./scripts/install.sh` from the repo root; it installs Ghostty, links
the config, and validates it. Re-validate after any edit (from the repo root):

```bash
ghostty +validate-config --config-file=configs/ghostty/config
```

### Essential Shortcuts

Ghostty ships good defaults, so the repo config only adds the last three rows.

| Shortcut                    | Action                        |
|-----------------------------|-------------------------------|
| Ctrl+Shift+T                | New tab                       |
| Ctrl+Shift+W                | Close tab                     |
| Ctrl+Tab / Ctrl+Shift+Tab   | Next / previous tab           |
| Ctrl+Shift+O                | Split right                   |
| Ctrl+Shift+E                | Split down                    |
| Ctrl+Alt+Arrows             | Focus split in that direction |
| Ctrl+= / Ctrl+- / Ctrl+0    | Font bigger / smaller / reset |
| Ctrl+Shift+C / Ctrl+Shift+V | Copy / paste                  |
| Ctrl+Shift+P                | Command palette               |
| Ctrl+Enter                  | Toggle fullscreen             |
| Ctrl+Shift+,                | Reload config                 |
| Ctrl+PageUp / Ctrl+PageDown | Previous / next tab (custom)  |
| Super+Enter                 | Toggle fullscreen (custom)    |

### Pro Tips

- Copy-on-select is enabled, so highlighting text already puts it on the
  clipboard. Paste with Ctrl+Shift+V.
- `confirm-close-surface` is on: closing a tab that's still running something
  asks first. Your SSH sessions survive stray keystrokes.
- Shell integration auto-injects for bash, zsh, and fish (features: cursor,
  sudo, title, path). The `sudo` feature restyles the prompt when you're root.
- `language = zh` is set so CJK glyphs render without font-fallback errors.
  Keep it if you ever read Chinese, Japanese, or Korean text.
- Run `ghostty +list-themes` to browse the built-in themes. The config
  auto-switches with the system: `dark:Catppuccin Mocha,light:Catppuccin Latte`.

### Advanced Learning

- Full config reference: <https://ghostty.org/docs/config>
- Custom themes: drop theme files into `~/.config/ghostty/themes/`
- Bind any action with `keybind = trigger=action`; see `new_split`,
  `goto_split`, `resize_split`, and `move_tab` in the docs
- The command palette (Ctrl+Shift+P) exposes every bindable action, so use it
  to discover features before wiring your own keys
