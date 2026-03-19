# Task Breakdown: top-bar-with-search

## Overview

| Field | Value |
|-------|-------|
| Change | top-bar-with-search |
| Status | Ready for Implementation |
| Total Tasks | 12 |
| Phases | 4 |

---

## Phase 1: Foundation (2 tasks)

### Task 1.1: Add visibility setting to options.lua

**File:** `lua/quicksilver/options.lua`

**Description:** Add the `vim.g.topbar_visible` global variable with default value of `true`.

**Implementation:**
- Add the following at the end of `lua/quicksilver/options.lua`:

```lua
-- Topbar visibility (default: true)
vim.g.topbar_visible = vim.g.topbar_visible ~= false
```

**Verification:**
- Load the config and verify `vim.g.topbar_visible` is `true` by default
- Verify setting `vim.g.topbar_visible = false` works

---

### Task 1.2: Require topbar module in init.lua

**File:** `init.lua`

**Description:** Add the require statement to load the topbar module during Neovim startup.

**Implementation:**
- After line 15 (`require("quicksilver.keymaps")`), add:

```lua
require("quicksilver.ui.topbar").setup()
```

**Verification:**
- Start Neovim and verify no errors occur on load

---

## Phase 2: Core Implementation (7 tasks)

### Task 2.1: Create ui directory

**Description:** Create the `lua/quicksilver/ui/` directory structure.

**Implementation:**
- Create directory `lua/quicksilver/ui/`

---

### Task 2.2: Create topbar.lua module skeleton

**File:** `lua/quicksilver/ui/topbar.lua`

**Description:** Create the main module file with the standard module pattern returning `M` table with `setup()` function.

**Implementation:**
- Create the file with:
  - Local `M = {}` table
  - Module documentation comment
  - Empty `function M.setup()` that returns `M`
  - `return M` at the end

**Verification:**
- Run `:lua require("quicksilver.ui.topbar")` - should return table without error

---

### Task 2.3: Implement get_winbar() function

**File:** `lua/quicksilver/ui/topbar.lua`

**Description:** Implement the function that generates the winbar string with the search placeholder.

**Implementation:**
- Add config table with default values (placeholder: "Search files", colors from spec)
- Implement `get_winbar()` function that:
  - Checks `vim.g.topbar_visible` - returns `nil` if `false`
  - Returns winbar string with centered search placeholder
  - Uses `%=` for centering
  - Uses click handler syntax: `%@lua:require('quicksilver.ui.topbar').on_click()%`

**Winbar format:**
```lua
"%#WinBar# %@lua:require('quicksilver.ui.topbar').on_click()%Search files%"
```

**Verification:**
- Open a buffer - winbar should display "Search files"

---

### Task 2.4: Implement click handler for telescope

**File:** `lua/quicksilver/ui/topbar.lua`

**Description:** Implement `on_click()` function that opens Telescope file finder.

**Implementation:**
- Implement `M.on_click()` function that:
  - Uses `require("lazy").load({ plugins = { "telescope.nvim" } })` for lazy loading
  - Calls `require("telescope.builtin").find_files()`

**Verification:**
- Click on "Search files" - Telescope picker should open

---

### Task 2.5: Add highlight groups

**File:** `lua/quicksilver/ui/topbar.lua`

**Description:** Define the highlight groups for the winbar with colors from the spec.

**Implementation:**
- Create `setup_highlights()` function that sets:
  - `WinBar` - bg: #363646, fg: #ffffff
  - `TopBarSearchBg` - bg: #1a1a22
  - `TopBarSearchBorder` - fg: #16161D

**Verification:**
- Run `:lua vim.pretty_print(vim.api.nvim_get_hl(0, { name = "WinBar" }))` - should show correct colors

---

### Task 2.6: Add autocmds for winbar display

**File:** `lua/quicksilver/ui/topbar.lua`

**Description:** Set up autocmds to display winbar on buffer enter and manage visibility.

**Implementation:**
- In `M.setup()`, create autocmds for:
  - `BufEnter`, `BufWinEnter`, `WinEnter` - set winbar using `M.get_winbar()`
  - `WinLeave` - clear winbar
  - `OptionSet` (pattern: "topbar_visible") - refresh with `vim.cmd("redrawstatus")`

**Verification:**
- Open different buffers - winbar should appear on each
- Close buffer - winbar should clear

---

### Task 2.7: Update setup() to initialize module

**File:** `lua/quicksilver/ui/topbar.lua`

**Description:** Wire everything together in the setup function.

**Implementation:**
- Update `M.setup()` to:
  - Call `setup_highlights()`
  - Initialize `vim.g.topbar_visible = true` if nil
  - Create the autocmds

**Verification:**
- Neovim starts without errors
- Winbar appears correctly

---

## Phase 3: Integration (2 tasks)

### Task 3.1: Verify module loads correctly

**Description:** Test that the entire integration works end-to-end.

**Implementation:**
- Start Neovim
- Run `:lua require("quicksilver.ui.topbar")`
- Verify no errors

**Expected:** Module loads without errors, winbar displays

---

### Task 3.2: Test visibility toggle

**Description:** Test that toggling `vim.g.topbar_visible` shows/hides the winbar.

**Implementation:**
- With winbar visible, run:
  ```lua
  :lua vim.g.topbar_visible = false
  :lua vim.cmd("redrawstatus")
  ```
- Winbar should disappear

- Then run:
  ```lua
  :lua vim.g.topbar_visible = true
  :lua vim.cmd("redrawstatus")
  ```
- Winbar should reappear

**Expected:** Toggle works correctly

---

## Phase 4: Verification (1 task)

### Task 4.1: Manual E2E testing

**Description:** Complete end-to-end verification of all features.

**Implementation - Test 1: Colors**
- Open any file
- Run `:highlight WinBar`
- Verify bg is #363646

**Implementation - Test 2: Click to search**
- Click on "Search files" text in winbar
- Telescope picker should open with file finder

**Implementation - Test 3: Visibility toggle**
- Run `:let g:topbar_visible = 0` then `:redrawstatus`
- Winbar should hide
- Run `:let g:topbar_visible = 1` then `:redrawstatus`
- Winbar should show

**Expected:** All three tests pass

---

## Implementation Order

```
Phase 1 → Phase 2 → Phase 3 → Phase 4
   ↓         ↓          ↓         ↓
Tasks    Tasks       Tasks     Task
 1.1   →  2.1-2.7 →  3.1-3.2 →  4.1
 1.2
```

**Recommended Sequence:**

1. **Start with Phase 1** - Get config and init working
2. **Phase 2** - Build the module incrementally (skeleton → winbar → click → autocmds)
3. **Phase 3** - Integration testing
4. **Phase 4** - Full verification

---

## Next Recommended Step

Run **Phase 1** tasks to set up the foundation:

1. Add visibility setting to `lua/quicksilver/options.lua`
2. Add require in `init.lua`

This establishes the configuration layer before implementing the main module in Phase 2.

---

*Generated by sdd-tasks sub-agent*