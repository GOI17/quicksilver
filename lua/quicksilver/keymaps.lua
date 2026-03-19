vim.g.mapleader = " "

require("quicksilver.oil.keymaps")
require("quicksilver.telescope.keymaps")
require("quicksilver.terminal.keymaps")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "v", "i" }, "qw", "<Esc>", { desc = "Exit visual/insert mode", nowait = true })
vim.keymap.set("n", "<leader><leader><BS>", ":qa!<CR>", { desc = "Close quicksilver" })
vim.keymap.set("v", "<", "<gv", { desc = "Decrease indent" })
vim.keymap.set("v", ">", ">gv", { desc = "Increase indent" })
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
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

-- ============================================================================
-- ACTION HELPER
-- ============================================================================

local function action_helper()
  local actions_list = {
    {
      label = "Rename symbol",
      exec = function()
        vim.lsp.buf.rename()
      end,
    },
    {
      label = "Git blame (line)",
      exec = function()
        local ok, gitsigns = pcall(require, "gitsigns")
        if not ok then
          vim.notify("gitsigns not available", vim.log.levels.WARN)
          return
        end
        gitsigns.blame_line({ full = true })
      end,
    },
  }

  vim.ui.select(actions_list, {
    prompt = "Actions",
    format_item = function(item)
      return item.label
    end,
  }, function(choice)
    if choice and choice.exec then
      choice.exec()
    end
  end)
end

vim.keymap.set("n", "<C-.>", action_helper, { desc = "Action helper menu" })
