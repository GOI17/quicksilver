local M = {}

function M.find_files_in_split(split_cmd)
  local custom = require("quicksilver.telescope.custom_pickers")
  custom.find_files({
    select_hint = split_cmd:find("vsplit", 1, true) and "vsplit" or "split",
    attach_mappings = function(prompt_bufnr, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      map({ "i", "n" }, "<CR>", function()
        local selection = action_state.get_selected_entry(prompt_bufnr)
        if not selection then
          return
        end
        actions.close(prompt_bufnr)
        vim.cmd(split_cmd .. " " .. vim.fn.fnameescape(selection.path))
      end, { desc = "Open in " .. split_cmd })
      return true
    end,
  })
end

return M
