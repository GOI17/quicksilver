-- WezTerm Configuration for Quicksilver
-- This file is symlinked to ~/.config/quicksilver/wezterm.lua

local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

local palette = {
    -- Bg Shades
    sumiInk0 = "#16161D",
    sumiInk1 = "#181820",
    sumiInk2 = "#1a1a22",
    sumiInk3 = "#1F1F28",
    sumiInk4 = "#2A2A37",
    sumiInk5 = "#363646",
    sumiInk6 = "#54546D", --fg

    -- Popup and Floats
    waveBlue1 = "#223249",
    waveBlue2 = "#2D4F67",

    -- Diff and Git
    winterGreen = "#2B3328",
    winterYellow = "#49443C",
    winterRed = "#43242B",
    winterBlue = "#252535",
    autumnGreen = "#76946A",
    autumnRed = "#C34043",
    autumnYellow = "#DCA561",

    -- Diag
    samuraiRed = "#E82424",
    roninYellow = "#FF9E3B",
    waveAqua1 = "#6A9589",
    dragonBlue = "#658594",

    -- Fg and Comments
    oldWhite = "#C8C093",
    fujiWhite = "#DCD7BA",
    fujiGray = "#727169",

    oniViolet = "#957FB8",
    oniViolet2 = "#b8b4d0",
    crystalBlue = "#7E9CD8",
    springViolet1 = "#938AA9",
    springViolet2 = "#9CABCA",
    springBlue = "#7FB4CA",
    lightBlue = "#A3D4D5", -- unused yet
    waveAqua2 = "#7AA89F", -- improve lightness: desaturated greenish Aqua

    -- waveAqua2  = "#68AD99",
    -- waveAqua4  = "#7AA880",
    -- waveAqua5  = "#6CAF95",
    -- waveAqua3  = "#68AD99",

    springGreen = "#98BB6C",
    boatYellow1 = "#938056",
    boatYellow2 = "#C0A36E",
    carpYellow = "#E6C384",

    sakuraPink = "#D27E99",
    waveRed = "#E46876",
    peachRed = "#FF5D62",
    surimiOrange = "#FFA066",
    katanaGray = "#717C7C",

    dragonBlack0 = "#0d0c0c",
    dragonBlack1 = "#12120f",
    dragonBlack2 = "#1D1C19",
    dragonBlack3 = "#181616",
    dragonBlack4 = "#282727",
    dragonBlack5 = "#393836",
    dragonBlack6 = "#625e5a",

    dragonWhite = "#c5c9c5",
    dragonGreen = "#87a987",
    dragonGreen2 = "#8a9a7b",
    dragonPink = "#a292a3",
    dragonOrange = "#b6927b",
    dragonOrange2 = "#b98d7b",
    dragonGray = "#a6a69c",
    dragonGray2 = "#9e9b93",
    dragonGray3 = "#7a8382",
    dragonBlue2 = "#8ba4b0",
    dragonViolet= "#8992a7",
    dragonRed = "#c4746e",
    dragonAqua = "#8ea4a2",
    dragonAsh = "#737c73",
    dragonTeal = "#949fb5",
    dragonYellow = "#c4b28a",--"#a99c8b",
    -- "#8a9aa3",

    lotusInk1 = "#545464",
    lotusInk2 = "#43436c",
    lotusGray = "#dcd7ba",
    lotusGray2 = "#716e61",
    lotusGray3 = "#8a8980",
    lotusWhite0 = "#d5cea3",
    lotusWhite1 = "#dcd5ac",
    lotusWhite2 = "#e5ddb0",
    lotusWhite3 = "#f2ecbc",
    lotusWhite4 = "#e7dba0",
    lotusWhite5 = "#e4d794",
    lotusViolet1 = "#a09cac",
    lotusViolet2 = "#766b90",
    lotusViolet3 = "#c9cbd1",
    lotusViolet4 = "#624c83",
    lotusBlue1 = "#c7d7e0",
    lotusBlue2 = "#b5cbd2",
    lotusBlue3 = "#9fb5c9",
    lotusBlue4 = "#4d699b",
    lotusBlue5 = "#5d57a3",
    lotusGreen = "#6f894e",
    lotusGreen2 = "#6e915f",
    lotusGreen3 = "#b7d0ae",
    lotusPink = "#b35b79",
    lotusOrange = "#cc6d00",
    lotusOrange2 = "#e98a00",
    lotusYellow = "#77713f",
    lotusYellow2 = "#836f4a",
    lotusYellow3 = "#de9800",
    lotusYellow4 = "#f9d791",
    lotusRed = "#c84053",
    lotusRed2 = "#d7474b",
    lotusRed3 = "#e82424",
    lotusRed4 = "#d9a594",
    lotusAqua = "#597b75",
    lotusAqua2 = "#5e857a",
    lotusTeal1 = "#4e8ca2",
    lotusTeal2 = "#6693bf",
    lotusTeal3 = "#5a7785",
    lotusCyan = "#d7e3d8",
}
-- The filled in variant of the < symbol
local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
-- The filled in variant of the > symbol
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider

-- Appearance
-- Use Kanagawa theme to match Neovim's kanagawa.nvim
-- Kanagawa Wave colors (custom scheme)
config.color_scheme = 'Kanagawa'
config.color_schemes = {
  ['Kanagawa'] = {
    background = palette.sumiInk3,
    foreground = palette.fujiWhite,
    cursor_bg = palette.oldWhite,
    cursor_border = palette.oldWhite,
    cursor_fg = palette.sumiInk1,
    selection_bg = palette.waveBlue2,
    selection_fg = palette.fujiWhite,
    ansi = {
      palette.sumiInk0,
      palette.autumnRed,
      palette.autumnGreen,
      palette.boatYellow2,
      palette.crystalBlue,
      palette.oniViolet,
      palette.waveAqua1,
      palette.oldWhite,
    },
    brights = {
      palette.fujiGray,
      palette.samuraiRed,
      palette.springGreen,
      palette.carpYellow,
      palette.springBlue,
      palette.springViolet1,
      palette.waveAqua2,
      palette.fujiWhite,
    },
    scrollbar_thumb = palette.sumiInk4,
    split = palette.waveBlue2,
    tab_bar = {
      background = palette.sumiInk3,
      active_tab = {
        bg_color = palette.sumiInk5,
        fg_color = palette.fujiWhite,
        intensity = 'Normal',
        italic = false,
        strikethrough = false,
        underline = 'None',
      },
      inactive_tab = {
        bg_color = palette.sumiInk3,
        fg_color = palette.fujiGray,
      },
      inactive_tab_hover = {
        bg_color = palette.sumiInk1,
        fg_color = palette.fujiWhite,
      },
    },
  },
}
config.font = wezterm.font('JetBrains Mono', { weight = 'Bold' })
config.font_size = 13.0
config.line_height = 1.2

-- Tab bar
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.show_tab_index_in_tab_bar = false
config.window_decorations = "RESIZE"

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
