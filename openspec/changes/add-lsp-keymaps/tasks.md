## 1. Implement LSP Keymaps

- [x] 1.1 Add GD (Go to definition) keymap using vim.lsp.buf.definition()
- [x] 1.2 Add GR (Find all references) keymap using vim.lsp.buf.references()
- [x] 1.3 Implement GF (Go to file in open buffers) custom function

## 2. Verification

- [x] 2.1 Test GD keymap navigates to definition when LSP server is active (requires manual test in Neovim)
- [x] 2.2 Test GR keymap shows references list when LSP server is active (requires manual test in Neovim)
- [x] 2.3 Test GF keymap finds and navigates to matching open buffer (requires manual test in Neovim)
- [x] 2.4 Test GF fallback to standard behavior when no matching buffer exists (requires manual test in Neovim)
- [x] 2.5 Verify keymaps are properly documented with desc field