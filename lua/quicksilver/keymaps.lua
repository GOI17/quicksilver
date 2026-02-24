vim.g.mapleader = " "

vim.api.nvim_create_user_command("Q", "qa!", {})
vim.api.nvim_create_user_command("Reload", function()
  require("lazy").sync({ wait = true })
  vim.notify("Plugins synced! Restart to fully reload config.", vim.log.levels.INFO)
end, {})

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set({ "v", "i" }, "qw", "<Esc>", { desc = "Exit visual/insert mode", nowait = true })
vim.keymap.set("n", "<leader><leader><BS>", ":qa!<CR>", { desc = "Close quicksilver" })
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
vim.keymap.set("n", "<leader>tov", "<cmd>lua toggle_opencode_vertical()<CR>", { desc = "Opencode terminal (side)" })
vim.keymap.set("n", "<leader>tot", "<cmd>lua toggle_opencode_tab()<CR>", { desc = "Opencode terminal (tab)" })
vim.keymap.set("n", "<leader>tv", "<cmd>lua toggle_shell_vertical()<CR>", { desc = "Terminal (side)" })
vim.keymap.set("n", "<leader>tb", "<cmd>lua toggle_shell_horizontal()<CR>", { desc = "Terminal (bottom)" })
vim.keymap.set("n", "<leader>tt", "<cmd>lua toggle_shell_tab()<CR>", { desc = "Terminal (tab)" })

local function action_helper()
  local actions = {
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
    {
      label = "Go to definition",
      exec = function()
        vim.lsp.buf.definition()
      end,
    },
    {
      label = "Find references (git repo)",
      exec = function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if not ok then
          vim.notify("telescope not available", vim.log.levels.WARN)
          return
        end
        telescope.grep_string({
          default_text = vim.fn.expand("<cword>"),
          word_match = "-w",
        })
      end,
    },
    {
      label = "Search in buffer",
      exec = function()
        local ok, telescope = pcall(require, "telescope.builtin")
        if not ok then
          vim.notify("telescope not available", vim.log.levels.WARN)
          return
        end
        telescope.current_buffer_fuzzy_find({
          default_text = vim.fn.expand("<cword>"),
          word_match = "-w",
        })
      end,
    },
  }

  vim.ui.select(actions, {
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
vim.keymap.set("n", "<leader>fa", function()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope not available", vim.log.levels.WARN)
    return
  end
  telescope.grep_string({
    word_match = "-w",
  })
end, { desc = "Find all" })
vim.keymap.set("n", "<leader>fF", function()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope not available", vim.log.levels.WARN)
    return
  end
  telescope.current_buffer_fuzzy_find({
    word_match = "-w",
  })
end, { desc = "Find current buffer" })
