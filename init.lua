local config_dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":p:h")
vim.g.quicksilver_config_dir = config_dir
vim.opt.rtp:prepend(config_dir)

-- Homebrew's configuration is immutable; keep plugin lock updates in user state.
local lockfile = config_dir .. "/lazy-lock.json"
if vim.env.QUICKSILVER_CONFIG_DIR then
  local version = vim.fn.readfile(config_dir .. "/VERSION")[1]
  local state_dir = vim.fn.stdpath("state") .. "/releases/" .. version
  vim.fn.mkdir(state_dir, "p")
  lockfile = state_dir .. "/lazy-lock.json"
  if vim.fn.filereadable(lockfile) == 0 then
    vim.fn.writefile(vim.fn.readfile(config_dir .. "/lazy-lock.json"), lockfile)
  end
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("quicksilver.options")
require("quicksilver.keymaps")
require("quicksilver.commands")

require("quicksilver.ui.topbar").setup()

require("lazy").setup({
  spec = { import = "plugins" },
  lockfile = lockfile,
  checker = { enabled = true, notify = false },
})
