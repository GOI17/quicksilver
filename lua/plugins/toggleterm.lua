return {
  "akinsho/toggleterm.nvim",
  version = "*",
  opts = {
    size = function(term)
      if term.direction == "horizontal" then
        return 15
      elseif term.direction == "vertical" then
        return math.floor(vim.o.columns * 0.35)
      end
      return 20
    end,
    open_mapping = nil,
    hide_numbers = true,
    shade_filetypes = {},
    shade_terminals = true,
    shading_factor = 2,
    start_in_insert = true,
    insert_mappings = true,
    persist_size = true,
    direction = "vertical",
    close_on_exit = true,
    shell = vim.o.shell,
    float_opts = {
      border = "curved",
      winblend = 0,
    },
  },
  config = function(_, opts)
    require("toggleterm").setup(opts)
    
    local Terminal = require("toggleterm.terminal").Terminal

    local opencode = Terminal:new({
      cmd = "opencode",
      hidden = true,
      direction = "vertical",
      on_open = function()
        vim.cmd("startinsert!")
      end,
    })

    function _G.toggle_opencode()
      opencode:toggle()
    end

    function _G.toggle_terminal_horizontal()
      opencode.direction = "horizontal"
      opencode:toggle()
    end

    function _G.toggle_terminal_vertical()
      opencode.direction = "vertical"
      opencode:toggle()
    end

    function _G.toggle_terminal_tab()
      opencode.direction = "tab"
      opencode:toggle()
    end

    function _G.toggle_terminal_float()
      opencode.direction = "float"
      opencode:toggle()
    end
  end,
}
