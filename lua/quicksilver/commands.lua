vim.api.nvim_create_user_command("Q", "qa!", {})
vim.api.nvim_create_user_command("Reload", function()
  for _, file in ipairs({ "options.lua", "keymaps.lua" }) do
    local path = vim.fn.stdpath("config") .. "/lua/quicksilver/" .. file
    pcall(dofile, path)
  end
  require("lazy").sync({ wait = true })
  vim.notify("Sourced lua configs. Best to restart Neovim for full reload.", vim.log.levels.WARN)
end, {})

