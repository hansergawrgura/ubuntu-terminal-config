#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# ubuntu-terminal-config — one-click installer
# Installs Ghostty, Kitty, Alacritty, WezTerm and deploys configs.
# Target: Ubuntu 24.04+ / 26.04  (x86_64, Wayland or X11)
# ─────────────────────────────────────────────────────────────
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

# ── Logging helpers ───────────────────────────────────────────
_info()  { printf '\033[0;32m[INFO]\033[0m  %s\n'  "$*"; }
_warn()  { printf '\033[1;33m[WARN]\033[0m  %s\n'  "$*" >&2; }
_error() { printf '\033[0;31m[ERROR]\033[0m %s\n' "$*" >&2; }

# ── Preflight ─────────────────────────────────────────────────
[[ $EUID -eq 0 ]] && { _error "Run as a normal user, not root."; exit 1; }
command -v apt >/dev/null 2>&1 || { _error "apt not found — Debian/Ubuntu only."; exit 1; }
sudo -v 2>/dev/null || { _error "sudo access is required."; exit 1; }

# ── Helper: symlink a repo config into ~/.config ──────────────
deploy_config() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  if [[ -L "$dest" ]]; then
    rm -f "$dest"
  elif [[ -e "$dest" ]]; then
    mv "$dest" "${dest}.bak.$(date +%s)"
    _warn "  Backed up existing file → ${dest}.bak.*"
  fi
  ln -sf "$src" "$dest"
  _info "  Linked: $dest → $src"
}

# ── 1. Ghostty ────────────────────────────────────────────────
install_ghostty() {
  _info "=== Ghostty ==="
  if command -v ghostty >/dev/null 2>&1; then
    _info "  Already installed: $(ghostty --version 2>&1 | head -1)"
  else
    _info "  Adding PPA mkasberg/ghostty-ubuntu ..."
    sudo add-apt-repository -y ppa:mkasberg/ghostty
    sudo apt update && sudo apt install -y ghostty
  fi
  deploy_config "$REPO_DIR/configs/ghostty/config" "$HOME/.config/ghostty/config"
  if [[ -f "$HOME/.config/ghostty/config.ghostty" ]] && [[ ! -s "$HOME/.config/ghostty/config.ghostty" ]]; then
    rm -f "$HOME/.config/ghostty/config.ghostty"
    _info "  Removed empty config.ghostty"
  fi
  if ghostty +validate-config --config-file="$REPO_DIR/configs/ghostty/config" >/dev/null 2>&1; then
    _info "  Config validation: OK"
  else
    _warn "  Config validation: FAILED (run ghostty +validate-config manually)"
  fi
}

# ── 2. Kitty ──────────────────────────────────────────────────
install_kitty() {
  _info "=== Kitty ==="
  local kitty_bin="$HOME/.local/kitty.app/bin/kitty"
  if [[ -x "$kitty_bin" ]] || command -v kitty >/dev/null 2>&1; then
    _info "  Already installed: $("$kitty_bin" --version 2>/dev/null || kitty --version 2>/dev/null)"
  else
    _info "  Installing via official binary installer ..."
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
  fi
  # PATH + desktop integration
  mkdir -p "$HOME/.local/bin" "$HOME/.local/share/applications"
  ln -sf "$kitty_bin"          "$HOME/.local/bin/kitty"
  ln -sf "${kitty_bin%kitty}kitten" "$HOME/.local/bin/kitten"
  cp -f "$HOME/.local/kitty.app/share/applications/kitty.desktop"      "$HOME/.local/share/applications/" 2>/dev/null || true
  cp -f "$HOME/.local/kitty.app/share/applications/kitty-open.desktop" "$HOME/.local/share/applications/" 2>/dev/null || true
  sed -i "s|Icon=kitty|Icon=$HOME/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" \
    "$HOME/.local/share/applications/kitty"*.desktop 2>/dev/null || true
  sed -i "s|Exec=kitty|Exec=$kitty_bin|g" \
    "$HOME/.local/share/applications/kitty"*.desktop 2>/dev/null || true

  deploy_config "$REPO_DIR/configs/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
  if "$kitty_bin" +runpy 'from kitty.config import load_config; bad=[]; load_config("'"$REPO_DIR/configs/kitty/kitty.conf"'", accumulate_bad_lines=bad); raise SystemExit(1 if bad else 0)' >/dev/null 2>&1; then
    _info "  Config validation: OK"
  else
    _warn "  Config validation: FAILED"
  fi
}

# ── 3. Alacritty ──────────────────────────────────────────────
install_alacritty() {
  _info "=== Alacritty ==="
  if command -v alacritty >/dev/null 2>&1; then
    _info "  Already installed: $(alacritty --version 2>&1)"
  else
    _info "  Installing via apt (universe) ..."
    sudo apt update && sudo apt install -y alacritty
  fi
  deploy_config "$REPO_DIR/configs/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  if alacritty migrate --config-file "$REPO_DIR/configs/alacritty/alacritty.toml" --dry-run >/dev/null 2>&1; then
    _info "  Config validation: OK"
  else
    _warn "  Config validation: FAILED"
  fi
}

# ── 4. WezTerm ────────────────────────────────────────────────
install_wezterm() {
  _info "=== WezTerm ==="
  if command -v wezterm >/dev/null 2>&1; then
    _info "  Already installed: $(wezterm --version 2>&1)"
  else
    _info "  Installing via GitHub release .deb ..."
    local ver="20240203-110809-5046fc22"
    local deb_url="https://github.com/wez/wezterm/releases/download/${ver}/wezterm-${ver}.Ubuntu22.04.deb"
    local tmpdeb="/tmp/wezterm-${ver}.deb"
    curl -L -o "$tmpdeb" "$deb_url"
    sudo apt install -y "$tmpdeb"
    rm -f "$tmpdeb"
  fi
  deploy_config "$REPO_DIR/configs/wezterm/wezterm.lua" "$HOME/.config/wezterm/wezterm.lua"
  local cfg="$REPO_DIR/configs/wezterm/wezterm.lua"
  local ok=true
  luac -p "$cfg" 2>/dev/null || ok=false
  if $ok; then
    WEZTERM_CONFIG_FILE="$cfg" wezterm ls-fonts >/dev/null 2>/tmp/.wezterm-validate 2>&1 || ok=false
    grep -qiE "error|traceback" /tmp/.wezterm-validate 2>/dev/null && ok=false
  fi
  if $ok; then
    _info "  Config validation: OK"
  else
    _warn "  Config validation: FAILED"
  fi
}

# ── Main ──────────────────────────────────────────────────────
main() {
  _info "ubuntu-terminal-config installer"
  _info "Repo: $REPO_DIR"
  echo

  install_ghostty;  echo
  install_kitty;    echo
  install_alacritty; echo
  install_wezterm

  echo
  _info "=== All done! ==="
  _info "Configs deployed to ~/.config/{ghostty,kitty,alacritty,wezterm}/"
  _info "Launch from app menu, or run:  ghostty | kitty | alacritty | wezterm"
  _info "Guides:  docs/guides/{ghostty,kitty,alacritty,wezterm}.md"
}

main "$@"
