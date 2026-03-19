local M = {}

-- ============================================================================
-- Winbar Generation
-- ============================================================================

function M.get_winbar()
  -- Guard: check visibility first (cheap check)
  if vim.g.topbar_visible == false then
    return nil
  end

  -- Guard: skip terminal buffers
  local buf_ft = vim.bo.filetype
  if buf_ft == "terminal" or buf_ft == "toggleterm" then
    return nil
  end

  -- Guard: skip narrow windows (prevents E5108)
  local ok, width = pcall(vim.fn.winwidth, vim.fn.bufwinid('%'))
  if ok and width < 50 then
    return nil
  end

  local search_click = "%@v:lua.require('quicksilver.ui.topbar').open_telescope@Search files%*"
  return search_click
end

-- ============================================================================
-- Telescope Integration
-- ============================================================================

function M.open_telescope()
  -- Guard: ensure enough space for telescope popup (prevents E5108)
  local ok, width = pcall(vim.fn.winwidth, vim.fn.bufwinid('%'))
  if ok and width < 60 then
    vim.notify("Window too narrow for file search", vim.log.levels.WARN)
    return
  end

  local telescope = require("telescope.builtin")
  telescope.find_files()
end

function M.toggle_visibility()
  vim.g.topbar_visible = not vim.g.topbar_visible
  vim.cmd("redrawstatus")
end

-- ============================================================================
-- Highlight Groups
-- ============================================================================

local function setup_highlights()
  vim.api.nvim_set_hl(0, "WinBar", { bg = "#363646" })
  vim.api.nvim_set_hl(0, "TopbarSearch", {
    bg = "#1a1a22",
    fg = "#ffffff",
  })
  vim.api.nvim_set_hl(0, "TopbarSearchBorder", {
    fg = "#16161D",
  })
end

-- ============================================================================
-- Autocmd Setup
-- ============================================================================

function M.setup()
  setup_highlights()

  vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
    callback = function()
      local ok, winbar = pcall(M.get_winbar)
      if ok and winbar then
        vim.wo.winbar = winbar
      end
    end,
    desc = "Set topbar winbar",
  })

  vim.api.nvim_create_autocmd({ "WinLeave" }, {
    callback = function()
      pcall(function() vim.wo.winbar = nil end)
    end,
    desc = "Clear topbar winbar on leave",
  })
end

return M