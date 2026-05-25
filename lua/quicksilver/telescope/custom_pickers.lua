local M = {}

-- Shared toggle state
M.state = {
  path_full = false,       -- false = short paths, true = full paths
  preview_visible = false, -- false = hidden, true = visible
}

-- Preserve last opts per picker so reopen carries search text and options
M._last_opts = {}

local function get_opts()
  local opts = {}
  if M.state.path_full then
    opts.path_display = { "absolute" }
  else
    opts.path_display = { "shorten" }
  end

  if not M.state.preview_visible then
    opts.previewer = false
  end

  return opts
end

local function get_previewer(picker_name, opts)
  local ok, config = pcall(require, "telescope.config")
  if not ok then
    return nil
  end

  if picker_name == "live_grep" or picker_name == "grep_string" or picker_name == "current_buffer_fuzzy_find" then
    return config.values.grep_previewer(opts)
  end

  return config.values.file_previewer(opts)
end

local function force_preview_layout(opts)
  opts.layout_strategy = "vertical"
  opts.layout_config = vim.tbl_deep_extend("force", opts.layout_config or {}, {
    horizontal = { preview_cutoff = 0 },
    vertical = {
      mirror = true,
      preview_cutoff = 0,
      preview_height = 0.45,
      prompt_position = "top",
    },
    center = { preview_cutoff = 0 },
    cursor = { preview_cutoff = 0 },
    bottom_pane = { preview_cutoff = 0 },
  })
end

local function toggle_and_reopen(state_key, picker_name)
  return function(prompt_bufnr)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local api = vim.api

    -- Preserve current prompt text without Telescope's prompt prefix.
    local prompt_text = action_state.get_current_line() or ""
    local picker = action_state.get_current_picker(prompt_bufnr)
    if prompt_text == "" and picker and api.nvim_buf_is_valid(picker.prompt_bufnr) then
      local lines = api.nvim_buf_get_lines(picker.prompt_bufnr, 0, 1, false)
      if lines and #lines > 0 then
        prompt_text = lines[1]:gsub("^" .. vim.pesc(picker.prompt_prefix or ""), "")
      end
    end

    M.state[state_key] = not M.state[state_key]
    actions.close(prompt_bufnr)

    local opts = vim.tbl_extend("force", M._last_opts[picker_name] or {}, { default_text = prompt_text })
    M[picker_name](opts)
  end
end

local function attach_toggles(prompt_bufnr, map, picker_name)
  for _, mode in ipairs({ "i", "n" }) do
    map(mode, "<C-l>", toggle_and_reopen("path_full", picker_name), { desc = "Toggle full/short paths" })
    map(mode, "<C-o>", toggle_and_reopen("preview_visible", picker_name), { desc = "Toggle preview" })
  end
  return true
end

local function wrap_picker(picker_name)
  return function(opts)
    opts = vim.deepcopy(opts or {})
    M._last_opts[picker_name] = vim.deepcopy(opts)
    local custom_attach = opts.attach_mappings
    local base = get_opts()
    opts = vim.tbl_extend("force", base, opts)

    if M.state.preview_visible then
      opts.previewer = get_previewer(picker_name, opts)
      force_preview_layout(opts)
    end

    opts.attach_mappings = function(prompt_bufnr, map)
      attach_toggles(prompt_bufnr, map, picker_name)
      if custom_attach then
        custom_attach(prompt_bufnr, map)
      end
      return true
    end
    require("telescope.builtin")[picker_name](opts)
  end
end

M.find_files = wrap_picker("find_files")
M.live_grep = wrap_picker("live_grep")
M.buffers = wrap_picker("buffers")
M.oldfiles = wrap_picker("oldfiles")
M.grep_string = wrap_picker("grep_string")
M.current_buffer_fuzzy_find = wrap_picker("current_buffer_fuzzy_find")
M.help_tags = wrap_picker("help_tags")

return M
