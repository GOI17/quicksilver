return {
  "rebelot/kanagawa.nvim",
  opts = {
    theme = "wave",
    background = {
      dark = "wave",
      light = "lotus",
    },
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd("colorscheme kanagawa")
  end,
}
