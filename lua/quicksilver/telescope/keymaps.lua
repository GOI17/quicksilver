local telescope = require("quicksilver.telescope.options")

local M = {}

-- Grep string under cursor
function M.grep_current_word()
  local telescope, err = telescope.get_telescope()
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
  local telescope, err = telescope.get_telescope()
  if not telescope then
    return
  end

  telescope.current_buffer_fuzzy_find({
    default_text = vim.fn.expand("<cword>"),
    word_match = "-w",
  })
end

function M.get_global_telescope_keymaps()
  return {
    -- { "ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>P", function()
        local telescope, err = telescope.get_telescope()
        if not telescope then
          return
        end
        telescope.commands()
      end,
      desc = "Commands picker"
    },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>rc", "<cmd>Commands<cr>", desc = "Run commands" },
    { "<C-w>v", function()
        telescope.find_files_in_split("rightbelow vsplit")
      end,
      desc = "Find files and open in vertical split"
    },
    { "<C-w>h", function()
      telescope.find_files_in_split("rightbelow split")
      end,
      desc = "Find files and open in horizontal split"
    },
    { "<leader>fa", M.grep_current_word, desc = "Find all (grep word)" },
    { "<leader>fF", M.fuzzy_find_buffer, desc = "Find in current buffer" }
  }
end

-- vim.keymap.set("n", "<C-w>v", function()
--   telescope.find_files_in_split("rightbelow vsplit")
-- end, { desc = "Find files and open in vertical split" })

-- vim.keymap.set("n", "<C-w>h", function()
--   telescope.find_files_in_split("rightbelow split")
-- end, { desc = "Find files and open in horizontal split" })

-- vim.keymap.set("n", "<leader>fa", M.grep_current_word, { desc = "Find all (grep word)" })
-- vim.keymap.set("n", "<leader>fF", M.fuzzy_find_buffer, { desc = "Find in current buffer" })

-- Fallback keymaps (for terminals that don't support Alt modifier)
-- vim.keymap.set("n", "<Space>p", function()
--   local telescope, err = telescope.get_telescope()
--   if not telescope then
--     return
--   end
--   telescope.find_files()
-- end, { desc = "Find files (fallback)" })
--
-- vim.keymap.set("n", "<Space>P", function()
--   local telescope, err = telescope.get_telescope()
--   if not telescope then
--     return
--   end
--   telescope.commands()
-- end, { desc = "Commands picker (fallback)" })

return M
