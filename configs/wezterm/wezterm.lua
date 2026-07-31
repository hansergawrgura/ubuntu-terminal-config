-- ─────────────────────────────────────────────────────────────
-- WezTerm terminal configuration
-- Version target: 20240203-110809-5046fc22 (stable)
-- Docs:   https://wezterm.org/config/
-- Themes: https://wezfurlong.org/wezterm/colorschemes/
-- Validate this file (headless):
--   luac -p configs/wezterm/wezterm.lua
--   wezterm ls-fonts > /dev/null
-- ─────────────────────────────────────────────────────────────

local wezterm = require 'wezterm'
local act = wezterm.action

local config = wezterm.config_builder()

-- Catch typos in field names as hard errors instead of warnings
config:set_strict_mode(true)

-- ── Font ──────────────────────────────────────────────────────
config.font = wezterm.font('Maple Mono NF CN')
config.font_size = 12.0
config.line_height = 1.0

-- ── Color scheme ──────────────────────────────────────────────
config.color_scheme = 'Catppuccin Mocha'

-- ── Window ────────────────────────────────────────────────────
config.initial_cols = 120
config.initial_rows = 32
config.window_background_opacity = 0.92
config.window_padding = {
  left = 4, right = 4, top = 4, bottom = 4,
}
config.window_decorations = "RESIZE"
config.window_close_confirmation = 'AlwaysPrompt'

-- ── Tab bar ───────────────────────────────────────────────────
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32

-- ── Cursor ────────────────────────────────────────────────────
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 800

-- ── Scrollback ────────────────────────────────────────────────
config.scrollback_lines = 10000

-- ── Behavior ──────────────────────────────────────────────────
config.exit_behavior = 'Close'
config.quit_when_all_windows_are_closed = true
config.automatically_reload_config = true
config.audible_bell = 'Disabled'
config.hide_mouse_cursor_when_typing = true

-- ── Environment ───────────────────────────────────────────────
config.set_environment_variables = {
  TERM = 'xterm-256color',
}

-- ── Keys (leader = Ctrl+q, tmux-style) ────────────────────────
config.leader = { key = 'q', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- Reload
  { key = 'r', mods = 'LEADER', action = act.ReloadConfiguration },
  -- Tabs
  { key = 'c', mods = 'LEADER', action = act.SpawnTab 'CurrentPaneDomain' },
  { key = 'x', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },
  { key = 'Tab',  mods = 'LEADER',       action = act.ActivateTabRelative(1) },
  { key = 'Tab',  mods = 'LEADER|SHIFT', action = act.ActivateTabRelative(-1) },
  { key = '1', mods = 'LEADER', action = act.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = act.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = act.ActivateTab(2) },
  -- Splits
  { key = '|', mods = 'LEADER|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = '-', mods = 'LEADER',       action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  -- Pane navigation
  { key = 'LeftArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Left' },
  { key = 'DownArrow',  mods = 'LEADER', action = act.ActivatePaneDirection 'Down' },
  { key = 'UpArrow',    mods = 'LEADER', action = act.ActivatePaneDirection 'Up' },
  { key = 'RightArrow', mods = 'LEADER', action = act.ActivatePaneDirection 'Right' },
  -- Font size
  { key = '+', mods = 'CTRL', action = act.IncreaseFontSize },
  { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
  { key = '0', mods = 'CTRL', action = act.ResetFontSize },
  -- Search
  { key = 'f', mods = 'LEADER|CTRL', action = act.Search { CaseSensitiveString = '' } },
}

-- ── Mouse ─────────────────────────────────────────────────────
config.mouse_bindings = {
  {
    event = { Down = { streak = 1, button = 'Right' } },
    mods = 'NONE',
    action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection',
  },
}

return config
