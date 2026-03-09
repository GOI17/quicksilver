local M = {}

---@class TerminalConfig
---@field name string Terminal name (unique identifier)
---@field cmd string Command to execute
---@field direction "horizontal"|"vertical"|"float" Window direction
---@field size number Window size (height or width depending on direction)

---@class MTerminal
---@field name string
---@field cmd string
---@field direction "horizontal"|"vertical"|"float"
---@field bufnr number|nil
---@field winnr number|nil
---@field tabnr number|nil

-- ============================================================================
-- Terminal Registry
-- ============================================================================

---@type table<string, MTerminal>
local terminals = {}

-- ============================================================================
-- Default Configuration
-- ============================================================================

local config = {
  default_shell = vim.o.shell,
  vertical_size = math.floor(vim.o.columns * 0.35),
  horizontal_size = math.floor(vim.o.lines * 0.25),
  tab_position = "end",
}

-- ============================================================================
-- Helper Functions
-- ============================================================================

---Get betterterm module safely
---@return table|nil
local function get_terminal()
  local ok, term = pcall(require, "betterTerm")
  if not ok then
    vim.notify("Error loading betterTerm", vim.log.levels.ERROR)
    return nil
  end
  return term
end

---Check if a terminal window exists for the given buffer
---@param bufnr number
---@return boolean
local function terminal_window_exists(bufnr)
  if not bufnr or bufnr == 0 then
    return false
  end
  return vim.fn.bufexists(bufnr) == 1
end

-- ============================================================================
-- Core API Functions
-- ============================================================================

---Spawn a new terminal with name and optional command
---@param name string|nil Terminal name (prompted if nil)
---@param cmd string|nil Command to run (defaults to shell)
function M.spawn_terminal(name, cmd)
  name = name or ""
  cmd = cmd or config.default_shell

  vim.ui.input({
    prompt = "Terminal name: ",
    default = name,
    completion = "file",
  }, function(input_name)
    if not input_name or input_name == "" then
      vim.notify("Terminal name is required", vim.log.levels.WARN)
      return
    end

    vim.ui.input({
      prompt = "Command: ",
      default = cmd,
      completion = "shell",
    }, function(input_cmd)
      if not input_cmd or input_cmd == "" then
        input_cmd = config.default_shell
      end

      local term = get_terminal()
      if not term then
        vim.cmd("terminal " .. input_cmd)
        vim.cmd("startinsert")
        terminals[input_name] = {
          name = input_name,
          cmd = input_cmd,
          direction = "horizontal",
          bufnr = vim.api.nvim_get_current_buf(),
          winnr = vim.api.nvim_get_current_win(),
        }
        vim.notify("Terminal '" .. input_name .. "' created", vim.log.levels.INFO)
        return
      end

      -- Use betterterm if available
      term.send(input_name, input_cmd)
      terminals[input_name] = {
        name = input_name,
        cmd = input_cmd,
        direction = "horizontal",
        bufnr = vim.api.nvim_get_current_buf(),
        winnr = vim.api.nvim_get_current_win(),
      }
      vim.notify("Terminal '" .. input_name .. "' created", vim.log.levels.INFO)
    end)
  end)
end

---List all terminals and allow toggling one
function M.list_terminals()
  local names = vim.tbl_keys(terminals)

  if #names == 0 then
    vim.notify("No terminals registered", vim.log.levels.INFO)
    return
  end

  vim.ui.select(names, {
    prompt = "Select terminal to toggle: ",
  }, function(choice)
    if choice then
      M.toggle(choice)
    end
  end)
end

---Toggle terminal visibility by name
---@param name string Terminal name
function M.toggle(name)
  local term = terminals[name]
  if not term then
    -- Terminal doesn't exist, create it
    M.spawn_terminal(name)
    return
  end

  -- Check if window exists
  if term.winnr and vim.api.nvim_win_is_valid(term.winnr) then
    -- Close the window
    vim.api.nvim_win_close(term.winnr, false)
    term.winnr = nil
  else
    -- Open terminal
    local term_mod = get_terminal()
    if term_mod and term_mod.toggle_termwindow then
      term_mod.toggle_termwindow()
    else
      vim.cmd("terminal " .. term.cmd)
    end
    term.bufnr = vim.api.nvim_get_current_buf()
    term.winnr = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
  end
end

---Send a command to a named terminal
---@param name string Terminal name
---@param command string Command to send
function M.send(name, command)
  local term = terminals[name]
  if not term then
    vim.notify("Terminal '" .. name .. "' not found", vim.log.levels.WARN)
    return
  end

  local term_mod = get_terminal()
  if term_mod and term_mod.send then
    term_mod.send(name, command)
  else
    -- Fallback: execute in current terminal
    vim.cmd("silent! !" .. command)
  end
end

---Rename a terminal in the registry
---@param name string Current terminal name
---@param new_name string New terminal name
function M.rename(name, new_name)
  local term = terminals[name]
  if not term then
    vim.notify("Terminal '" .. name .. "' not found", vim.log.levels.WARN)
    return
  end

  if terminals[new_name] then
    vim.notify("Terminal '" .. new_name .. "' already exists, overwriting", vim.log.levels.WARN)
  end

  terminals[new_name] = {
    name = new_name,
    cmd = term.cmd,
    direction = term.direction,
    bufnr = term.bufnr,
    winnr = term.winnr,
    tabnr = term.tabnr,
  }
  terminals[name] = nil
  vim.notify("Terminal renamed to '" .. new_name .. "'", vim.log.levels.INFO)
end

---Get list of all registered terminal names
---@return string[]
function M.get_terminals()
  return vim.tbl_keys(terminals)
end

---Close a specific terminal
---@param name string Terminal name to close
function M.close(name)
  local term = terminals[name]
  if not term then
    vim.notify("Terminal '" .. name .. "' not found", vim.log.levels.WARN)
    return
  end

  if term.winnr and vim.api.nvim_win_is_valid(term.winnr) then
    vim.api.nvim_win_close(term.winnr, false)
  end
  if term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
    vim.api.nvim_buf_delete(term.bufnr, { force = true })
  end

  terminals[name] = nil
  vim.notify("Terminal '" .. name .. "' closed", vim.log.levels.INFO)
end

-- ============================================================================
-- Predefined Terminal Functions
-- ============================================================================

---Toggle opencode terminal in vertical split (existing functionality)
function M.toggle_opencode_vertical()
  local term = get_terminal()
  if term and term.toggle_termwindow then
    term.toggle_termwindow()
  else
    vim.cmd("vnew | terminal " .. config.default_shell)
    vim.cmd("startinsert")
  end
end

---Toggle shell in vertical split
function M.toggle_shell_vertical()
  local term = get_terminal()
  if term and term.toggle_termwindow then
    term.toggle_termwindow()
  else
    vim.cmd("vnew | terminal " .. config.default_shell)
    vim.cmd("startinsert")
  end
end

---Toggle shell in horizontal split
function M.toggle_shell_horizontal()
  local term = get_terminal()
  if term and term.toggle_termwindow then
    term.toggle_termwindow()
  else
    vim.cmd("terminal " .. config.default_shell)
    vim.cmd("startinsert")
  end
end

---Toggle shell in new tab
function M.toggle_shell_tab()
  vim.cmd("tabnew | terminal " .. config.default_shell)
  vim.cmd("startinsert")
end

---Toggle opencode in new tab
function M.toggle_opencode_tab()
  vim.cmd("tabnew | terminal " .. config.default_shell)
  vim.cmd("startinsert")
end

-- ============================================================================
-- Backward Compatibility Wrapper
-- ============================================================================

---Toggle opencode terminal (fix for telescope.lua line 57)
function M.toggle_opencode()
  M.toggle_opencode_vertical()
end

-- ============================================================================
-- OpenCode Skill Picker Integration
-- ============================================================================

---Send skill selection to opencode terminal
function M.opencode_skill_pick()
  -- This would integrate with opencode skill picker
  -- For now, just toggle the opencode terminal
  M.toggle_opencode_vertical()
end

-- ============================================================================
-- LazyGit Integration
-- ============================================================================

---Open lazygit in a terminal
function M.open_lazygit()
  vim.cmd("tabnew | terminal lazygit")
  vim.cmd("startinsert")
end

-- Expose get_terminal for backward compatibility
M.get_terminal = get_terminal

return M
