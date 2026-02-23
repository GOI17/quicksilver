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
- **Terminal Integration** - ToggleTerm with opencode CLI support
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
| `<C-t>t` | Toggle terminal |
| `<leader>t` | Toggle opencode terminal |
| `<leader>th` | Terminal horizontal (bottom) |
| `<leader>tv` | Terminal vertical (right) |
| `<C-t>h` | Focus left window |
| `<C-t>l` | Focus right window |

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
- [toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Terminal
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

---

<p align="center">
  Made with ❤️ by <a href="https://github.com/GOI17">GOI17</a>
</p>
