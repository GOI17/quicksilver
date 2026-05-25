local M = {}

function M.find_files_in_split(split_cmd)
  local custom = require("quicksilver.telescope.custom_pickers")
  custom.find_files({
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

return M
