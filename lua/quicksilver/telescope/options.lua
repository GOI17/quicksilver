local M = {}

-- Lazy-load telescope with error handling
---@return table|nil, string|nil Returns telescope module or nil, error message
function M.get_telescope()
  local ok, telescope = pcall(require, "telescope.builtin")
  if not ok then
    vim.notify("telescope not available", vim.log.levels.WARN)
    return nil, "telescope not available"
  end
  return telescope, nil
end

-- Find files and open in specified split mode
---@param split_cmd string Vim command for split (e.g., "vsplit", "split")
function M.find_files_in_split(split_cmd)
  local telescope, err = M.get_telescope()
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

return M
