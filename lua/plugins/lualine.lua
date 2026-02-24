return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
    local function branch_click()
      local term_ok, term = pcall(require, "toggleterm.terminal")
      if not term_ok or type(term) ~= "table" or type(term.Terminal) ~= "table" then
        vim.notify("toggleterm not available", vim.log.levels.WARN)
        return
      end
      local Terminal = term.Terminal

      local lazygit = Terminal:new({
        cmd = "lazygit",
        hidden = true,
        direction = "float",
        close_on_exit = true,
      })

      lazygit:toggle()
    end

    local function diagnostics_click()
      local ok, diagnostic_show = pcall(require, "lspsaga.diagnostic.show")
      if not ok or type(diagnostic_show) ~= "table" or type(diagnostic_show.show_diagnostics) ~= "function" then
        vim.notify("lspsaga diagnostics not available", vim.log.levels.WARN)
        return
      end

      diagnostic_show:show_diagnostics({
        buffer = true,
        args = { "++float" },
      })
    end

    local function treesitter_lang()
      local ok, ts_utils = pcall(require, "nvim-treesitter.parsers")
      if not ok then
        return vim.bo.filetype
      end
      local lang = ts_utils.get_buf_lang()
      return lang or vim.bo.filetype or "text"
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn" },
      symbols = { error = " ", warn = " " },
      colored = true,
      update_in_insert = false,
      always_visible = true,
      on_click = diagnostics_click,
      on_click_opts = {
        name = "LspsagaDiagnostics",
        minwid = 0,
      },
    }

    local branch = {
      "branch",
      on_click = branch_click,
    }

    local mode = {
      "mode",
      fmt = function(str)
        return str
      end,
    }

    local filetype = {
      treesitter_lang,
      icon_only = false,
    }

    return {
      options = {
        theme = "auto",
        globalstatus = true,
        section_separators = "",
        component_separators = "",
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch },
        lualine_c = { "filename" },
        lualine_x = { diagnostics },
        lualine_y = { filetype },
        lualine_z = { "location" },
      },
    }
  end,
}
