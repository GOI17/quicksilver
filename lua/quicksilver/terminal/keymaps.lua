local terminal = require("quicksilver.terminal")

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

-- ============================================================================
-- Terminal Management Keymaps
-- ============================================================================

vim.keymap.set("n", "<leader>tn", terminal.spawn_terminal, { desc = "Spawn new terminal" })
vim.keymap.set("n", "<leader>tl", terminal.list_terminals, { desc = "List terminals" })
vim.keymap.set("n", "<leader>to", terminal.toggle_opencode, { desc = "Toggle opencode terminal" })
vim.keymap.set("n", "<leader>tv", terminal.toggle_shell_vertical, { desc = "Toggle shell vertical" })
vim.keymap.set("n", "<leader>th", terminal.toggle_shell_horizontal, { desc = "Toggle shell horizontal" })
vim.keymap.set("n", "<leader>tt", terminal.toggle_shell_tab, { desc = "Toggle shell in tab" })
vim.keymap.set("n", "<leader>tg", terminal.open_lazygit, { desc = "Toggle LazyGit" })
