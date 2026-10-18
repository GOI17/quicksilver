local M = {}

function M.is_terminal()
  return vim.bo.buftype == "terminal"
end

function M.get()
  if not M.is_terminal() then
    return ""
  end

  local hints = {}
  local betterterm = vim.bo.filetype == "better_term"
  if vim.api.nvim_get_mode().mode == "t" then
    table.insert(hints, "C-\\ C-n normal")
    if betterterm then
      table.insert(hints, "C-t hide")
      table.insert(hints, "A-n new")
      table.insert(hints, "C-y/C-u prev/next")
    end
    table.insert(hints, "C-d close")
  else
    local leader = vim.g.mapleader or "\\"
    leader = leader == " " and "Space" or leader
    local zoom = vim.t.maximized_win == vim.api.nvim_get_current_win() and "restore" or "maximize"
    table.insert(hints, "i input")
    table.insert(hints, leader .. " tz " .. zoom)
    if betterterm then
      table.insert(hints, "C-t hide")
    end
    table.insert(hints, "C-h/j/k/l panes")
  end

  -- Reserve space for lualine's mode label and keep hints whole on small screens.
  local width = (vim.o.laststatus == 3 and vim.o.columns or vim.api.nvim_win_get_width(0)) - 20
  while #hints > 1 and vim.fn.strdisplaywidth(table.concat(hints, " | ")) > width do
    table.remove(hints)
  end
  return table.concat(hints, " | ")
end

return M
