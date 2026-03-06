-- Tests for keymaps.lua
-- Run with: :Busted

describe("keymaps.lua", function()
  local helpers

  before_each(function()
    -- Reload the keymaps module for each test
    package.loaded["quicksilver.keymaps"] = nil
    
    -- Load helpers
    helpers = _G.test_helpers
  end)

  describe("leader key", function()
    it("should set mapleader to space", function()
      -- Load keymaps
      require("quicksilver.keymaps")
      
      assert.equals(" ", vim.g.mapleader)
    end)
  end)

  describe("basic navigation keymaps", function()
    before_each(function()
      package.loaded["quicksilver.keymaps"] = nil
      require("quicksilver.keymaps")
    end)

    it("should have <Esc> mapped to nohlsearch in normal mode", function()
      local km = helpers.find_keymap("n", "<Esc>")
      assert.is_not_nil(km)
      assert.matches("nohlsearch", km.rhs)
    end)

    it("should have window navigation keymaps (C-h/j/k/l)", function()
      assert.is_not_nil(helpers.find_keymap("n", "<C-h>"))
      assert.is_not_nil(helpers.find_keymap("n", "<C-j>"))
      assert.is_not_nil(helpers.find_keymap("n", "<C-k>"))
      assert.is_not_nil(helpers.find_keymap("n", "<C-l>"))
    end)

    it("should have leader keymaps for save and quit", function()
      local save_km = helpers.find_keymap("n", "<leader>w")
      local quit_km = helpers.find_keymap("n", "<leader>q")
      
      assert.is_not_nil(save_km)
      assert.is_not_nil(quit_km)
      assert.matches("w", save_km.rhs)
      assert.matches("q", quit_km.rhs)
    end)
  end)

  describe("window management keymaps", function()
    before_each(function()
      package.loaded["quicksilver.keymaps"] = nil
      require("quicksilver.keymaps")
    end)

    it("should have vertical split keymap C-w>v", function()
      local km = helpers.find_keymap("n", "<C-w>v")
      assert.is_not_nil(km)
      assert.is_true(km.noremap)
    end)

    it("should have horizontal split keymap C-w>h", function()
      local km = helpers.find_keymap("n", "<C-w>h")
      assert.is_not_nil(km)
      assert.is_true(km.noremap)
    end)

    it("should have maximize/restore keymap C-w>z", function()
      local km = helpers.find_keymap("n", "<C-w>z")
      assert.is_not_nil(km)
    end)
  end)

  describe("user commands", function()
    before_each(function()
      package.loaded["quicksilver.keymaps"] = nil
      require("quicksilver.keymaps")
    end)

    it("should register Q command", function()
      local ok, cmd = pcall(vim.api.nvim_get_commands, "Q", {})
      assert.is_true(ok)
      assert.equals("qa!", cmd.definition)
    end)

    it("should register Reload command", function()
      local ok, cmd = pcall(vim.api.nvim_get_commands, "Reload", {})
      assert.is_true(ok)
      assert.is_function(cmd.callback)
    end)
  end)

  describe("visual mode keymaps", function()
    before_each(function()
      package.loaded["quicksilver.keymaps"] = nil
      require("quicksilver.keymaps")
    end)

    it("should have indent keymaps in visual mode", function()
      local decrease = helpers.find_keymap("v", "<")
      local increase = helpers.find_keymap("v", ">")
      
      assert.is_not_nil(decrease)
      assert.is_not_nil(increase)
      assert.matches("gv", decrease.rhs)
      assert.matches("gv", increase.rhs)
    end)

    it("should have qw to exit in insert and visual mode", function()
      local insert_qw = helpers.find_keymap("i", "qw")
      local visual_qw = helpers.find_keymap("v", "qw")
      
      assert.is_not_nil(insert_qw)
      assert.is_not_nil(visual_qw)
    end)
  end)

  describe("telescope keymaps", function()
    before_each(function()
      package.loaded["quicksilver.keymaps"] = nil
      require("quicksilver.keymaps")
    end)

    it("should have leader fa for grep string", function()
      local km = helpers.find_keymap("n", "<leader>fa")
      assert.is_not_nil(km)
    end)

    it("should have leader fF for current buffer fuzzy find", function()
      local km = helpers.find_keymap("n", "<leader>fF")
      assert.is_not_nil(km)
    end)

    it("should have C-. for action helper", function()
      local km = helpers.find_keymap("n", "<C-.>")
      assert.is_not_nil(km)
      assert.is_true(km.noremap)
    end)
  end)
end)
