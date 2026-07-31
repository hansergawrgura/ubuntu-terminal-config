## Kitty 0.48.2

A GPU-accelerated terminal with a plugin system (kittens) that replaces half a
dozen external tools. Config: `~/.config/kitty/kitty.conf`, symlinked from this
repo. The modifier prefix `kitty_mod` is Ctrl+Shift.

### Install

```bash
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

The repo installer runs this for you, then links `kitty` and `kitten` into
`~/.local/bin` and registers desktop entries. Validate edits (from repo root):

```bash
kitty +runpy 'from kitty.config import load_config; bad=[]; load_config("configs/kitty/kitty.conf", accumulate_bad_lines=bad); raise SystemExit(1 if bad else 0)'
```

### Essential Shortcuts

`kitty_mod` means Ctrl+Shift in every row below.

| Shortcut                    | Action                              |
|-----------------------------|-------------------------------------|
| kitty_mod+T                 | New tab                             |
| kitty_mod+Enter             | New window (split in current tab)   |
| kitty_mod+N                 | New OS window                       |
| kitty_mod+W                 | Close window                        |
| kitty_mod+] / kitty_mod+[   | Focus window right / left           |
| kitty_mod+L                 | Cycle layout (tall, stack, grid...) |
| kitty_mod+Right / Left      | Next / previous tab                 |
| kitty_mod+= / - / 0         | Font bigger / smaller / reset       |
| kitty_mod+C / V             | Copy / paste                        |
| kitty_mod+PageUp / PageDown | Scroll back / forward a page        |
| kitty_mod+,                 | Reload config                       |
| kitty_mod+E                 | Hints kitten (grab URLs and paths)  |

### Pro Tips

- Press kitty_mod+E, then type the two highlighted letters next to any URL or
  file path on screen to open or copy it. No mouse needed.
- `kitten ssh host` logs in and installs kitty's terminfo on the server,
  fixing the "unknown terminal type" breakage plain ssh gives you.
- `kitten icat image.png` renders images inline, and `kitten diff a b` shows a
  side-by-side diff that even handles images.
- Run `kitten themes` for a live theme browser that previews on your actual
  windows, then writes the winner into your config.
- Layouts enabled in this config: tall, stack, grid, horizontal. kitty_mod+L
  cycles them, and each tab remembers its own layout.

### Advanced Learning

- Docs: <https://sw.kovidgoyal.net/kitty/> (the conf reference lists every option)
- More kittens worth learning: `transfer` (send files over ssh),
  `unicode_input`, and `hyperlinked_grep` (clickable ripgrep results)
- Remote control: `kitty @` commands script tabs, windows, and text injection
  from shell scripts
- Startup sessions: `--session` files recreate whole workspaces of tabs and
  splits with one command
