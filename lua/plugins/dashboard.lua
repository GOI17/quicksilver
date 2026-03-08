-- Capture startup time when module loads
local start_time = vim.loop.hrtime()

-- Footer function to display lazy.nvim plugin updates
local function get_footer()
  local ok, lazy_status = pcall(require, "lazy.status")
  if not ok then
    return { "  lazy.nvim not available" }
  end

  -- lazy_status.updates is a function that returns string like "5 updates"
  local updates_str = lazy_status.updates() or "0 updates"
  -- Parse the number from string like "5 updates" or "0 updates"
  local updates = tonumber(updates_str:match("(%d+)"))

  local plugins_count = 0
  local ok2, lazy = pcall(require, "lazy")
  if ok2 then
    local success, plugins = pcall(lazy.plugins)
    if success and plugins then
      plugins_count = #plugins
    end
  end

  local elapsed = (vim.loop.hrtime() - start_time) / 1e6

  local lines = {}
  if updates and updates > 0 then
    table.insert(lines, string.format("  󰋖 %d plugins to update", updates))
  else
    table.insert(lines, "  󰋖 All plugins up to date")
  end
  table.insert(lines, string.format("  󰒲 Started in %.2fms", elapsed))
  table.insert(lines, string.format("  󰐢 %d plugins loaded", plugins_count))

  return lines
end

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
    config = {
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
       footer = get_footer,
       shortcut = {
        {
          icon = "󰊢 ",
          icon_hl = "Title",
          desc = "LazyGit",
          key = "g",
          key_hl = "String",
          action = "Lazygit",
        },
        {
          icon = "󰒲 ",
          icon_hl = "Title",
          desc = "New File",
          key = "n",
          key_hl = "String",
          action = "enew",
        },
        {
          icon = "󰈞 ",
          icon_hl = "Title",
          desc = "Find File",
          key = "f",
          key_hl = "String",
          action = "Telescope find_files",
        },
        {
          icon = "󰋖 ",
          icon_hl = "Title",
          desc = "Update Plugins",
          key = "u",
          key_hl = "String",
          action = "Lazy update",
        },
      },
    },
  },
}
