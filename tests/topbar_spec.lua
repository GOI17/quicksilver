-- Focused regression test for topbar WinLeave cleanup.
-- Run standalone with:
-- nvim --headless -u NONE -c "set rtp+=." -c "lua package.path='./lua/?.lua;./lua/?/init.lua;' .. package.path; dofile('tests/topbar_spec.lua')" -c qa

local topbar_winbar = "%@v:lua.require('quicksilver.ui.topbar').open_telescope@Search files%*"
local topbar_autocmd_descs = {
  ["Set topbar winbar"] = true,
  ["Clear topbar winbar on leave"] = true,
}

local function cleanup_topbar_autocmds()
  local seen = {}

  for _, event in ipairs({ "BufEnter", "WinEnter", "WinLeave" }) do
    for _, autocmd in ipairs(vim.api.nvim_get_autocmds({ event = event })) do
      if autocmd.desc and topbar_autocmd_descs[autocmd.desc] and not seen[autocmd.id] then
        seen[autocmd.id] = true
        pcall(vim.api.nvim_del_autocmd, autocmd.id)
      end
    end
  end
end

local function setup_topbar()
  cleanup_topbar_autocmds()
  package.loaded["quicksilver.ui.topbar"] = nil
  require("quicksilver.ui.topbar").setup()
end

local function exec_winleave()
  vim.api.nvim_exec_autocmds("WinLeave", { modeline = false })
end

local function test_preserves_non_topbar_winbar()
  setup_topbar()

  local terminal_tabs_winbar = "%#BetterTermTab# term 1 | term 2"
  vim.wo.winbar = terminal_tabs_winbar

  exec_winleave()

  assert(
    vim.wo.winbar == terminal_tabs_winbar,
    "topbar WinLeave must not clear plugin-managed winbars"
  )
end

local function test_clears_topbar_winbar()
  setup_topbar()

  vim.wo.winbar = topbar_winbar
  exec_winleave()

  assert(vim.wo.winbar ~= topbar_winbar, "topbar WinLeave should clear its own winbar")
end

local function reset_window()
  vim.wo.winbar = nil
  cleanup_topbar_autocmds()
end

if type(describe) == "function" then
  describe("quicksilver.ui.topbar", function()
    after_each(reset_window)

    it("does not clear non-topbar winbars on WinLeave", test_preserves_non_topbar_winbar)
    it("clears its own winbar on WinLeave", test_clears_topbar_winbar)
  end)
else
  local tests = {
    test_preserves_non_topbar_winbar,
    test_clears_topbar_winbar,
  }

  for _, test in ipairs(tests) do
    local ok, err = pcall(test)
    reset_window()

    if not ok then
      error(err, 0)
    end
  end

  print("topbar_spec.lua: 2 passed")
end
