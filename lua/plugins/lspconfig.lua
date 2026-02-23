return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  opts = {
    servers = {
      "lua_ls",
      "ts_ls",
      "marksman",
      "bashls",
      "dockerls",
      "html",
      "cssls",
      "emmet_language_server",
      "jsonls",
    },
  },
  config = function(_, opts)
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = opts.servers,
    })

    for _, server in ipairs(opts.servers) do
      vim.lsp.config(server, {})
    end

    vim.lsp.enable(opts.servers)
  end,
}
