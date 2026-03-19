## ADDED Requirements

### Requirement: Go to definition keymap
The system SHALL provide a `gd` keymap that triggers `vim.lsp.buf.definition()` to navigate to the symbol definition.

#### Scenario: GD pressed with LSP server active
- **WHEN** user presses `gd` in normal mode with an LSP server attached
- **THEN** Neovim navigates to the definition of the symbol under cursor

#### Scenario: GD pressed without LSP server
- **WHEN** user presses `gd` without an active LSP server
- **THEN** Neovim displays an error message indicating no LSP server is available

### Requirement: Find all references keymap
The system SHALL provide a `gr` keymap that triggers `vim.lsp.buf.references()` to find all references to the symbol across the repository.

#### Scenario: GR pressed with LSP server active
- **WHEN** user presses `gr` in normal mode with an LSP server attached
- **THEN** Neovim displays a list of all references to the symbol under cursor

#### Scenario: GR pressed without LSP server
- **WHEN** user presses `gr` without an active LSP server
- **THEN** Neovim displays an error message indicating no LSP server is available

### Requirement: Go to file in open buffers keymap
The system SHALL provide a `gf` keymap that searches for files among currently open buffers instead of only files on disk.

#### Scenario: GF pressed with matching buffer open
- **WHEN** user presses `gf` on a filename that matches an open buffer
- **THEN** Neovim navigates to that buffer

#### Scenario: GF pressed with no matching buffer
- **WHEN** user presses `gf` on a filename with no matching open buffer
- **THEN** Neovim falls back to standard `gf` behavior (try to open file from disk)