-- Winbar module for betterterm terminal
-- Shows zoom icon in terminal buffers

local M = {}

-- ============================================================================
-- Terminal Buffer Detection
-- ============================================================================

---Check if current buffer is a terminal
---@return boolean
local function is_terminal_buffer()
  local buf_ft = vim.bo.filetype
  local buf_name = vim.fn.expand("%:t")
  
  -- Check filetype (term:// or terminal buffer)
  if buf_ft == "terminal" or buf_ft == "toggleterm" then
    return true
  end
  
  -- Check for term:// protocol
  if vim.fn.bufname():match("^term://") then
    return true
  end
  
  -- Check buffer name for betterterm pattern
  if buf_name:match("^term://") or buf_name:match("fzf") then
    return true
  end
  
  return false
end

-- ============================================================================
-- Zoom Icon State
-- ============================================================================

---Check if current window is maximized
---@return boolean
local function is_maximized()
  local cur_win = vim.api.nvim_get_current_win()
  return vim.t.maximized_win == cur_win
end

---Get the appropriate zoom icon based on state
---@return string
local function get_zoom_icon()
  if is_maximized() then
    return "⤣"  -- Collapse icon (maximized state)
  end
  return "⤢"  -- Expand icon (normal state)
end

-- ============================================================================
-- Winbar Generation
-- ============================================================================

---Generate the winbar content for terminal buffers
---@return string|nil
function M.get_winbar()
  -- Only show in terminal buffers
  if not is_terminal_buffer() then
    return nil
  end
  
  local icon = get_zoom_icon()
  local cmd = "lua vim.cmd('lua require(\"quicksilver.terminal\").toggle_fullscreen()')"
  
  -- Build winbar with clickable icon on the right side
  -- %@ makes the icon clickable, calling the function on click
  return "%=%@" .. cmd .. "%" .. icon .. "%"
end

-- ============================================================================
-- Fullscreen Toggle
-- ============================================================================

---Toggle fullscreen for current terminal window
function M.toggle_fullscreen()
  local cur_win = vim.api.nvim_get_current_win()
  
  if not is_terminal_buffer() then
    vim.notify("Not in a terminal buffer", vim.log.levels.WARN)
    return
  end
  
  if is_maximized() then
    -- Restore to normal size
    vim.cmd("wincmd =")
    vim.t.maximized_win = nil
    vim.notify("Terminal restored", vim.log.levels.INFO)
  else
    -- Maximize to fullscreen
    vim.t.maximized_win = cur_win
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
    vim.notify("Terminal maximized", vim.log.levels.INFO)
  end
  
  -- Refresh winbar to update icon
  vim.cmd("redrawstatus")
end

-- ============================================================================
-- Autocmd Setup
-- ============================================================================

---Setup autocmd to activate winbar on terminal buffers
function M.setup()
  -- Set winbar for terminal buffers
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = "term://*",
    callback = function(args)
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].winbar = M.get_winbar()
    end,
    desc = "Set winbar for terminal buffers",
  })
  
  -- Clear winbar when leaving terminal buffer
  vim.api.nvim_create_autocmd({ "BufLeave" }, {
    pattern = "term://*",
    callback = function(args)
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].winbar = nil
    end,
    desc = "Clear winbar when leaving terminal",
  })
  
  -- Update winbar on window focus
  vim.api.nvim_create_autocmd({ "WinEnter" }, {
    callback = function()
      if is_terminal_buffer() then
        vim.cmd("redrawstatus")
      end
    end,
    desc = "Update winbar on window focus",
  })
end

return M