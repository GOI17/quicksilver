-- Tests for terminal.lua
-- Run with: :Busted

describe("terminal.lua", function()
  local terminal

  before_each(function()
    -- Reset terminal module state
    package.loaded["quicksilver.terminal"] = nil
    terminal = require("quicksilver.terminal")
  end)

  describe("terminal registry", function()
    it("should have empty registry initially", function()
      local terminals = terminal.get_terminals()
      assert.is_table(terminals)
      assert.equals(0, #terminals)
    end)
  end)

  describe("get_terminals()", function()
    it("should return list of registered terminals", function()
      local list = terminal.get_terminals()
      assert.is_table(list)
    end)
  end)

  describe("toggle_opencode()", function()
    it("should be callable without errors", function()
      -- Just verify the function exists and is callable
      assert.is_function(terminal.toggle_opencode)
    end)
  end)

  describe("API functions exist", function()
    it("should have spawn_terminal function", function()
      assert.is_function(terminal.spawn_terminal)
    end)

    it("should have list_terminals function", function()
      assert.is_function(terminal.list_terminals)
    end)

    it("should have toggle function", function()
      assert.is_function(terminal.toggle)
    end)

    it("should have send function", function()
      assert.is_function(terminal.send)
    end)

    it("should have rename function", function()
      assert.is_function(terminal.rename)
    end)

    it("should have close function", function()
      assert.is_function(terminal.close)
    end)

    it("should have toggle_opencode_vertical function", function()
      assert.is_function(terminal.toggle_opencode_vertical)
    end)

    it("should have toggle_shell_vertical function", function()
      assert.is_function(terminal.toggle_shell_vertical)
    end)

    it("should have toggle_shell_horizontal function", function()
      assert.is_function(terminal.toggle_shell_horizontal)
    end)

    it("should have toggle_shell_tab function", function()
      assert.is_function(terminal.toggle_shell_tab)
    end)

    it("should have toggle_opencode_tab function", function()
      assert.is_function(terminal.toggle_opencode_tab)
    end)

    it("should have opencode_skill_pick function", function()
      assert.is_function(terminal.opencode_skill_pick)
    end)

    it("should have open_lazygit function", function()
      assert.is_function(terminal.open_lazygit)
    end)

    it("should have get_terminal function", function()
      assert.is_function(terminal.get_terminal)
    end)
  end)
end)
