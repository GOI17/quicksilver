local M = {}

local function get_terminal()
  local ok, term = pcall(require, "quicksilver.terminal")
  if not ok then
    vim.notify("terminal module not available", vim.log.levels.ERROR)
    return nil
  end
  return term
end

function M.toggle(name)
  local term = get_terminal()
  if term then
    term.toggle(name)
  end
end

function M.list()
  local term = get_terminal()
  if term then
    return term.list()
  end
  return {}
end

function M.send(name, cmd)
  local term = get_terminal()
  if term then
    term.send(name, cmd)
  end
end

function M.select()
  local term = get_terminal()
  if term then
    term.select()
  end
end

function M.spawn(name, cmd, opts)
  local term = get_terminal()
  if term then
    term.spawn(name, cmd, opts)
  end
end

function M.open_lazygit()
  vim.cmd("tabnew | terminal lazygit")
  vim.cmd("startinsert")
end

return M
