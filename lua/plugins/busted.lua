-- Test configuration using plenary.nvim and busted
-- This file is loaded only in test mode

-- Configure busted as the test runner
vim.env.TEST_TIMEOUT = 10000

-- Minimal plugin spec for testing
return {
  {
    "nvim-lua/plenary.nvim",
    lazy = true,
  },
  {
    "olimorris/busted.nvim",
    ft = { "lua" },
    cmd = { "Busted" },
    config = function()
      require("busted").setup({
        verbose = true,
        minimize_all = true,
        -- Compile Lua files before running tests
        compile = false,
      })
    end,
  },
}
