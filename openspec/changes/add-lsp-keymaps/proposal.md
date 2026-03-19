## Why

Los keymaps LSPson esenciales para navegación y análisis de código en Neovim. Actualmente faltangozar de estos atajos, lo que obliga a usar comandos manuales o plugins externos para funcionalidades básicas de LSP como goto definition y find references.

## What Changes

- Agregar keymap `gd` para **Go to definition** (vim.lsp.buf.definition)
- Agregar keymap `gr` para **Find all references across repo** (vim.lsp.buf.references)
- Agregar keymap `gf` para **Find all open buffer** (similar a gf pero para buffers abiertos)

## Capabilities

### New Capabilities

- `lsp-keymaps`: Conjunto de keybindings para navegación LSP
  - `gd` - Go to definition
  - `gr` - Find all references (repo-wide)
  - `gf` - Go to file (buffers abiertos)

### Modified Capabilities

- Ninguno. Esta es una funcionalidad nueva.

## Impact

- **Archivos afectados**:
  - `lua/quicksilver/keymaps.lua` - Agregar nuevos keymaps
- **Dependencias**: Requiere que LSP esté habilitado en Neovim
- **Interoperabilidad**: Los keymaps funcionarán solo cuando un servidor LSP esté activo