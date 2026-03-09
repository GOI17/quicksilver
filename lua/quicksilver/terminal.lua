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

local terminals = {}

local function get_betterterm()
  local ok, bt = pcall(require, "betterTerm")
  if not ok then
    vim.notify("betterTerm not available", vim.log.levels.ERROR)
    return nil
  end
  return bt
end

local function parse_direction(dir)
  local direction = dir or "horizontal"
  if direction == "vertical" then
    return "vertical"
  elseif direction == "float" then
    return "float"
  end
  return "horizontal"
end

function M.spawn(name, cmd, opts)
  opts = opts or {}
  local direction = parse_direction(opts.direction)

  local term_opts = {
    direction = direction,
  }

  if opts.size then
    term_opts.size = opts.size
  end

  local bt = get_betterterm()
  if not bt then
    return nil
  end

  bt.open(cmd, term_opts)

  terminals[name] = {
    name = name,
    cmd = cmd,
    direction = direction,
    bufnr = vim.fn.bufnr("$"),
    winnr = vim.fn.win_getid(vim.fn.winnr("$")),
    tabnr = vim.api.nvim_get_current_tabpage(),
  }

  if opts.focus ~= false then
    vim.cmd("startinsert")
  end

  return terminals[name]
end

function M.list()
  return terminals
end

function M.close(name)
  local term = terminals[name]
  if not term then
    vim.notify("Terminal '" .. name .. "' not found", vim.log.levels.WARN)
    return false
  end

  local bt = get_betterterm()
  if not bt then
    return false
  end

  if term.bufnr and vim.api.nvim_buf_is_valid(term.bufnr) then
    vim.api.nvim_buf_delete(term.bufnr, { force = true })
  end

  terminals[name] = nil

  return true
end

function M.send(name, cmd)
  local term = terminals[name]
  if not term then
    vim.notify("Terminal '" .. name .. "' not found", vim.log.levels.WARN)
    return false
  end

  local bt = get_betterterm()
  if not bt then
    return false
  end

  bt.send(name, cmd, nil)

  return true
end

function M.rename(old_name, new_name)
  local term = terminals[old_name]
  if not term then
    vim.notify("Terminal '" .. old_name .. "' not found", vim.log.levels.WARN)
    return false
  end

  terminals[new_name] = vim.tbl_extend("force", term, { name = new_name })
  terminals[old_name] = nil

  return true
end

function M.select()
  local names = vim.tbl_keys(terminals)
  if #names == 0 then
    vim.notify("No terminals available", vim.log.levels.INFO)
    return
  end

  table.sort(names)

  vim.ui.select(names, {
    prompt = "Select Terminal",
  }, function(choice)
    if choice then
      M.toggle(choice)
    end
  end)
end

function M.toggle_opencode()
  local terms = M.list()
  if vim.tbl_count(terms) > 0 then
    M.select()
  else
    vim.cmd("terminal")
    vim.cmd("startinsert")
  end
end

function M.toggle_opencode_vertical()
  vim.cmd("vsplit | terminal")
  vim.cmd("startinsert")
end

function M.toggle_opencode_tab()
  vim.cmd("tabnew | terminal")
  vim.cmd("startinsert")
end

return M
