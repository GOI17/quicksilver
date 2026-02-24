vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.timeoutlen = 300
vim.opt.updatetime = 200
vim.opt.undofile = true
vim.opt.autoread = true
vim.opt.shortmess:append("I")

vim.opt.clipboard = "unnamedplus"

vim.cmd("autocmd BufRead * setlocal wrap tabstop=2")
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  command = "checktime",
})
