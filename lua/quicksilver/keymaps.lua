vim.g.mapleader = " "

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "v", "i" }, "qw", "<Esc>", { desc = "Exit visual/insert mode", nowait = true })

vim.api.nvim_create_user_command("Q", "qa!", {})

vim.api.nvim_create_user_command("Reload", function()
  require("lazy").sync({ wait = true })
  vim.notify("Plugins synced! Restart to fully reload config.", vim.log.levels.INFO)
end, {})

vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

vim.keymap.set("v", "<", "<gv", { desc = "Decrease indent" })
vim.keymap.set("v", ">", ">gv", { desc = "Increase indent" })

vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

vim.keymap.set("n", "<C-w>v", function()
  local telescope = require("telescope.builtin")
  telescope.find_files({
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      map("i", "<CR>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.cmd("rightbelow vsplit " .. selection.path)
      end)
      return true
    end,
  })
end, { desc = "Find files and open in vertical split" })

vim.keymap.set("n", "<C-w>h", function()
  local telescope = require("telescope.builtin")
  telescope.find_files({
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      map("i", "<CR>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.cmd("rightbelow split " .. selection.path)
      end)
      return true
    end,
  })
end, { desc = "Find files and open in horizontal split" })

vim.keymap.set("n", "<C-w>z", function()
  local cur_win = vim.api.nvim_get_current_win()
  if vim.t.maximized_win == cur_win then
    vim.cmd("wincmd =")
    vim.t.maximized_win = nil
  else
    vim.t.maximized_win = cur_win
    vim.cmd("wincmd |")
    vim.cmd("wincmd _")
  end
end, { desc = "Maximize/restore pane" })

vim.keymap.set("n", "<leader>t", "<cmd>lua toggle_opencode()<CR>", { desc = "Toggle opencode terminal" })
vim.keymap.set("n", "<leader>th", "<cmd>lua toggle_terminal_horizontal()<CR>", { desc = "Toggle terminal (bottom)" })
vim.keymap.set("n", "<leader>tv", "<cmd>lua toggle_terminal_vertical()<CR>", { desc = "Toggle terminal (right)" })
vim.keymap.set("n", "<leader>tf", "<cmd>lua toggle_terminal_float()<CR>", { desc = "Toggle terminal (floating)" })
vim.keymap.set("n", "<leader>tt", "<cmd>lua toggle_terminal_tab()<CR>", { desc = "Toggle terminal (tab)" })
