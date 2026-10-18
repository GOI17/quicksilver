local M = {}

local select_labels = {
  live_grep = "jump",
  grep_string = "jump",
  current_buffer_fuzzy_find = "jump",
  help_tags = "help",
  commands = "run",
}

function M.attach(prompt_bufnr, context)
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)

  local function update(mode)
    if not vim.api.nvim_win_is_valid(picker.results_win) then
      return
    end

    local hints = {}
    if context.state then
      table.insert(hints, "C-o " .. (context.state.preview_visible and "hide preview" or "show preview"))
      table.insert(hints, "C-l " .. (context.state.path_full and "short paths" or "full paths"))
    end
    table.insert(hints, mode == "i" and "C-/ help" or "? help")
    table.insert(hints, "Enter " .. (context.select_label or select_labels[context.picker] or "open"))
    if context.picker == "buffers" then
      table.insert(hints, "M-d delete")
    end

    -- Keep complete hints visible on narrow layouts; the help menu has the rest.
    local width = vim.api.nvim_win_get_width(picker.results_win) - 4
    while #hints > 1 and vim.fn.strdisplaywidth(table.concat(hints, " | ")) > width do
      table.remove(hints)
    end
    picker.results_title = table.concat(hints, " | ")
    picker.results_border:change_title(picker.results_title)
  end

  update(picker.initial_mode == "insert" and "i" or "n")
  vim.api.nvim_create_autocmd("ModeChanged", {
    buffer = prompt_bufnr,
    callback = function()
      update(vim.v.event.new_mode:sub(1, 1))
    end,
    desc = "Update Telescope shortcut hints for the current mode",
  })
  vim.api.nvim_create_autocmd("VimResized", {
    buffer = prompt_bufnr,
    callback = function()
      update(vim.api.nvim_get_mode().mode:sub(1, 1))
    end,
    desc = "Fit Telescope shortcut hints to the picker width",
  })
end

return M
