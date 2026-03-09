-- Tests for options.lua
-- Run with: :Busted

describe("options.lua", function()
  local helpers

  before_each(function()
    -- Reset options to defaults before each test
    vim.opt.number = false
    vim.opt.relativenumber = false
    vim.opt.expandtab = false
    vim.opt.shiftwidth = 8
    vim.opt.tabstop = 8
    vim.opt.smartindent = false
    vim.opt.wrap = true
    vim.opt.ignorecase = false
    vim.opt.smartcase = false
    vim.opt.cursorline = false
    vim.opt.termguicolors = false
    vim.opt.timeoutlen = 1000
    vim.opt.updatetime = 4000
    vim.opt.undofile = false
    vim.opt.autoread = false
    vim.opt.clipboard = ""
    
    -- Reload the options module
    package.loaded["quicksilver.options"] = nil
    
    -- Load helpers
    helpers = _G.test_helpers
  end)

  describe("editor behavior options", function()
    it("should enable line numbers", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.number:get())
    end)

    it("should enable relative line numbers", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.relativenumber:get())
    end)

    it("should enable expandtab (use spaces instead of tabs)", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.expandtab:get())
    end)

    it("should set shiftwidth to 2", function()
      require("quicksilver.options")
      assert.equals(2, vim.opt.shiftwidth:get())
    end)

    it("should set tabstop to 2", function()
      require("quicksilver.options")
      assert.equals(2, vim.opt.tabstop:get())
    end)

    it("should enable smartindent", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.smartindent:get())
    end)

    it("should disable wrap (no line wrapping)", function()
      require("quicksilver.options")
      assert.is_false(vim.opt.wrap:get())
    end)
  end)

  describe("search options", function()
    it("should enable ignorecase", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.ignorecase:get())
    end)

    it("should enable smartcase", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.smartcase:get())
    end)
  end)

  describe("UI options", function()
    it("should enable cursorline", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.cursorline:get())
    end)

    it("should enable termguicolors", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.termguicolors:get())
    end)

    it("should set timeoutlen to 300ms", function()
      require("quicksilver.options")
      assert.equals(300, vim.opt.timeoutlen:get())
    end)

    it("should set updatetime to 200ms", function()
      require("quicksilver.options")
      assert.equals(200, vim.opt.updatetime:get())
    end)
  end)

  describe("file options", function()
    it("should enable undofile", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.undofile:get())
    end)

    it("should enable autoread", function()
      require("quicksilver.options")
      assert.is_true(vim.opt.autoread:get())
    end)

    it("should set clipboard to unnamedplus", function()
      require("quicksilver.options")
      assert.equals("unnamedplus", vim.opt.clipboard:get())
    end)

    it("should append I to shortmess to hide intro", function()
      require("quicksilver.options")
      local shortmess = vim.opt.shortmess:get()
      assert.is_true(vim.tbl_contains(shortmess, "I"))
    end)
  end)

  describe("autocommands", function()
    it("should create autocommand for checktime on focus events", function()
      require("quicksilver.options")
      
      local autocmds = vim.api.nvim_get_autocmds({
        event = { "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" },
      })
      
      assert.is_true(#autocmds > 0)
      
      local has_checktime = false
      for _, autocmd in ipairs(autocmds) do
        if autocmd.command == "checktime" then
          has_checktime = true
          break
        end
      end
      assert.is_true(has_checktime)
    end)
  end)
end)
