local terminal = require("quicksilver.terminal.options")
local M = {}

-- Setup winbar and autocmds for terminal buffers
terminal.setup()

M.get_new_tab_keymap = "<A-n>"

vim.keymap.set("n", "<space>gg", terminal.open_lazygit, { desc = "Open LazyGit" })

vim.keymap.set({ "n", "t" }, "<C-t>", function()
  local term = terminal.get_terminal()
  if term and term.toggle_termwindow then
    term.toggle_termwindow()
  end
end, { desc = "Toggle betterterm visibility" })

vim.keymap.set("t", "<C-u>", function()
  local term = terminal.get_terminal()
  if term and term.cycle then
    term.cycle(1)
  end
end, { desc = "Cycle terminals to the right" })

vim.keymap.set("t", "<C-y>", function()
  local term = terminal.get_terminal()
  if term and term.cycle then
    term.cycle(-1)
  end
end, { desc = "Cycle terminals to the left" })

vim.keymap.set("t", "<C-d>", function()
  local current = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_delete(current, { force = true })
end, { desc = "Close active terminal" })

return M
