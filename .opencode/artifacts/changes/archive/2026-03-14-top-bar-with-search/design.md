# Technical Design: top-bar-with-search

## Overview

This document defines the technical design for implementing the top bar with search functionality, based on the proposal and specifications previously created.

---

## 1. Architecture Overview

### 1.1 Component Diagram

```
┌─────────────────────────────────────────────────────────┐
│                      Neovim UI                          │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────┐   │
│  │              Winbar (top bar)                   │   │
│  │  [Left Content]  [Search files input]  [Right]  │   │
│  │                                                 │   │
│  │  Background: #363646                           │   │
│  │  Input Border: #16161D                         │   │
│  │  Input Background: #1a1a22                     │   │
│  └─────────────────────────────────────────────────┘   │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────────────────────────────────┐   │
│  │              Main Buffer Area                   │   │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
         │
         │ click event
         ▼
┌─────────────────────────────────────────────────────────┐
│  lua/quicksilver/ui/topbar.lua                         │
│  ┌─────────────────────────────────────────────────┐   │
│  │  on_click_search() → telescope.builtin.find_files │
│  └─────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

### 1.2 Module Structure

```
lua/quicksilver/
├── ui/                          # NEW: UI components directory
│   └── topbar.lua              # NEW: Main topbar module
├── options.lua                 # MODIFIED: Add g:topbar_visible
├── keymaps.lua                 # (existing)
└── terminal/
    └── winbar.lua              # (existing - reference pattern)

init.lua                        # MODIFIED: require topbar module
```

---

## 2. Design Decisions

### 2.1 Winbar vs Custom Implementation

**Decision:** Use **native Neovim winbar** (`vim.wo.winbar`)

| Option | Pros | Cons |
|--------|------|------|
| Native winbar (CHOSEN) | Built-in support, click events work, auto-refresh | Requires Neovim 0.10+ |
| Custom render (rejected) | Full control | Complexity, no native click support, manual rendering |

**Rationale:** The existing project already uses native winbar in `lua/quicksilver/terminal/winbar.lua`. The pattern is proven. Neovim 0.11 (the project's minimum version) fully supports winbar with click events.

### 2.2 Visibility Storage

**Decision:** Use **global variable** `vim.g.topbar_visible`

| Option | Pros | Cons |
|--------|------|------|
| `vim.g.topbar_visible` (CHOSEN) | Simple, persists across sessions, matches vim convention | Global namespace pollution |
| `vim.t.topbar_visible` | Tab-scoped, cleaner | Doesn't persist across sessions |
| `vim.b.topbar_visible` | Buffer-scoped | Doesn't make sense for global toggle |
| `vim.opt` | Standard Neovim option | More boilerplate |

**Rationale:** The spec explicitly requires `g:topbar_visible`. Simple global variable is the most straightforward implementation and matches vim conventions.

**Default:** `vim.g.topbar_visible = true`

### 2.3 Click Handler Implementation

**Decision:** Use **winbar `%@` syntax** with direct Lua function call

```lua
-- Winbar format string
"%@lua:require('quicksilver.ui.topbar').on_click()%Search files%"
```

| Option | Pros | Cons |
|--------|------|------|
| `%@lua:require(...)%` (CHOSEN) | Direct Lua execution, no command overhead | String escaping complexity |
| `vim.cmd` callback | Familiar pattern | Extra vim.cmd overhead |
| `vim.api.nvim_buf_set_var` | N/A | Not applicable to winbar |

**Rationale:** This is the established pattern in the existing `terminal/winbar.lua`. It allows direct function execution from the clickable element.

### 2.4 Telescope Trigger

**Decision:** Use **lazy.nvim loading** with manual telescope require

```lua
function M.on_click()
  -- Force lazy.nvim to load telescope
  require("lazy").load({ plugins = { "telescope.nvim" } })
  require("telescope.builtin").find_files()
end
```

| Option | Pros | Cons |
|--------|------|------|
| `lazy.load()` (CHOSEN) | Works with existing lazy.nvim setup, simple | Slight delay on first click |
| `pcall(require, "telescope")` | Direct require | May fail if telescope not available |
| Pre-configure telescope commands | Faster | More setup complexity |

**Rationale:** The spec requires lazy loading to work. Using `lazy.load()` with the plugin name ensures telescope is loaded before requiring it. This matches how other lazy.nvim plugins should work.

---

## 3. Module Design

### 3.1 Topbar Module API

```lua
-- lua/quicksilver/ui/topbar.lua

local M = {}

-- ============================================================================
-- Configuration
-- ============================================================================

---Default configuration
---@type table
local config = {
  visible = true,
  placeholder = "Search files",
  -- Colors (hex values from spec)
  colors = {
    bar_bg = "#363646",
    input_border = "#16161D",
    input_bg = "#1a1a22",
  },
}

-- ============================================================================
-- Highlight Groups
-- ============================================================================

---Setup highlight groups for topbar
local function setup_highlights()
  -- WinBar highlight (bar background)
  vim.api.nvim_set_hl(0, "WinBar", {
    bg = config.colors.bar_bg,
    fg = "#ffffff",
  })
  
  -- WinBarSep highlights (centering markers)
  vim.api.nvim_set_hl(0, "WinBarSepLeft", {
    bg = config.colors.bar_bg,
    fg = config.colors.bar_bg,
  })
  vim.api.nvim_set_hl(0, "WinBarSepRight", {
    bg = config.colors.bar_bg,
    fg = config.colors.bar_bg,
  })
  
  -- Search input highlights
  vim.api.nvim_set_hl(0, "TopBarSearchBg", {
    bg = config.colors.input_bg,
    fg = "#ffffff",
  })
  vim.api.nvim_set_hl(0, "TopBarSearchBorder", {
    bg = config.colors.input_bg,
    fg = config.colors.input_border,
  })
end

-- ============================================================================
-- Visibility Control
-- ============================================================================

---Check if topbar should be visible
---@return boolean
local function is_visible()
  if vim.g.topbar_visible == false then
    return false
  end
  return true
end

-- ============================================================================
-- Click Handler
-- ============================================================================

---Handle click on search input - open Telescope
function M.on_click()
  -- Ensure telescope is loaded (lazy loading support)
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    -- Try forcing lazy load
    require("lazy").load({ plugins = { "telescope.nvim" } })
    telescope = require("telescope")
  end
  
  local builtin = require("telescope.builtin")
  builtin.find_files()
end

-- ============================================================================
-- Winbar Generation
-- ============================================================================

---Generate the winbar string
---@return string|nil
function M.get_winbar()
  -- Check visibility
  if not is_visible() then
    return nil
  end
  
  -- Build clickable search input
  -- Using %@ to make it clickable, calling on_click function
  local click_cmd = "lua require('quicksilver.ui.topbar').on_click()"
  local placeholder = config.placeholder
  
  -- Winbar with centered search input
  -- Format: left_sep + clickable_element + right_sep (centered via =)
  local winbar = string.format(
    "%%#WinBarSepLeft#%%=%%@%s%%%s%%#WinBarSepRight#%%",
    click_cmd,
    placeholder
  )
  
  return winbar
end

-- ============================================================================
-- Autocmd Setup
-- ============================================================================

---Setup autocmds to manage winbar
function M.setup()
  -- Ensure highlights are defined
  setup_highlights()
  
  -- Initialize global if not set
  if vim.g.topbar_visible == nil then
    vim.g.topbar_visible = true
  end
  
  -- Set winbar on buffer enter
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
    callback = function(args)
      local win = vim.api.nvim_get_current_win()
      vim.wo[win].winbar = M.get_winbar()
    end,
    desc = "Set topbar winbar",
  })
  
  -- Clear winbar when leaving window (if hidden)
  vim.api.nvim_create_autocmd({ "BufLeave", "WinLeave" }, {
    callback = function(args)
      if not is_visible() then
        local win = vim.api.nvim_get_current_win()
        vim.wo[win].winbar = nil
      end
    end,
    desc = "Clear topbar winbar when hidden",
  })
  
  -- Watch for visibility changes
  vim.api.nvim_create_autocmd({ "OptionSet" }, {
    pattern = "topbar_visible",
    callback function()
      -- Refresh all windows
      vim.cmd("redrawstatus")
    end,
    desc = "Refresh topbar on visibility change",
  })
end

return M
```

### 3.2 Options Module Modification

```lua
-- lua/quicksilver/options.lua additions

-- Existing options...
-- [lines 1-23]

-- ============================================================================
-- Topbar Configuration
-- ============================================================================

-- Topbar visibility (default: true)
vim.g.topbar_visible = vim.g.topbar_visible ~= false
```

### 3.3 Init.lua Modification

```lua
-- init.lua additions

-- After existing requires (line 14-15)
require("quicksilver.options")
require("quicksilver.keymaps")

-- NEW: Require topbar module
require("quicksilver.ui.topbar").setup()

require("lazy").setup({
  -- ... existing config
})
```

---

## 4. File Changes Summary

### 4.1 New Files

| File | Description |
|------|-------------|
| `lua/quicksilver/ui/topbar.lua` | Main topbar module with winbar generation, click handler, and autocmds |

### 4.2 Modified Files

| File | Changes |
|------|---------|
| `lua/quicksilver/options.lua` | Add `vim.g.topbar_visible` default initialization |
| `init.lua` | Add `require("quicksilver.ui.topbar").setup()` after options/keymaps |

### 4.3 No Changes Required

| File | Reason |
|------|--------|
| `lua/plugins/telescope.lua` | Already has `find_files` mapped to `ff`, no changes needed |
| `lua/quicksilver/terminal/winbar.lua` | Independent from new topbar, no conflict |

---

## 5. Implementation Sequence

### Phase 1: Core Module (Priority: High)
1. Create `lua/quicksilver/ui/` directory
2. Implement `topbar.lua` with basic winbar display
3. Add autocmds for winbar management

### Phase 2: Visibility Toggle (Priority: High)
1. Add `vim.g.topbar_visible` check in get_winbar()
2. Add visibility toggle in options.lua
3. Add OptionSet autocmd to watch for changes

### Phase 3: Click Handler (Priority: High)
1. Implement on_click() function
2. Add telescope require with lazy loading
3. Test click triggers find_files

### Phase 4: Styling (Priority: Medium)
1. Define highlight groups with specified colors
2. Apply colors to winbar elements
3. Verify colors match spec

### Phase 5: Integration (Priority: Medium)
1. Add require in init.lua
2. Test full integration
3. Verify no conflicts with lualine or terminal winbar

---

## 6. Testing Strategy

### 6.1 Unit Tests

| Test | Verification |
|------|--------------|
| Module loads | `lua require("quicksilver.ui.topbar")` succeeds |
| get_winbar() returns string | Returns valid winbar string when visible |
| get_winbar() returns nil | Returns nil when `g:topbar_visible = false` |
| on_click() function exists | Function is callable |

**Manual Test Commands:**
```lua
-- Test module loading
:lua require("quicksilver.ui.topbar")

-- Test visibility toggle
:let g:topbar_visible = 0
:lua vim.cmd("redrawstatus")

-- Test click handler (simulated)
:lua require("quicksilver.ui.topbar").on_click()
```

### 6.2 Integration Tests

| Test | Verification |
|------|--------------|
| Winbar appears on buffer enter | Open any file, winbar should show |
| Winbar disappears when hidden | Set `g:topbar_visible = 0`, winbar clears |
| Winbar reappears when shown | Set `g:topbar_visible = 1`, winbar shows |
| No conflict with terminal winbar | Open terminal buffer, both winbars work |

**Manual Test Commands:**
```lua
-- Verify winbar is set
:lua print(vim.wo.winbar)

-- Check highlight groups exist
:lua vim.pretty_print(vim.api.nvim_get_hl(0, { name = "WinBar" }))
```

### 6.3 E2E Tests

| Test | Verification |
|------|--------------|
| Click opens Telescope | Click "Search files", picker opens |
| Lazy loading works | Before first click, telescope not loaded |
| Works after telescope load | Subsequent clicks work normally |

**Manual Test:**
1. Open Neovim with fresh config
2. Verify "Search files" placeholder visible
3. Click on the placeholder
4. Telescope file finder should open
5. Select a file, verify navigation works

---

## 7. Open Questions

### Q1: Winbar Conflict with Terminal Buffer

**Issue:** The existing `terminal/winbar.lua` sets winbar for terminal buffers. Will our topbar winbar conflict?

**Resolution:** The terminal winbar uses `BufEnter` with pattern `term://*`. Our topbar uses `BufEnter` without pattern (all buffers). Need to verify priority or use `vim.wo[win].winbar` that properly overrides.

**Recommendation:** Test after implementation. If conflict, we can either:
- Make terminal winbar more specific (check buffer type first)
- Use different winbar priority
- Merge both into single winbar system

### Q2: Click Event Platform Compatibility

**Issue:** The `%@` click syntax works in Neovim 0.10+, but are there edge cases (headless mode, specific terminals)?

**Resolution:** Test in user's typical environment. The project targets Neovim 0.11+ which has full support.

### Q3: Color Contrast

**Issue:** The spec specifies background colors but not foreground (text color). Will "Search files" text be visible on `#363646` background?

**Resolution:** Use white (`#ffffff`) or light gray for text contrast. The design uses `#ffffff` for foreground in WinBar highlight.

---

## 8. Risks and Mitigations

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|-------------|
| Winbar conflicts with terminal winbar | Low | Medium | Test both simultaneously; merge if needed |
| Click not working in specific terminal | Low | High | Test in user's terminal (WezTerm); fallback to keybinding |
| Colors don't render correctly | Medium | Low | Adjust highlight groups; test with :highlight |
| Lazy loading doesn't trigger | Low | High | Use explicit `require("lazy").load()` before telescope require |

---

## 9. Dependencies

### Required
- Neovim 0.10+ (0.11 used by project)
- telescope.nvim (already installed)
- lazy.nvim (already installed)

### No New Dependencies
- No new plugins required
- No external Lua libraries needed

---

## 10. Related Artifacts

| Artifact | Location |
|----------|----------|
| Proposal | `.opencode/artifacts/top-bar-with-search/proposal.md` |
| Specs | `.opencode/artifacts/top-bar-with-search/specs/ui/spec.md` |
| Existing Winbar (reference) | `lua/quicksilver/terminal/winbar.lua` |
| Telescope Config | `lua/plugins/telescope.lua` |

---

## Design Summary

| Field | Value |
|-------|-------|
| **Status** | Approved |
| **Architecture** | Native Neovim winbar with click handler |
| **Visibility** | `vim.g.topbar_visible` (boolean, default true) |
| **Click Handler** | Winbar `%@` syntax with lazy telescope loading |
| **Module Location** | `lua/quicksilver/ui/topbar.lua` |
| **Files Changed** | 3 (1 new, 2 modified) |
| **Testing Approach** | Manual unit + integration + E2E |
| **Next Step** | sdd-tasks (task breakdown) |

---

*Generated by sdd-design sub-agent*