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
    new_tab_mapping = "<C-t>",
  },
  config = function(_, opts)
    local betterterm = require("betterTerm")
    betterterm.setup(opts)

    vim.keymap.set("n", "<C-\\>", function ()
      betterterm.open()
    end , { desc = "Toggle terminal (shell)" })
    vim.keymap.set({"n", "t"}, "<C-h>", function ()
      betterterm.toggle_termwindow()
    end, { desc = "Toggle betterterm visibility" })
    vim.keymap.set("n", "<leader>ts", function ()
      betterterm.open()
    end , { desc = "Toggle terminal (shell)" })
    vim.keymap.set("n", "<leader>to", function()
      betterterm.send("opencode", nil, nil)
    end, { desc = "Opencode terminal" })
    vim.keymap.set("t", "<C-u>", function() betterterm.cycle(1) end, { desc = "Cycle terminals to the right" })
    vim.keymap.set("t", "<C-y>", function() betterterm.cycle(-1) end, { desc = "Cycle terminals to the left" })
    vim.keymap.set("t", "<C-d>", function ()
      -- betterterm.send
    end, { desc = "Close active terminal" })
  end,
}
