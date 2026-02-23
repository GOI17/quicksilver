# AGENTS.md - Quicksilver Neovim Configuration

This file provides guidelines for AI agents working on the Quicksilver Neovim configuration.

## Project Overview

Quicksilver is a personal Neovim configuration built on the lazy.nvim plugin manager. It uses Lua for configuration files and follows Neovim best practices.

## Build/Test Commands

This is a Neovim configuration project. Testing is done by:

```bash
# Validate Lua syntax
nvim --headless -c "lua dofile('init.lua')" -c "q" 2>&1

# Check for Lua syntax errors in all files
find lua -name "*.lua" -exec luac -p {} \;

# Open Neovim with this config to test
NVIM_APPNAME=quicksilver nvim
```

## Code Style Guidelines

### Lua Style

- Use 2-space indentation (no tabs)
- Use double quotes for strings
- Prefer single quotes for table keys when appropriate
- Keep lines under 100 characters when possible

### Imports and Requires

- Place `require` statements at the top of files
- Use local variables for required modules
- Group related requires together

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
require("lazy").setup({ ... })
```

### Naming Conventions

- Use `snake_case` for variables and functions
- Use `PascalCase` for module returns (plugin specs)
- Use `UPPER_CASE` for constants
- Prefix global functions with `_G.` when needed

### Plugin Structure

Each plugin is a separate file in `lua/plugins/` that returns a table:

```lua
return {
  "author/plugin-name",
  opts = { ... },
  config = function(_, opts)
    require("plugin").setup(opts)
  end,
}
```

### Keymaps

- Define all keymaps in `lua/quicksilver/keymaps.lua`
- Use `vim.keymap.set()` with descriptive `desc` fields
- Use `<leader>` prefix for custom commands
- Map leader to space: `vim.g.mapleader = " "`

### Options

- Set options in `lua/quicksilver/options.lua`
- Use `vim.opt` for setting options
- Use `vim.g` for global variables

### Error Handling

- Use `pcall()` for potentially failing operations
- Check for plugin existence before requiring

```lua
local ok, module = pcall(require, "module")
if not ok then
  vim.notify("Failed to load module", vim.log.levels.ERROR)
  return
end
```

### Terminal Integration

- Uses `toggleterm.nvim` for terminal management
- Custom functions prefixed with `_G.` for global access
- Terminal directions: vertical, horizontal, float, tab

### LSP Configuration

- Uses `vim.lsp.config` (Neovim 0.11+)
- Language servers installed via mason.nvim
- Diagnostics shown inline with lspsaga.nvim

## File Organization

```
.
├── .luarc.json            # Lua LSP configuration
├── AGENTS.md              # This file
├── init.lua               # Entry point, bootstraps lazy.nvim
├── lazy-lock.json         # Plugin version lock file
└── lua/
    ├── quicksilver/
    │   ├── icons.lua      # Completion kind icons
    │   ├── options.lua    # Neovim options
    │   └── keymaps.lua    # Key mappings
    └── plugins/
        ├── cmp.lua         # Autocompletion
        ├── kanagawa.lua   # Theme
        ├── lspsaga.lua     # LSP diagnostics (error lens)
        ├── lspconfig.lua   # LSP configuration
        ├── luasnip.lua     # Snippets
        ├── oil.lua         # File explorer
        ├── telescope.lua   # Fuzzy finder
        ├── toggleterm.lua  # Terminal management
        └── which-key.lua   # Keybinding helper
```

## Keybindings

### General

- `<Esc>` - Clear search highlight
- `qw` (insert/visual) - Exit to normal mode
- `<C-h/j/k/l>` - Navigate windows
- `<C-w>F` - Find file and open in vertical split
- `<C-w>s` - Find file and open in horizontal split
- `<C-w>z` - Maximize/restore current pane
- `<leader>w` - Save file
- `<leader>q` - Quit

### Terminal

- `<C-t>t` - Toggle terminal
- `<leader>t` - Toggle opencode terminal
- `<leader>th` - Terminal horizontal (bottom)
- `<leader>tv` - Terminal vertical (right)
- `<leader>tf` - Terminal floating
- `<leader>tt` - Terminal tab
- `<C-t>h` - Focus left window
- `<C-t>l` - Focus right window

### Telescope (Fuzzy Finder)

- `ff` - Find files
- `<leader>ff` - Find files
- `<leader>fb` - Buffers
- `<leader>fg` - Live grep
- `<leader>fh` - Help tags
- `<leader>fr` - Recent files
- `<leader>rc` - Commands picker

### Oil (File Explorer)

- `<leader>e` - Open oil file explorer

## Commands

- `:Q` - Force quit Neovim
- `:Reload` - Sync plugins and reload
- `:Commands` - Open custom commands picker

## Common Tasks

- Add plugin: Create new file in `lua/plugins/`
- Add keymap: Edit `lua/quicksilver/keymaps.lua`
- Change options: Edit `lua/quicksilver/options.lua`

## Notes

- Lazy.nvim handles plugin loading automatically
- Plugins are lazy-loaded by default
- Use `event = "VeryLazy"` for plugins that don't need immediate loading
- LSP uses `vim.lsp.config` not `lspconfig` (Neovim 0.11+)
