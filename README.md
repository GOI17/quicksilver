<img src="https://raw.githubusercontent.com/nicehash/Resources/master/nicenode/nicenode-1.png" align="right" height="150">

# Quicksilver

> A minimal, fast Neovim configuration built for developers

<p align="center">
  <img src="https://img.shields.io/badge/Neovim-0.11+-blueviolet?style=flat-square&logo=neovim" alt="Neovim">
  <img src="https://img.shields.io/badge/Lua-LuaJIT-blue?style=flat-square&logo=lua">
  <img src="https://img.shields.io/github/license/GOI17/quicksilver?style=flat-square">
  <img src="https://img.shields.io/github/stars/GOI17/quicksilver?style=flat-square">
</p>

## Features

- **Fast & Minimal** - Lightweight config with only essential plugins
- **LSP Support** - Built-in language server support via mason.nvim + nvim-lspconfig
- **Fuzzy Finding** - Telescope integration for fast file search
- **Terminal Integration** - betterTerm with opencode CLI support
- **File Explorer** - Oil.nvim for modern file navigation
- **Autocomplete** - nvim-cmp with LSP snippets
- **Inline Diagnostics** - lspsaga for VSCode-like error display
- **Beautiful Theme** - Kanagawa color scheme

## Keybindings

### General

| Key | Action |
|-----|--------|
| `Esc` | Clear search highlight |
| `qw` | Exit insert/visual mode |
| `<C-h/j/k/l>` | Navigate windows |
| `<leader>w` | Save file |
| `<leader>q` | Quit |
| `<C-w>z` | Maximize/restore pane |

### Terminal

| Key | Action |
|-----|--------|
| `<leader>tn` | Spawn new terminal |
| `<leader>tl` | List all terminals |
| `<leader>to` | Toggle opencode terminal (vertical) |
| `<leader>tv` | Toggle shell vertical |
| `<leader>th` | Toggle shell horizontal |
| `<leader>tt` | Toggle shell in new tab |
| `<leader>tg` | Toggle LazyGit |
| `<space>gg` | Open LazyGit (alternative) |
| `<C-t>` | Toggle betterterm visibility |
| `<C-t>n` | New terminal tab (betterterm) |
| `<C-u>` | Cycle terminals right (in terminal) |
| `<C-y>` | Cycle terminals left (in terminal) |
| `<C-d>` | Close terminal (in terminal) |

### Telescope

| Key | Action |
|-----|--------|
| `ff` | Find files |
| `<leader>fb` | Buffers |
| `<leader>fg` | Live grep |
| `<leader>fh` | Help tags |
| `<leader>fr` | Recent files |
| `<leader>rc` | Commands picker |
| `<C-w>F` | Find & open in vertical split |
| `<C-w>s` | Find & open in horizontal split |

### VSCode Style (macOS Cmd)

| Key | Action |
|-----|--------|
| `<D>p` | Find files (Cmd+P) |
| `<D-S>p` | Commands picker (Cmd+Shift+P) |

### File Explorer

| Key | Action |
|-----|--------|
| `<leader>e` | Open Oil file explorer |

## Installation

```bash
# Clone the repository
git clone https://github.com/GOI17/quicksilver.git ~/Documents/workspace/quicksilver

# Run setup
cd ~/Documents/workspace/quicksilver
./setup.sh

# Start Neovim
quicksilver

# Install language servers
:Mason
```

## Requirements

- Neovim 0.11+
- Git
- ripgrep (for live grep)
- Optional: node, python, rust, go for LSP support

## Plugins

- [lazy.nvim](https://github.com/folke/lazy.nvim) - Plugin manager
- [oil.nvim](https://github.com/stevearc/oil.nvim) - File explorer
- [betterTerm](https://github.com/NTBBloodbath/better-term) - Terminal
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Autocompletion
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - LSP
- [mason.nvim](https://github.com/williamboman/mason.nvim) - LSP installer
- [lspsaga.nvim](https://github.com/nvimdev/lspsaga.nvim) - LSP UI
- [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) - Theme
- [which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding hints
- [LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippets

## License

MIT License - See [LICENSE](LICENSE) for details.

## Testing

This project uses [busted](https://github.com/nvim-neotest/busted) for testing Neovim Lua code.

### Run Tests

```bash
# From within Neovim
:PlenaryBustedDirectory tests/ {minimal_init = 'tests/minimal_init.lua'}

# Or using busted directly
busted tests/
```

### Test Structure

- `tests/` - Test files following `*_spec.lua` naming convention
- `tests/minimal_init.lua` - Minimal Neovim init for headless testing
- `tests/init.lua` - Test helpers and utilities

### Adding Tests

1. Create a new file in `tests/` with `_spec.lua` suffix
2. Follow the pattern of existing tests:

```lua
describe("module_name", function()
  before_each(function()
    package.loaded["quicksilver.module_name"] = nil
  end)

  it("should do something", function()
    require("quicksilver.module_name")
    -- assertions here
  end)
end)
```

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/GOI17">GOI17</a>
</p>
