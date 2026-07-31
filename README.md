# ubuntu-terminal-config

Curated configs for five terminals on Ubuntu: one font, one theme, one
installer. Configs deploy as symlinks, so a `git pull` in this repo updates
every terminal at once.

## Terminals

| Terminal  | Version                  | Config format | Config path                            | Install method            |
|-----------|--------------------------|---------------|----------------------------------------|---------------------------|
| Ghostty   | 1.3.1                    | key=value     | `~/.config/ghostty/config`             | PPA `mkasberg/ghostty`    |
| Kitty     | 0.48.2                   | kitty.conf    | `~/.config/kitty/kitty.conf`           | Official binary installer |
| Alacritty | 0.17.0 (apt has 0.16.1)  | TOML 1.1      | `~/.config/alacritty/alacritty.toml`   | apt (universe)            |
| WezTerm   | 20240203-110809-5046fc22 | Lua           | `~/.config/wezterm/wezterm.lua`        | .deb from GitHub releases |
| Foot      | 1.25.0                   | INI           | `~/.config/foot/foot.ini`              | apt (universe, Wayland-only) |

## Features

- Maple Mono NF CN everywhere: Nerd Font icons plus CJK glyphs in one font
- Catppuccin Mocha dark theme across all five (unified palette)
- 0.92 background opacity and a bar/beam cursor across all five
- Shell integration enabled where available (prompt marks, sudo hint, cwd reporting)
- 10k+ scrollback lines, copy-on-select, mouse hides while typing
- Installer validates every config after deploying it and reports per terminal

## Quick start

```bash
git clone <repo-url> && cd ubuntu-terminal-config
./scripts/install.sh
```

Run it as a normal user; it asks for sudo itself. Per terminal, the script:

1. Installs the terminal if missing (skips ones you already have).
2. Backs up any existing config to `<path>.bak.<timestamp>`.
3. Symlinks the repo config into `~/.config/<terminal>/`.
4. Runs that terminal's config validator and prints OK or FAILED.

Target platform: Ubuntu 24.04+/26.04, Wayland or X11. Foot requires Wayland.

## Manual install

Pick just the terminals you want, then symlink the matching config.

**Ghostty**

```bash
sudo add-apt-repository ppa:mkasberg/ghostty
sudo apt update && sudo apt install ghostty
ln -sf "$PWD/configs/ghostty/config" ~/.config/ghostty/config
```

**Kitty**

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf "$PWD/configs/kitty/kitty.conf" ~/.config/kitty/kitty.conf
```

The binary lands in `~/.local/kitty.app/`; link `kitty` and `kitten` into
`~/.local/bin` to get them on PATH.

**Alacritty**

```bash
sudo apt install alacritty   # universe; may lag upstream
ln -sf "$PWD/configs/alacritty/alacritty.toml" ~/.config/alacritty/alacritty.toml
```

**WezTerm**

Grab the `.deb` from [GitHub releases](https://github.com/wez/wezterm/releases)
(the Ubuntu 22.04 build runs fine on 24.04/26.04), then:

```bash
sudo apt install ./wezterm-*.deb
ln -sf "$PWD/configs/wezterm/wezterm.lua" ~/.config/wezterm/wezterm.lua
```

**Foot**

```bash
sudo apt install foot   # Wayland only
ln -sf "$PWD/configs/foot/foot.ini" ~/.config/foot/foot.ini
```

## Customization

All five source files live under `configs/<terminal>/`. Edit, save, done:
Kitty and Ghostty reload with Ctrl+Shift+comma, WezTerm and Alacritty watch
their files and reload on save, Foot reloads on SIGHUP (or restart).

- **Font:** replace `Maple Mono NF CN` in all five configs. Pick another Nerd
  Font with CJK coverage, or CJK fallback gets ugly.
- **Theme:** all five carry an inline Catppuccin Mocha palette (or name it
  directly in Ghostty/WezTerm). Swap colors in any config to re-theme.
- **Opacity:** grep for `0.92`; each terminal spells the key differently.

Validate before committing (full table in AGENTS.md), from the repo root:

```bash
ghostty +validate-config --config-file=configs/ghostty/config
alacritty migrate --config-file configs/alacritty/alacritty.toml --dry-run
luac -p configs/wezterm/wezterm.lua
foot --config=configs/foot/foot.ini --check-config
```

## Guides

- [Ghostty](docs/guides/ghostty.md): splits, command palette, shell integration
- [Kitty](docs/guides/kitty.md): kittens, layouts, remote control
- [Alacritty](docs/guides/alacritty.md): Vi mode, search, OSC 52 clipboard
- [WezTerm](docs/guides/wezterm.md): leader key, Lua config, SSH domains
- [Foot](docs/guides/foot.md): Wayland-native, lightweight, server mode

## Alternatives

Not covered by this repo, but worth knowing:

- **Black Box** - GNOME Circle terminal, GTK4, polished UI. `flatpak install flathub com.raggesilver.BlackBox`
- **Ptyxis Terminal** - GNOME's new default terminal (Ubuntu 26.04+). `apt install ptyxis`
- **tmux / zellij** - Terminal multiplexers, not emulators. Pair with any terminal above for sessions, splits, and persistence. `apt install tmux` or `cargo install zellij`

## License

MIT
