## Context

El proyecto Quicksilver es una configuración de Neovim en Lua. Actualmente existe un `action_helper` (C-.) que incluye opciones de LSP como "Go to definition" y "Find references", pero son accesibles solo a través de un menú de selección. El usuario quiere atajos directos de teclado para estas funcionalidades.

## Goals / Non-Goals

**Goals:**
- Agregar keymap directo `gd` para Go to definition
- Agregar keymap directo `gr` para Find all references (repo-wide)
- Agregar keymap `gf` para Find all open buffer (archivos abiertos en buffers)

**Non-Goals:**
- No modificar el action_helper existente (C-.)
- No agregar nuevas funcionalidades LSP más allá de los 3 keymaps especificados
- No agregar testing en esta iteración (el proyecto no tiene tests para keymaps)

## Decisions

1. **Usar `vim.lsp.buf.definition()` para `gd`**
   - Alternativa: `vim.lsp.buf.definition()` vs `lua vim.lsp.buf.definition()`
   - Decision: Función nativa de Neovim, no requiere preparación

2. **Usar `vim.lsp.buf.references()` para `gr`**
   - Alternativa: References local vs repo-wide
   - Decision: Por defecto `vim.lsp.buf.references()` incluye todas las referencias en el workspace
   - El parámetro `context` permite filtrar por scope

3. **Implementar `gf` para buffers abiertos**
   - Decision: Crear una función que filtre primero los buffers visibles/open antes de ejecutar el comportamiento de gf tradicional
   - El comportamiento de `gf` nativo solo funciona para archivos en disco, no para buffers ya abiertos

## Risks / Trade-offs

- **Riesgo**: Los keymaps LSP fallarán silenciosamente si no hay servidor LSP activo
  - Mitigación: Neovim mostrará un mensaje de error automático del LSP
- **Trade-off**: `gr` puede mostrar demasiadas referencias en proyectos grandes
  - Mitigación: El usuario puede usar telescopio para filtrar después
- **Riesgo**: `gf` para buffers podría tener naming conflicts
  - Mitigación: Implementar fuzzy matching o mostrar selector si hay múltiples matches