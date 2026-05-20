# Delta for Terminal

## Purpose

This delta spec describes changes to enhance betterterm.nvim to fully replicate VS Code's integrated terminal experience, adding multi-terminal support, proper lazygit integration, and exposing advanced terminal features through keymaps.

## ADDED Requirements

### Requirement: Multi-Terminal Support

The system MUST support creating, listing, and switching between multiple terminal instances.

#### Scenario: Create Named Terminal

- GIVEN Neovim is running with betterterm configured
- WHEN user calls `spawn_terminal()` with a name and optional command
- THEN a new terminal instance opens with the specified name
- AND the terminal runs the given command (or default shell if none provided)

#### Scenario: List All Terminals

- GIVEN multiple terminal instances exist
- WHEN user calls `list_terminals()` or presses `<leader>tl`
- THEN a vim.ui.select dropdown shows all registered terminals
- AND selecting a terminal toggles its visibility

#### Scenario: Toggle Terminal Visibility

- GIVEN a terminal instance exists (open or closed)
- WHEN user selects the terminal from the list
- THEN if closed: terminal opens in appropriate split/tab
- AND if open: terminal closes

### Requirement: Terminal Naming

The system SHOULD allow users to rename terminal instances.

#### Scenario: Rename Terminal via betterterm UI

- GIVEN a terminal is open and active
- WHEN user triggers rename action (e.g., via betterterm's built-in rename)
- THEN terminal name updates in the tab bar
- AND the renamed terminal remains accessible via list_terminals()

### Requirement: Send Commands to Terminal

The system SHOULD allow sending commands or lines from normal mode to an active terminal.

#### Scenario: Send Current Line to Terminal

- GIVEN a terminal is open in a split
- WHEN user is on a line with a command in normal mode
- AND user invokes send-to-terminal action
- THEN the current line is sent to the terminal buffer
- AND terminal executes the command

#### Scenario: Send Visual Selection to Terminal

- GIVEN a terminal is open in a split
- WHEN user visually selects lines and invokes send-to-terminal
- THEN the selected text is sent to the terminal buffer
- AND each line is executed as a separate command

### Requirement: LazyGit Integration

The system SHOULD integrate lazygit via betterterm instead of raw vim.cmd.

#### Scenario: Open LazyGit from Lualine

- GIVEN lualine is displaying the statusline
- WHEN user clicks on the branch component
- THEN lazygit opens in a betterterm terminal instance
- AND user is placed in insert mode in the terminal

#### Scenario: Open LazyGit via Keymap

- GIVEN Neovim is running
- WHEN user presses `gg` (defined in keymaps.lua)
- THEN lazygit opens in a new terminal tab via betterterm
- AND user is placed in insert mode

### Requirement: Broken toggle_opencode() Fix

The system MUST provide a working `toggle_opencode()` function accessible from telescope commands and other contexts.

#### Scenario: Call toggle_opencode from Telescope Commands

- GIVEN telescope commands picker is open
- WHEN user selects "Open terminal" action
- THEN the terminal opens successfully (no error)
- AND user is in insert mode in the terminal

## MODIFIED Requirements

### Requirement: betterterm Configuration

The betterterm plugin configuration MUST expose all VS Code-like terminal features.

(Previously: basic configuration with minimal features enabled)

- GIVEN betterterm is loaded
- WHEN configuration is applied
- THEN the following features MUST be enabled:
  - Tab display (`show_tabs = true`)
  - New tab mapping (`new_tab_mapping = "<C-t>"`)
  - Insert mode on open (`start_inserted = true`)
  - Terminal cycling keymaps in terminal mode

### Requirement: Advanced Terminal Keymaps

The system SHOULD expose advanced terminal keymaps for power users.

(Previously: only basic toggle keymaps existed in betterterm.lua)

- GIVEN Neovim is running
- WHEN user presses leader-based terminal keymaps
- THEN the following actions MUST be available:
  - `<leader>tn` - spawn new terminal (if implemented)
  - `<leader>tl` - list terminals
  - `<leader>to` - send to opencode terminal (already exists in betterterm.lua)

### Requirement: Telescope Command Integration

The telescope commands picker MUST have a working terminal toggle action.

(Previously: `toggle_opencode()` was called but function was not defined, causing errors)

- GIVEN telescope is loaded
- WHEN the Commands picker shows "Open terminal" option
- AND user selects it
- THEN terminal opens without errors
- AND previous errors like "attempt to call global 'toggle_opencode' (a nil value)" MUST NOT occur

### Requirement: Lualine LazyGit Integration

The lualine branch click handler SHOULD use betterterm for lazygit integration.

(Previously: used raw `vim.cmd("tabnew | terminal lazygit")`)

- GIVEN lualine is displaying the statusline
- WHEN user clicks the branch component
- THEN lazygit opens in a betterterm-managed terminal
- AND proper terminal lifecycle is maintained

## REMOVED Requirements

### Requirement: Broken toggle_opencode Call

The broken reference to `toggle_opencode()` in telescope.lua commands list MUST be fixed or removed.

(Reason: function was never defined, causing runtime errors when "Open terminal" command was selected)

#### Scenario: Verify No Errors on Terminal Command

- GIVEN telescope commands picker is open
- WHEN user selects "Open terminal"
- THEN no error message about undefined function appears
- AND terminal opens successfully

### Requirement: Inconsistent README Documentation

README.md terminal section MUST accurately reflect actual implementation.

(Reason: README contained inconsistencies between documented and actual behavior)

#### Scenario: README Matches Implementation

- GIVEN user reads README.md terminal section
- WHEN they compare with actual keymaps and commands
- THEN all documented features work as described
- AND no phantom features are mentioned that don't exist

## Edge Cases

### Scenario: Empty Terminal List

- GIVEN no terminals have been created
- WHEN user calls `list_terminals()`
- THEN an info notification appears: "No terminals registered"
- AND no crash or exception occurs

### Scenario: Duplicate Terminal Names

- GIVEN a terminal named "test" exists
- WHEN user creates another terminal named "test"
- THEN the new terminal replaces the old one
- AND list_terminals shows only the new "test"

### Scenario: Special Characters in Terminal Names

- GIVEN user creates terminal with name containing `@`, spaces, or unicode
- WHEN list_terminals displays the name
- THEN the name displays correctly without corruption
- AND terminal remains functional

### Scenario: Toggle Closed Terminal

- GIVEN a terminal exists but is not currently visible
- WHEN user toggles that terminal
- THEN it opens in the appropriate split/position
- AND user is placed in insert mode

### Scenario: Toggle Open Terminal

- GIVEN a terminal is currently visible
- WHEN user toggles that same terminal
- THEN the terminal closes
- AND the split/window is removed

## Error States

### Scenario: Toggle Opencode When Betterterm Not Loaded

- GIVEN betterterm plugin failed to load
- WHEN user attempts to toggle terminal
- THEN a warning notification appears
- AND no crash occurs

### Scenario: Send Command to Nonexistent Terminal

- GIVEN no terminal with the specified name exists
- WHEN user attempts to send command to that terminal
- THEN an info/warning notification indicates terminal not found
- AND no crash occurs
