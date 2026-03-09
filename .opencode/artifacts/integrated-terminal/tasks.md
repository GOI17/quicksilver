# Tasks: integrated-terminal

## Phase 1: Foundation (Infrastructure / Setup)

- [ ] 1.1 Create `lua/quicksilver/terminal.lua` with module structure and terminal registry
- [ ] 1.2 Define `local terminals = {}` registry table with name-keyed entries
- [ ] 1.3 Define default configuration (default_shell, vertical_size, horizontal_size, tab_position)
- [ ] 1.4 Set up module exports and M namespace

## Phase 2: Core Implementation (Main API)

- [ ] 2.1 Implement `M.spawn_terminal()` - prompt for name + command via vim.ui.input, create terminal
- [ ] 2.2 Implement `M.list_terminals()` - vim.ui.select with all terminals, toggle on selection
- [ ] 2.3 Implement `M.toggle(name)` - toggle terminal visibility by name
- [ ] 2.4 Implement `M.send(name, command)` - send command to named terminal
- [ ] 2.5 Implement `M.rename(name, new_name)` - rename terminal in registry
- [ ] 2.6 Implement `M.get_terminals()` - return list of registered terminals
- [ ] 2.7 Implement `M.close(name)` - close specific terminal
- [ ] 2.8 Implement `M.toggle_opencode_vertical()` - existing opencode vertical split
- [ ] 2.9 Implement `M.toggle_shell_vertical()` - existing shell vertical split
- [ ] 2.10 Implement `M.toggle_shell_horizontal()` - existing shell horizontal split
- [ ] 2.11 Implement `M.toggle_shell_tab()` - existing shell in new tab
- [ ] 2.12 Implement `M.toggle_opencode_tab()` - opencode in new tab
- [ ] 2.13 Implement `M.opencode_skill_pick()` - send skill selection to opencode terminal

## Phase 3: Keymaps & UX (User Experience)

- [ ] 3.1 Create `lua/quicksilver/terminal/keymaps.lua` for terminal-specific keymaps
- [ ] 3.2 Add `<leader>tn` - spawn_terminal() mapping in terminal/keymaps.lua
- [ ] 3.3 Add `<leader>tl` - list_terminals() mapping in terminal/keymaps.lua
- [ ] 3.4 Add `<leader>to` - toggle_opencode() (existing) mapping
- [ ] 3.5 Add `<leader>tv` - toggle_shell_vertical() mapping
- [ ] 3.6 Add `<leader>th` - toggle_shell_horizontal() mapping
- [ ] 3.7 Add `<leader>tt` - toggle_shell_tab() mapping
- [ ] 3.8 Add `<leader>tg` - toggle_lazygit() mapping
- [ ] 3.9 Expose advanced keymaps in `lua/quicksilver/keymaps.lua`

## Phase 4: Integration Fixes (Bug Fixes)

- [ ] 4.1 Fix `toggle_opencode()` in `lua/plugins/telescope.lua` line 57 - call terminal module
- [ ] 4.2 Fix lazygit integration in `lua/plugins/lualine.lua` - use terminal module instead of vim.cmd
- [ ] 4.3 Enhance `lua/plugins/betterterm.lua` configuration - enable show_tabs, new_tab_mapping
- [ ] 4.4 Add tab navigation keymaps in betterterm config
- [ ] 4.5 Add insert mode keymaps for terminal cycling

## Phase 5: Testing & Verification

- [ ] 5.1 Create `tests/terminal_spec.lua` - busted tests for terminal module
- [ ] 5.2 Test spawn_terminal creates entry in registry
- [ ] 5.3 Test list_terminals returns all registered terminals
- [ ] 5.4 Test toggle_opencode() is callable
- [ ] 5.5 Test duplicate names overwrite gracefully
- [ ] 5.6 Test special characters in terminal names
- [ ] 5.7 Test empty terminal list shows notification
- [ ] 5.8 Test toggle_opencode from telescope commands picker

## Phase 6: Documentation

- [ ] 6.1 Fix README.md terminal section to match implementation
- [ ] 6.2 Document all new keymaps in README
- [ ] 6.3 Verify no phantom features in documentation
- [ ] 6.4 Update any references to TESTCASES_MULTITERMINAL.md
