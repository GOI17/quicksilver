vim.g.mapleader = " "

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================

-- Lazy-load telescope with error handling
---@return table|nil, string|nil Returns telescope module or nil, error message
local function get_telescope()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope not available", vim.log.levels.WARN)
    return nil, "telescope not available"
  end
  return telescope, nil
end

-- Find files and open in specified split mode
---@param split_cmd string Vim command for split (e.g., "vsplit", "split")
local function find_files_in_split(split_cmd)
  local telescope, err = get_telescope()
  if not telescope then
    return
  end

  telescope.find_files({
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      map("i", "<CR>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        actions.close(prompt_bufnr)
        vim.cmd(split_cmd .. " " .. selection.path)
      end)
      return true
    end,
  })
end

-- Grep string under cursor
local function grep_current_word()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end

  telescope.grep_string({
    default_text = vim.fn.expand("<cword>"),
    word_match = "-w",
  })
end

-- Fuzzy search in current buffer
local function fuzzy_find_buffer()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end

  telescope.current_buffer_fuzzy_find({
    default_text = vim.fn.expand("<cword>"),
    word_match = "-w",
  })
end

-- ============================================================================
-- USER COMMANDS
-- ============================================================================

vim.api.nvim_create_user_command("Q", "qa!", {})
vim.api.nvim_create_user_command("Reload", function()
  for _, file in ipairs({ "options.lua", "keymaps.lua" }) do
    local path = vim.fn.stdpath("config") .. "/lua/quicksilver/" .. file
    pcall(dofile, path)
  end
  require("lazy").sync({ wait = true })
  vim.notify("Sourced lua configs. Best to restart Neovim for full reload.", vim.log.levels.WARN)
end, {})

-- ============================================================================
-- BASIC KEYMAPS
-- ============================================================================

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

-- ============================================================================
-- TELESCOPE KEYMAPS
-- ============================================================================

vim.keymap.set("n", "<C-w>v", function()
  find_files_in_split("rightbelow vsplit")
end, { desc = "Find files and open in vertical split" })

vim.keymap.set("n", "<C-w>h", function()
  find_files_in_split("rightbelow split")
end, { desc = "Find files and open in horizontal split" })

vim.keymap.set("n", "<leader>fa", grep_current_word, { desc = "Find all (grep word)" })
vim.keymap.set("n", "<leader>fF", fuzzy_find_buffer, { desc = "Find in current buffer" })

vim.keymap.set("n", "<A-p>", function()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end
  telescope.find_files()
end, { desc = "Find files (Alt+P)" })

vim.keymap.set("n", "<A-P>", function()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end
  telescope.commands()
end, { desc = "Commands picker (Alt+Shift+P)" })

-- Fallback keymaps (for terminals that don't support Alt modifier)
vim.keymap.set("n", "<Space>p", function()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end
  telescope.find_files()
end, { desc = "Find files (fallback)" })

vim.keymap.set("n", "<Space>P", function()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end
  telescope.commands()
end, { desc = "Commands picker (fallback)" })

-- ============================================================================
-- WINDOW MANAGEMENT
-- ============================================================================

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
    {
      label = "Go to definition",
      exec = function()
        vim.lsp.buf.definition()
      end,
    },
    {
      label = "Find references (git repo)",
      exec = grep_current_word,
    },
    {
      label = "Search in buffer",
      exec = fuzzy_find_buffer,
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

-- ============================================================================
-- GIT TOOLS
-- ============================================================================

vim.keymap.set("n", "<space>gg", require("quicksilver.terminal.keymaps").open_lazygit, { desc = "Open LazyGit" })

-- ============================================================================
-- TERMINAL KEYMAPS
-- ============================================================================

require("quicksilver.terminal.keymaps")

vim.keymap.set("n", "<leader>tt", function()
  require("quicksilver.terminal.keymaps").select()
end, { desc = "Toggle terminal" })

vim.keymap.set("n", "<leader>ts", function()
  vim.ui.input({ prompt = "Command to spawn: " }, function(cmd)
    if cmd and cmd ~= "" then
      vim.ui.input({ prompt = "Terminal name: " }, function(name)
        name = name or cmd
        require("quicksilver.terminal").spawn(name, cmd)
      end)
    end
  end)
end, { desc = "Spawn terminal" })

vim.keymap.set("n", "<leader>tl", function()
  local terms = require("quicksilver.terminal").list()
  local names = vim.tbl_keys(terms)
  if #names == 0 then
    vim.notify("No terminals running", vim.log.levels.INFO)
  else
    vim.notify("Terminals: " .. table.concat(names, ", "), vim.log.levels.INFO)
  end
end, { desc = "List terminals" })

vim.keymap.set("n", "<leader>sl", function()
  local line = vim.api.nvim_get_current_line()
  require("quicksilver.terminal.keymaps").select()
  vim.defer_fn(function()
    require("quicksilver.terminal").send("main", line .. "\n")
  end, 100)
end, { desc = "Send line to terminal" })

vim.keymap.set("n", "<leader>tr", function()
  local terms = require("quicksilver.terminal").list()
  local names = vim.tbl_keys(terms)
  if #names == 0 then
    vim.notify("No terminals to rename", vim.log.levels.WARN)
    return
  end
  vim.ui.select(names, { prompt = "Select terminal to rename:" }, function(old_name)
    if old_name then
      vim.ui.input({ prompt = "New name: " }, function(new_name)
        if new_name and new_name ~= "" then
          require("quicksilver.terminal").rename(old_name, new_name)
        end
      end)
    end
  end)
end, { desc = "Rename terminal" })

vim.keymap.set("n", "<leader>tc", function()
  local terms = require("quicksilver.terminal").list()
  local names = vim.tbl_keys(terms)
  if #names == 0 then
    vim.notify("No terminals to close", vim.log.levels.WARN)
    return
  end
  vim.ui.select(names, { prompt = "Select terminal to close:" }, function(name)
    if name then
      require("quicksilver.terminal").close(name)
    end
  end)
end, { desc = "Close terminal" })

vim.keymap.set("n", "<leader>th", function()
  require("quicksilver.terminal").spawn("htop", "htop", { direction = "horizontal" })
end, { desc = "Open htop" })

vim.keymap.set("n", "<leader>rf", function()
  require("quicksilver.terminal").spawn("ranger", "ranger", { direction = "horizontal" })
end, { desc = "Open ranger" })

return M
