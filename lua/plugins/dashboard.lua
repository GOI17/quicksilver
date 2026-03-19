return {
  "nvimdev/dashboard-nvim",
  event = "VimEnter",
  cond = function()
    return vim.fn.argc() == 0
  end,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    theme = "hyper",
    hide = {
      statusline = true,
      tabline = true,
      winbar = true
    },
    config = {
      packages = { enable = false },
      project = { enable = false },
      mru = { enable = false },
      header = {
"  ░██████              ░██           ░██                  ░██░██                                ",
" ░██   ░██                           ░██                     ░██                                ",
"░██     ░██ ░██    ░██ ░██ ░███████  ░██    ░██ ░███████  ░██░██ ░██    ░██  ░███████  ░██░████ ",
"░██     ░██ ░██    ░██ ░██░██    ░██ ░██   ░██ ░██        ░██░██ ░██    ░██ ░██    ░██ ░███     ",
"░██     ░██ ░██    ░██ ░██░██        ░███████   ░███████  ░██░██  ░██  ░██  ░█████████ ░██      ",
" ░██   ░██  ░██   ░███ ░██░██    ░██ ░██   ░██        ░██ ░██░██   ░██░██   ░██        ░██      ",
"  ░██████    ░█████░██ ░██ ░███████  ░██    ░██ ░███████  ░██░██    ░███     ░███████  ░██      ",
"       ░██                                                                                      ",
"        ░██                                                                                     ",
       },
    },
  },
}
