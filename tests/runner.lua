-- Test runner that manually sets up the environment
-- Usage: nvim --headless -u tests/runner.lua +qa

-- Add lua/ to package.path using absolute path
local project_path = "/Users/josegilbertoolivasibarra/Documents/workspace/quicksilver"
package.path = string.format("%s/lua/?.lua;%s/lua/?/init.lua;%s",
  project_path, project_path, package.path)

-- Setup minimal plugin path for plenary
vim.opt.runtimepath:prepend(project_path)

-- Try to load plenary if available
local plenary_loaded = pcall(require, "plenary.busted")
if not plenary_loaded then
  -- Fallback: manual test runner
  print("Plenary not available, running manual tests...")
  
  -- Load test helpers
  dofile(project_path .. "/tests/init.lua")
  
  -- Load the modules we want to test
  require("quicksilver.options")
  require("quicksilver.keymaps")
  
  local helpers = _G.test_helpers
  
  -- Simple test runner
  local passed = 0
  local failed = 0
  
  local function test(name, fn)
    local ok, err = pcall(fn)
    if ok then
      print("  ✓ " .. name)
      passed = passed + 1
    else
      print("  ✗ " .. name .. ": " .. tostring(err))
      failed = failed + 1
    end
  end
  
  print("\n=== Running keymaps tests ===")
  
  test("mapleader should be space", function()
    assert(vim.g.mapleader == " ", "mapleader should be space")
  end)
  
  test("should have <Esc> mapped to nohlsearch", function()
    local km = helpers.find_keymap("n", "<Esc>")
    assert(km ~= nil, "keymap should exist")
    assert(km.rhs == "<Cmd>nohlsearch<CR>", "rhs should be nohlsearch")
  end)
  
  test("should have C-h for window left", function()
    -- Note: <C-h> maps to <C-w>h, stored as <C-H> in lhs
    local km = helpers.find_keymap("n", "<C-H>")
    assert(km ~= nil, "keymap should exist")
    assert(km.rhs == "<C-W>h", "should map to C-w>h")
  end)
  
  test("should have C-j for window down", function()
    local km = helpers.find_keymap("n", "<C-J>")
    assert(km ~= nil, "keymap should exist")
    assert(km.rhs == "<C-W>j", "should map to C-w>j")
  end)
  
  test("should have C-k for window up", function()
    local km = helpers.find_keymap("n", "<C-K>")
    assert(km ~= nil, "keymap should exist")
    assert(km.rhs == "<C-W>k", "should map to C-w>k")
  end)
  
  test("should have C-l for window right", function()
    local km = helpers.find_keymap("n", "<C-L>")
    assert(km ~= nil, "keymap should exist")
    assert(km.rhs == "<C-W>l", "should map to C-w>l")
  end)
  
  test("should have leader w for save (expanded)", function()
    -- <leader>w expands to " w" (space + w)
    local km = helpers.find_keymap("n", " w")
    assert(km ~= nil, "keymap should exist")
  end)
  
  test("should have leader q for quit (expanded)", function()
    -- <leader>q expands to " q"
    local km = helpers.find_keymap("n", " q")
    assert(km ~= nil, "keymap should exist")
  end)
  
  test("should have C-w>v for vertical split", function()
    -- Note: stored as <C-W>v with capital W
    local km = helpers.find_keymap("n", "<C-W>v")
    assert(km ~= nil, "keymap should exist")
  end)
  
  test("should have C-w>h for horizontal split", function()
    local km = helpers.find_keymap("n", "<C-W>h")
    assert(km ~= nil, "keymap should exist")
  end)
  
  test("should have C-. for action helper", function()
    local key = "<C-.>"
    assert(helpers.find_keymap("n", key) ~= nil)
  end)
  
  test("should have gg for lazygit", function()
    local km = helpers.find_keymap("n", "gg")
    assert(km ~= nil, "keymap should exist")
    assert(km.desc == "Open LazyGit", "should have correct description")
  end)
  
  print("\n=== Running options tests ===")
  
  test("number should be true", function()
    assert(vim.opt.number:get() == true)
  end)
  
  test("relativenumber should be true", function()
    assert(vim.opt.relativenumber:get() == true)
  end)
  
  test("expandtab should be true", function()
    assert(vim.opt.expandtab:get() == true)
  end)
  
  test("shiftwidth should be 2", function()
    assert(vim.opt.shiftwidth:get() == 2)
  end)
  
  test("tabstop should be 2", function()
    assert(vim.opt.tabstop:get() == 2)
  end)
  
  test("smartindent should be true", function()
    assert(vim.opt.smartindent:get() == true)
  end)
  
  test("wrap should be false", function()
    assert(vim.opt.wrap:get() == false)
  end)
  
  test("ignorecase should be true", function()
    assert(vim.opt.ignorecase:get() == true)
  end)
  
  test("smartcase should be true", function()
    assert(vim.opt.smartcase:get() == true)
  end)
  
  test("cursorline should be true", function()
    assert(vim.opt.cursorline:get() == true)
  end)
  
  test("termguicolors should be true", function()
    assert(vim.opt.termguicolors:get() == true)
  end)
  
  test("timeoutlen should be 300", function()
    assert(vim.opt.timeoutlen:get() == 300)
  end)
  
  test("updatetime should be 200", function()
    assert(vim.opt.updatetime:get() == 200)
  end)
  
  test("undofile should be true", function()
    assert(vim.opt.undofile:get() == true)
  end)
  
  test("autoread should be true", function()
    assert(vim.opt.autoread:get() == true)
  end)
  
  -- Clipboard might not be testable in headless mode
  print("\n  (skipping clipboard test - requires clipboard tool)")
  
  print(string.format("\n=== Results: %d passed, %d failed ===", passed, failed))
  
  if failed > 0 then
    vim.cmd("cq 1")  -- Exit with error code
  end
else
  -- Plenary is available, use it
  require("plenary.busted")
end
