local telescope = require("quicksilver.telescope.options")
local custom = require("quicksilver.telescope.custom_pickers")

local M = {}

function M.grep_current_word()
  custom.grep_string({
    default_text = vim.fn.expand("<cword>"),
    word_match = "-w",
  })
end

function M.fuzzy_find_buffer()
  custom.current_buffer_fuzzy_find({
    default_text = vim.fn.expand("<cword>"),
    word_match = "-w",
  })
end

function M.get_global_telescope_keymaps()
  return {
    { "<leader>p", function() custom.find_files() end, desc = "Find files" },
    { "<leader>P", "<cmd>Telescope commands<cr>", desc = "Commands picker" },
    { "<leader>fb", function() custom.buffers() end, desc = "Find buffer" },
    { "<leader>fg", function() custom.live_grep() end, desc = "Live grep" },
    { "<leader>fh", function() custom.help_tags() end, desc = "Help tags" },
    { "<leader>fr", function() custom.oldfiles() end, desc = "Recent files" },
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

return M
