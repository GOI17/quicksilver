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
      extend_relatedInformation = true,
      max_width = 0.6,
      max_height = 0.4,
    },
    lightbulb = {
      enable = false,
    },
  },
  config = function(_, opts)
    require("lspsaga").setup(opts)

    local severity = vim.diagnostic.severity

    vim.diagnostic.config({
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = true,
      virtual_text = {
        spacing = 2,
        source = "if_many",
        format = function(diagnostic)
          if diagnostic.severity == severity.ERROR then
            return string.format(" %s", diagnostic.message)
          elseif diagnostic.severity == severity.WARN then
            return string.format(" %s", diagnostic.message)
          end
          return diagnostic.message
        end,
      },
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
