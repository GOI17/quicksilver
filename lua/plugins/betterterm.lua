local default_size = math.floor(vim.o.lines * 0.25)
local size = default_size
local position = "bot"

return {
  "CRAG666/betterTerm.nvim",
  version = "*",
  lazy = false,
  opts = {
    position = position,
    size = size,
    start_inserted = true,
    show_tabs = true,
    index_base = 0,
    new_tab_mapping = "<C-n>",
    predefined = {},
  },
}
