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

    local shell_term = Terminal:new({
      cmd = vim.o.shell,
      hidden = true,
      direction = "vertical",
      on_open = function()
        vim.cmd("startinsert!")
      end,
    })

    function _G.toggle_opencode_vertical()
      opencode.direction = "vertical"
      opencode:toggle()
    end

    function _G.toggle_opencode_tab()
      opencode.direction = "tab"
      opencode:toggle()
    end

    function _G.toggle_shell_vertical()
      shell_term.direction = "vertical"
      shell_term:toggle()
    end

    function _G.toggle_shell_horizontal()
      shell_term.direction = "horizontal"
      shell_term:toggle()
    end

    function _G.toggle_shell_tab()
      shell_term.direction = "tab"
      shell_term:toggle()
    end
  end,
}
