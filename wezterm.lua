-- WezTerm Configuration for Quicksilver
-- This file is symlinked to ~/.config/quicksilver/wezterm.lua

local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- Appearance
-- Use Kanagawa theme to match Neovim's kanagawa.nvim
-- Kanagawa Wave colors (custom scheme)
config.color_scheme = 'Kanagawa'
config.color_schemes = {
  ['Kanagawa'] = {
    background = '#1F1F28', -- sumiInk1
    foreground = '#DCD7BA', -- fujiWhite
    cursor_bg = '#C8C093', -- oldWhite
    cursor_border = '#C8C093', -- oldWhite
    cursor_fg = '#1F1F28', -- sumiInk1
    selection_bg = '#2D4F67', -- waveBlue2
    selection_fg = '#DCD7BA', -- fujiWhite
    ansi = {
      '#16161D', -- black (sumiInk0)
      '#c34043', -- red (autumnRed)
      '#76946a', -- green (autumnGreen)
      '#c0a36e', -- yellow (boatYellow2)
      '#7e9cd8', -- blue (crystalBlue)
      '#957fb8', -- magenta (oniViolet)
      '#6a9589', -- cyan (waveAqua1)
      '#c8c093', -- white (oldWhite)
    },
    brights = {
      '#727169', -- bright black
      '#e82424', -- bright red
      '#98bb6c', -- bright green
      '#e6c384', -- bright yellow
      '#7fb4ca', -- bright blue
      '#938aa9', -- bright magenta
      '#7aa89f', -- bright cyan
      '#dcd7ba', -- bright white
    },
    scrollbar_thumb = '#54546D', -- sumiInk4
    split = '#2D4F67', -- waveBlue2
    tab_bar = {
      background = '#16161D', -- sumiInk0
      active_tab = {
        bg_color = '#2D4F67', -- waveBlue2
        fg_color = '#DCD7BA', -- fujiWhite
        intensity = 'Normal',
        italic = false,
        strikethrough = false,
        underline = 'None',
      },
      inactive_tab = {
        bg_color = '#16161D', -- sumiInk0
        fg_color = '#727169', -- fujiGray
      },
      inactive_tab_hover = {
        bg_color = '#1F1F28', -- sumiInk1
        fg_color = '#DCD7BA', -- fujiWhite
      },
    },
  },
}

config.font = wezterm.font('JetBrains Mono', { weight = 'Regular' })
config.font_size = 13.0
config.line_height = 1.2

-- Tab bar
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false

-- Performance
config.max_fps = 144
config.animation_fps = 60

-- Cursor
config.default_cursor_style = 'BlinkingBlock'

-- Scrollback
config.scrollback_lines = 10000

-- Bell
config.audible_bell = 'Disabled'

-- Hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Additional hyperlink rules for common patterns
table.insert(config.hyperlink_rules, {
  regex = '\\b\\w+://[\\w.-]+\\S*\\b',
  format = '$0',
})

-- ============================================
-- KEY BINDINGS
-- ============================================

config.keys = {
}

-- Mouse key bindings
config.mouse_bindings = {
}

return config
