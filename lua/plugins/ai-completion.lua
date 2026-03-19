--- AI Completion Plugin Specification
-- Configured through lazy.nvim with conditional loading based on provider availability

return {
  {
    "tzachar/cmp-ai",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    -- Load cmp-ai when entering insert mode
    event = "InsertEnter",
    -- Only load if AI providers are available
    cond = function()
      local ai_config = require("quicksilver.ai-config")
      return ai_config.get_active_provider() ~= nil
    end,
    config = function()
      local ai_config = require("quicksilver.ai-config")
      local cmp = require("cmp")
      
      -- Configure cmp-ai based on active provider
      local active_provider = ai_config.get_active_provider()
      if active_provider == nil then
        return
      end
      
      local provider_config = ai_config.get_provider_config(active_provider)
      local notification_config = ai_config.get_notification_config()
      
      -- Base cmp-ai configuration
      local cmp_ai_config = {
        max_lines = provider_config.max_lines,
        notify = notification_config.on_start and notification_config.on_complete,
        -- Additional provider-specific configuration will be set below
      }
      
      if active_provider == "ollama" then
        cmp_ai_config.ext_config = {
          [provider_config.host] = {
            provider = "ollama",
            model = provider_config.model,
            timeout = provider_config.timeout,
          }
        }
      elseif active_provider == "openai" then
        cmp_ai_config.ext_config = {
          ["https://api.openai.com/v1/chat/completions"] = {
            provider = "openai",
            model = provider_config.model,
            api_key = provider_config.api_key,
          }
        }
      end
      
      -- Apply the configuration
      require("cmp_ai").setup(cmp_ai_config)
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    -- Only load if Copilot token is available
    cond = function()
      local ai_config = require("quicksilver.ai-config")
      return ai_config.is_copilot_available()
    end,
    config = function()
      local ai_config = require("quicksilver.ai-config")
      local notification_config = ai_config.get_notification_config()
      
      require("copilot").setup({
        suggestion = {
          enabled = false, -- Disable built-in suggestion, we use cmp source
          auto_trigger = false,
          debounce = 75,
        },
        panel = {
          enabled = false, -- Disable built-in panel, we use cmp source
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false, -- Disable for all other filetypes and let cmp handle
        },
        copilot_node_command = vim.fn.exepath("node") or "node", -- Use system node
        suggestion = {
          enabled = not vim.g.ai_completion_disable_suggestions or false, -- Can be overridden
          auto_trigger = false,
          hide_during_completion = true,
          debounce = 75,
        },
        panel = {
          enabled = false,
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = {
      "zbirenbaum/copilot.lua",
    },
    -- Only load if Copilot is available
    cond = function()
      local ai_config = require("quicksilver.ai-config")
      return ai_config.is_copilot_available()
    end,
    config = function()
      -- Bridge copilot.lua with nvim-cmp
      require("copilot_cmp").setup()
    end,
  },
}