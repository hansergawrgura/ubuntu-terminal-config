# AGENTS.md — Development & Contribution Workflow

## System Info

- Platform: Ubuntu 26.04 LTS (Wayland + X11)
- sudo password: `1`  (use `echo '1' | sudo -S <cmd>` in non-interactive contexts)

## Project Structure

```
configs/
  ghostty/config          # key=value syntax
  kitty/kitty.conf        # kitty directive syntax
  alacritty/alacritty.toml  # TOML 1.1
  wezterm/wezterm.lua     # Lua (wezterm.config_builder)
  foot/foot.ini           # INI (Wayland-only)
scripts/
  install.sh              # one-click installer + config deployer
docs/guides/
  {ghostty,kitty,alacritty,wezterm,foot}.md  # per-terminal quickstart
AGENTS.md                 # this file
README.md
```

## Modifying Configs

1. Edit the file under `configs/<terminal>/`.
2. **Validate before committing** - see the table below.
3. Test launch the terminal if possible.
4. Deploy: run `./scripts/install.sh` (re-symlinks all configs), or manually `ln -sf "$PWD/configs/<name>/<file>" ~/.config/<name>/<file>`.
5. Review and update docs: if behavior changed, update `README.md`, `docs/guides/<name>.md`, and this file accordingly.

### Validation Commands (headless, no GUI needed)

| Terminal  | Command                                                                 |
|-----------|-------------------------------------------------------------------------|
| Ghostty   | `ghostty +validate-config --config-file=configs/ghostty/config`         |
| Kitty     | `kitty +runpy 'from kitty.config import load_config; bad=[]; load_config("configs/kitty/kitty.conf", accumulate_bad_lines=bad); raise SystemExit(1 if bad else 0)'` |
| Alacritty | `alacritty migrate --config-file configs/alacritty/alacritty.toml --dry-run` |
| WezTerm   | `luac -p configs/wezterm/wezterm.lua && WEZTERM_CONFIG_FILE=configs/wezterm/wezterm.lua wezterm ls-fonts >/dev/null 2>&1` (check stderr for errors) |
| Foot      | `foot --config=configs/foot/foot.ini --check-config` |

> All commands must exit 0 with no error output. Run from repo root.

## Adding a New Terminal

1. Create `configs/<name>/` with the config file.
2. Add an install function to `scripts/install.sh`.
3. Add a validation block (see table pattern).
4. Write `docs/guides/<name>.md` (quickstart + shortcuts + advanced).
5. Add a row to the README terminal table.
6. Test: install + validate + launch.

## Git Workflow

```bash
git checkout -b feat/<short-description>
# 1. Make changes under configs/<terminal>/
# 2. Validate (see table above)
# 3. Deploy: ./scripts/install.sh
# 4. Review & update docs (README, guides, AGENTS.md) if behavior changed
git add -A
git commit -m "feat: <what changed>"
git push -u origin HEAD
# Open PR via gh:  gh pr create --fill
```

### Commit Message Convention

- `feat:` new terminal config or feature
- `fix:` config validation error or bug
- `docs:` README, guides, AGENTS.md changes
- `chore:` repo setup, gitignore, etc.

## Key Design Decisions

- **Font:** Maple Mono NF CN (Nerd Font + CJK glyphs) across all terminals.
- **Theme:** Catppuccin Mocha (dark) across all terminals.
- **Ghostty:** `language = zh` set to prevent CJK font-fallback errors.
- **Configs deployed via symlinks** so `git pull` propagates changes instantly.
- **Validation is mandatory** before every commit touching configs.
