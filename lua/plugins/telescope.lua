return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  version = false,
  keys = {
    { "ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live grep" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help tags" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent files" },
    { "<leader>rc", "<cmd>Commands<cr>", desc = "Run commands" },
  },
  opts = {},
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values

    local commands_list = {
      { desc = "Rename file", action = function() vim.cmd("Rename ") end },
      { desc = "Move file", action = function() vim.cmd("Move ") end },
      { desc = "Format selection", action = function() vim.lsp.buf.format({ range = vim.api.nvim_buf_get_marked(0, "<", ">") }) end },
      { desc = "Format buffer", action = function() vim.lsp.buf.format() end },
      { desc = "Open terminal", action = function() toggle_opencode() end },
    }

    local function run_command(prompt_bufnr)
      local selection = actions.state.get_selected_entry(prompt_bufnr)
      actions.close(prompt_bufnr)
      if selection then
        selection.value.action()
      end
    end

    local ext = telescope.register_extension({
      exports = {
        commands = function(opts)
          opts = opts or {}
          pickers.new(opts, {
            prompt_title = "Commands",
            finder = finders.new_table({
              results = commands_list,
              entry_maker = function(entry)
                return {
                  value = entry,
                  display = entry.desc,
                  ordinal = entry.desc,
                }
              end,
            }),
            sorter = conf.generic_sorter(opts),
            attach_mappings = function(_, map)
              map("i", "<CR>", run_command)
              map("n", "<CR>", run_command)
              return true
            end,
          }):find()
        end,
      },
    })

    vim.api.nvim_create_user_command("Commands", function()
      ext.exports.commands()
    end, {})
  end,
}
