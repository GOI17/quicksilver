# Design: integrated-terminal

## Overview

**Change**: integrated-terminal  
**Artifact Type**: Technical Design  
**Approach**: Enhance existing betterterm.nvim to replicate VS Code integrated terminal functionality

---

## Problem Statement

The current terminal setup has multiple issues:

1. **Missing toggle_opencode()** - telescope.lua line 57 calls `toggle_opencode()` but function is never defined
2. **No multi-terminal management** - No way to spawn, list, or rename terminals
3. **Broken lazy Usesgit integration** - raw `vim.cmd("tabnew | terminal lazygit")` instead of betterterm
4. **Missing keymaps** - No `<leader>tn` or `<leader>tl` for spawn/list
5. **No tabs support** - betterterm has `show_tabs = true` but no rename functionality

---

## Technical Approach

### Architecture Decision: Centralized Terminal Module

Create a new module `lua/quicksilver/terminal.lua` that wraps betterterm and provides:

1. **Public API** (26 functions matching test cases)
2. **Terminal registry** - Track all spawned terminals by name
3. **Unified toggle logic** - Handle open/close state
4. **Command sending** - Support skill picker integration

### Why NOT extend betterterm.lua directly?

- **Separation of concerns** - Config vs. API
- **Testability** - Easier to unit test standalone module
- **Maintainability** - Clear boundary between plugin config and business logic
- **Plugin-agnostic** - Could swap betterterm later without breaking API

---

## File Changes

### New Files

| File | Purpose |
|------|---------|
| `lua/quicksilver/terminal.lua` | Core terminal API (spawn, list, toggle, rename) |
| `lua/quicksilver/terminal/keymaps.lua` | Terminal-specific keymaps |
| `tests/terminal_spec.lua` | Busted tests for terminal module |

### Modified Files

| File | Changes |
|------|---------|
| `lua/plugins/betterterm.lua` | Add config for multiple terminals, keybindings for tabs |
| `lua/plugins/telescope.lua` | Fix toggle_opencode() → call terminal module |
| `lua/quicksilver/keymaps.lua` | Add `<leader>tn`, `<leader>tl` keymaps |
| `lua/plugins/lualine.lua` | Use terminal module for lazygit instead of vim.cmd |
| `README.md` | Document new keymaps and functions |

### Deleted Files

None.

---

## Interface Definitions

### Terminal Module API (`lua/quicksilver/terminal.lua`)

```lua
-- Core functions (required by TESTCASES_MULTITERMINAL.md)
M.spawn_terminal()           -- Prompt for name + command, create terminal
M.list_terminals()           -- Show vim.ui.select with all terminals
M.toggle_opencode_vertical() -- Existing: opencode in vertical split
M.toggle_shell_vertical()    -- Existing: shell in vertical split
M.toggle_shell_horizontal()  -- Existing: shell in horizontal split
M.toggle_shell_tab()         -- Existing: shell in new tab
M.toggle_opencode_tab()      -- Existing: opencode in new tab
M.opencode_skill_pick()      -- Send skill selection to opencode terminal

-- New multi-terminal functions
M.toggle(name)               -- Toggle terminal by name
M.send(name, command)        -- Send command to named terminal
M.rename(name, new_name)     -- Rename terminal
M.get_terminals()            -- Return list of registered terminals
M.close(name)                -- Close specific terminal

-- Backward compatibility wrapper
M.toggle_opencode()          -- Fix for telescope.lua line 57
```

### Configuration Options

```lua
-- In terminal.lua
local config = {
  default_shell = vim.o.shell,
  vertical_size = math.floor(vim.o.columns * 0.35),
  horizontal_size = 15,
  tab_position = "end",
}
```

---

## Key Architecture Decisions

### Decision 1: Terminal Registry Pattern

**Choice**: Store terminals in a module-level table with name as key

```lua
local terminals = {}  -- { [name] = { id, direction, command } }
```

**Pros**:
- O(1) lookup by name
- Simple state management
- Matches TESTCASES expectations

**Cons**:
- In-memory only (resets on Neovim restart)
- No persistence

**Selected**: In-memory registry (matches current betterterm behavior)

---

### Decision 2: Toggle Strategy

**Choice**: Check if terminal window exists, then toggle visibility

```lua
function M.toggle(name)
  local term = terminals[name]
  if not term then
    -- Create new terminal
    return
  end
  
  -- Check if window exists using betterterm API
  -- Toggle based on state
end
```

**Pros**:
- Reuses existing betterterm.toggle_termwindow()
- Matches VS Code behavior (show/hide)

**Cons**:
- Need to track window handles

---

### Decision 3: Lazygit Integration

**Choice**: Create named terminal "lazygit" instead of raw vim.cmd

```lua
function M.toggle_lazygit()
  M.spawn_with_name("lazygit", "lazygit")
end
```

**Pros**:
- Consistent with other terminals
- Toggleable from list_terminals()
- Uses betterterm instead of raw terminal

**Cons**:
- Need to configure lazygit path

**Selected**: Named terminal integration

---

## Implementation Plan

### Phase 1: Core Module (Day 1)

1. Create `lua/quicksilver/terminal.lua`
2. Implement spawn_terminal() with vim.ui.input
3. Implement list_terminals() with vim.ui.select
4. Implement toggle functions
5. Add toggle_opencode() fix for telescope

### Phase 2: Integration (Day 1-2)

1. Update `lua/plugins/betterterm.lua` to use terminal module
2. Add keymaps in `lua/quicksilver/keymaps.lua`
3. Fix lualine lazygit to use terminal module

### Phase 3: Multi-Terminal Features (Day 2)

1. Implement rename functionality
2. Add tab navigation keymaps
3. Implement send command to terminal

### Phase 4: Documentation (Day 2)

1. Update README.md
2. Verify against TESTCASES_MULTITERMINAL.md

---

## Testing Strategy

### Unit Tests (busted)

```
tests/terminal_spec.lua
```

| Test | Coverage |
|------|----------|
| spawn_terminal creates entry in registry | ✓ |
| list_terminals returns all registered | ✓ |
| toggle_opencode() is callable | ✓ |
| duplicate names overwrite | ✓ |
| special characters in names | ✓ |

### Integration Tests

Manual verification using TESTCASES_MULTITERMINAL.md:

```
26 test cases organized by:
- Spawn Terminal (5 tests)
- List Terminals (4 tests)
- Backward Compatibility (6 tests)
- Keymaps (2 tests)
- Edge Cases (7 tests)
- Integration (2 tests)
```

### Keymap Verification

```
<leader>tn  → spawn_terminal()
<leader>tl  → list_terminals()
<leader>to  → toggle_opencode() (existing)
```

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| betterterm API instability | Medium | Wrap in module, easy to swap |
| vim.ui.input blocking | Low | Expected behavior, same as VS Code |
| Terminal state not persisting | Low | Matches current behavior |
| Test case coverage gaps | Medium | Manual testing with provided test cases |

---

## Open Questions

1. **Q**: Should terminals persist across Neovim sessions?
   - **A**: Not in scope - matches current betterterm behavior

2. **Q**: How to handle terminal direction per terminal?
   - **A**: Store direction in registry, apply on toggle

3. **Q**: Should we support terminal directions (vertical/horizontal/tab) in spawn_terminal?
   - **A**: Yes, add optional direction parameter

4. **Q**: lazygit needs specific terminal configuration?
   - **A**: Use betterterm's built-in direction support

---

## Dependencies

- **CRAG666/betterTerm.nvim** - Already in config, version "*"
- **nvim-lua/plenary.nvim** - For vim.ui.select/input wrappers (if needed)
- **No new plugins required**

---

## Summary

- **Files**: 3 new, 4 modified, 0 deleted
- **Approach**: Create centralized terminal.lua module wrapping betterterm
- **Key Fix**: Define toggle_opencode() function for telescope.lua line 57
- **Testing**: 26 manual test cases + unit tests for core functions
- **Risk**: Low - incremental enhancement of existing functionality

---

## Next Step

Ready for task breakdown (sdd-tasks).
