## WezTerm 20240203-110809-5046fc22

A GPU terminal configured entirely in Lua, with tmux-style multiplexing built
in. Config: `~/.config/wezterm/wezterm.lua`, symlinked from this repo.

### Install

Download the `.deb` from [GitHub releases](https://github.com/wez/wezterm/releases)
(the Ubuntu 22.04 build works on 24.04/26.04), or use the apt.fury.io/wez repo:

```bash
sudo apt install ./wezterm-*.deb
```

`./scripts/install.sh` automates the download and links the config. Validate
edits (from the repo root):

```bash
luac -p configs/wezterm/wezterm.lua
WEZTERM_CONFIG_FILE=configs/wezterm/wezterm.lua wezterm ls-fonts >/dev/null
```

### Essential Shortcuts

Leader is Ctrl+q, tmux-style: press it, release, then hit the next key within
one second.

| Shortcut            | Action                         |
|---------------------|--------------------------------|
| Leader+R            | Reload config                  |
| Leader+C            | New tab                        |
| Leader+X            | Close pane (asks first)        |
| Leader+Tab          | Next tab (Shift goes back)     |
| Leader+1 / 2 / 3    | Jump to tab 1 / 2 / 3          |
| Leader+Shift+\|     | Split panes side by side       |
| Leader+-            | Split panes top / bottom       |
| Leader+Arrows       | Move focus between panes       |
| Leader+Ctrl+F       | Search scrollback              |
| Ctrl++ / - / 0      | Font bigger / smaller / reset  |
| Right-click         | Copy selection or open link    |

### Pro Tips

- WezTerm reloads the config on save (`automatically_reload_config`), and
  `set_strict_mode(true)` turns typos in field names into hard errors instead
  of silent ignores.
- Right-click does double duty: on a selection it completes the copy, on a URL
  it opens the link.
- The tab bar hides itself when only one tab is open, keeping single-window
  work clean. Open a second tab (Leader+C) and it appears.
- Hundreds of color schemes ship built in. Change `config.color_scheme` and
  watch it apply live; browse the gallery at
  <https://wezfurlong.org/wezterm/colorschemes/>.
- Every bindable thing is an `act.*` action, and `act.Multiple` chains several
  actions onto one key.

### Advanced Learning

- Docs: <https://wezterm.org/config/> (full Lua config reference)
- Key assignments: <https://wezterm.org/config/keys.html> lists every action
- SSH domains: edit remote hosts as if they were local panes
- Workspaces and the launch menu: group projects and switch between them
- Custom events: `wezterm.on(...)` hooks let Lua react to terminal events
  like bells, title changes, and user vars
