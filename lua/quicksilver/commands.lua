vim.api.nvim_create_user_command("Q", "qa!", {})
vim.api.nvim_create_user_command("Reload", function()
  for _, file in ipairs({ "options.lua", "keymaps.lua" }) do
    local config_dir = vim.g.quicksilver_config_dir or vim.fn.stdpath("config")
    local path = config_dir .. "/lua/quicksilver/" .. file
    pcall(dofile, path)
  end
  require("lazy").sync({ wait = true })
  vim.notify("Sourced lua configs. Best to restart Neovim for full reload.", vim.log.levels.WARN)
end, {})

