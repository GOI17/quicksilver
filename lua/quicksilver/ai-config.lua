--- AI Configuration Module
-- Handles environment variable-based configuration for AI completion providers
-- Provides safe reading of env vars, provider availability detection, and fallback logic

local M = {}

-- Default configuration values
M.DEFAULT_OLLAMA_MODEL = "codellama"
M.DEFAULT_OPENAI_MODEL = "gpt-4o-mini"
M.DEFAULT_MAX_COMPLETION_LINES = 100
M.OLLAMA_TIMEOUT = 30000 -- 30 seconds

-- Notification configuration (can be overridden by env vars)
M.NOTIFY_ON_START = true
M.NOTIFY_ON_COMPLETE = true

-- Completion trigger configuration
M.TRIGGER_ON_KEYSTROKE = false -- Use <C-x> for on-demand completion

--- Safely get environment variable with fallback
-- @param name string Environment variable name
-- @param default any Default value if variable not set
-- @return string|number|boolean Value of env var or default
function M.get_env_var(name, default)
  local value = vim.env[name]
  if value == nil or value == "" then
    return default
  end
  return value
end

--- Check if Ollama provider is available and configured
-- @return boolean True if Ollama host is set
function M.is_ollama_available()
  return M.get_env_var("OLLAMA_HOST") ~= nil
end

--- Check if OpenAI provider is available and configured
-- @return boolean True if OpenAI API key is set
function M.is_openai_available()
  return M.get_env_var("OPENAI_API_KEY") ~= nil
end

--- Check if Copilot provider is available and configured
-- @return boolean True if Copilot token is set
function M.is_copilot_available()
  return M.get_env_var("GITHUB_COPILOT_TOKEN") ~= nil
end

--- Get the active provider based on fallback priority
-- Priority: Ollama → OpenAI → Copilot → nil (none)
-- @return string|null Provider name or nil if none available
function M.get_active_provider()
  if M.is_ollama_available() then
    return "ollama"
  elseif M.is_openai_available() then
    return "openai"
  elseif M.is_copilot_available() then
    return "copilot"
  else
    return nil
  end
end

--- Get configuration for a specific provider
-- @param provider string Provider name ("ollama", "openai", "copilot")
-- @return table Provider-specific configuration
function M.get_provider_config(provider)
  if provider == "ollama" then
    return {
      host = M.get_env_var("OLLAMA_HOST", "http://localhost:11434"),
      model = M.get_env_var("OLLAMA_MODEL", M.DEFAULT_OLLAMA_MODEL),
      timeout = M.OLLAMA_TIMEOUT,
      max_lines = tonumber(M.get_env_var("MAX_COMPLETION_LINES", tostring(M.DEFAULT_MAX_COMPLETION_LINES))) or M.DEFAULT_MAX_COMPLETION_LINES
    }
  elseif provider == "openai" then
    return {
      api_key = M.get_env_var("OPENAI_API_KEY"),
      model = M.get_env_var("OPENAI_MODEL", M.DEFAULT_OPENAI_MODEL),
      max_lines = tonumber(M.get_env_var("MAX_COMPLETION_LINES", tostring(M.DEFAULT_MAX_COMPLETION_LINES))) or M.DEFAULT_MAX_COMPLETION_LINES
    }
  elseif provider == "copilot" then
    return {
      token = M.get_env_var("GITHUB_COPILOT_TOKEN"),
      max_lines = tonumber(M.get_env_var("MAX_COMPLETION_LINES", tostring(M.DEFAULT_MAX_COMPLETION_LINES))) or M.DEFAULT_MAX_COMPLETION_LINES
    }
  else
    return {}
  end
end

--- Get completion trigger mode
-- @return boolean True if should trigger on keystroke, false for on-demand
function M.get_trigger_mode()
  local trigger_env = M.get_env_var("AI_COMPLETION_TRIGGER")
  if trigger_env ~= nil then
    return trigger_env == "true" or trigger_env == "1"
  end
  return M.TRIGGER_ON_KEYSTROKE
end

--- Get notification settings
-- @return table Notification configuration
function M.get_notification_config()
  local notify_start = M.get_env_var("NOTIFY_ON_START")
  local notify_complete = M.get_env_var("NOTIFY_ON_COMPLETE")
  
  return {
    on_start = notify_start == nil and M.NOTIFY_ON_START or (notify_start == "true" or notify_start == "1"),
    on_complete = notify_complete == nil and M.NOTIFY_ON_COMPLETE or (notify_complete == "true" or notify_complete == "1")
  }
end

return M