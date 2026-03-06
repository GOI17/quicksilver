-- Test bootstrap and helper functions
-- Standalone helpers without external dependencies

-- Add lua/ to package.path for requiring quicksilver modules
local project_path = "/Users/josegilbertoolivasibarra/Documents/workspace/quicksilver"
package.path = string.format("%s/lua/?.lua;%s/lua/?/init.lua;%s",
  project_path, project_path, package.path)

-- Helper: Get all registered keymaps for a given mode
---@param mode string Mode short-name (e.g., "n", "i", "v")
---@return table Array of keymap objects
local function get_keymaps(mode)
  local keymaps = vim.api.nvim_get_keymap(mode)
  local result = {}
  for _, km in ipairs(keymaps) do
    table.insert(result, {
      lhs = km.lhs,
      rhs = km.rhs or "",
      mode = km.mode,
      desc = km.desc or "",
      noremap = km.noremap == 1 or km.noremap == true,
      silent = km.silent == 1 or km.silent == true,
      buffer = km.buffer,
    })
  end
  return result
end

-- Helper: Find a keymap by its lhs (key sequence)
---@param mode string
---@param lhs string
---@return table|nil The keymap object or nil if not found
local function find_keymap(mode, lhs)
  local keymaps = get_keymaps(mode)
  for _, km in ipairs(keymaps) do
    if km.lhs == lhs then
      return km
    end
  end
  return nil
end

-- Helper: Check if a vim option has expected value
---@param option string Option name (e.g., "number", "expandtab")
---@param expected any Expected value
---@return boolean, any Returns true if matches, actual value if not
local function opt_matches(option, expected)
  local actual = vim.opt[option]:get()
  if type(expected) ~= type(actual) then
    return false, actual
  end
  if type(actual) == "boolean" then
    return actual == expected, actual
  elseif type(actual) == "number" then
    return actual == expected, actual
  elseif type(actual) == "string" then
    return actual == expected, actual
  elseif type(actual) == "table" then
    -- Handle list-style options (arrays)
    if #actual == 0 and #expected == 0 then
      return true, actual
    end
    for i, v in ipairs(expected) do
      if actual[i] ~= v then
        return false, actual
      end
    end
    return true, actual
  end
  return false, actual
end

-- Export helpers globally for test files
_G.test_helpers = {
  get_keymaps = get_keymaps,
  find_keymap = find_keymap,
  opt_matches = opt_matches,
}
