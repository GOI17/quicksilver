return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  version = false,
  keys = require("quicksilver.telescope.keymaps").get_global_telescope_keymaps(),
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = {
        horizontal = {
          width = 0.9,
          height = 0.8,
          preview_width = 0.6,
        },
      },
      path_display = { "shorten" },
      previewer = false,
    },
    pickers = {
      commands = {
        attach_mappings = function(prompt_bufnr)
          require("quicksilver.telescope.hints").attach(prompt_bufnr, { picker = "commands" })
          return true
        end,
      },
    },
  },
}
