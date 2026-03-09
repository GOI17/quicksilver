local M = {}

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
function M.grep_current_word()
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
function M.fuzzy_find_buffer()
  local telescope, err = get_telescope()
  if not telescope then
    return
  end

  telescope.current_buffer_fuzzy_find({
    default_text = vim.fn.expand("<cword>"),
    word_match = "-w",
  })
end

vim.keymap.set("n", "<C-w>v", function()
  find_files_in_split("rightbelow vsplit")
end, { desc = "Find files and open in vertical split" })

vim.keymap.set("n", "<C-w>h", function()
  find_files_in_split("rightbelow split")
end, { desc = "Find files and open in horizontal split" })

vim.keymap.set("n", "<leader>fa", M.grep_current_word, { desc = "Find all (grep word)" })
vim.keymap.set("n", "<leader>fF", M.fuzzy_find_buffer, { desc = "Find in current buffer" })

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

return M
