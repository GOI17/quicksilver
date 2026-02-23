return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  opts = {
    ui = {
      border = "rounded",
      code_action = "💡",
      diagnostic = "🐛",
      incoming = "📥",
      outgoing = "📤",
    },
    diagnostic = {
      show_code_actions = true,
      show_layout = "float",
    },
    lightbulb = {
      enable = false,
    },
  },
  config = function(_, opts)
    require("lspsaga").setup(opts)

    vim.diagnostic.config({
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}
