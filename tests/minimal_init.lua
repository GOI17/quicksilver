-- Minimal init for running tests
-- Uses absolute path to the project

-- Add lua/ to package.path using absolute path
local project_path = "/Users/josegilbertoolivasibarra/Documents/workspace/quicksilver"
package.path = string.format("%s/lua/?.lua;%s/lua/?/init.lua;%s",
  project_path, project_path, package.path)

-- Load core modules (these are what we want to test)
require("quicksilver.options")
require("quicksilver.keymaps")
