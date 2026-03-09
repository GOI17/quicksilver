# Multi-Terminal Feature Test Cases

## ⚠️ STATUS: Implementation migrated to betterTerm

This document was originally written for ToggleTerm but has been migrated to use betterTerm. Some test cases below reference old APIs that no longer exist.

---

## Migration Notes

| Old API (ToggleTerm) | New API (betterTerm) |
|---------------------|---------------------|
| `spawn_terminal()` | `require("quicksilver.terminal").spawn(name, cmd, opts)` |
| `list_terminals()` | `require("quicksilver.terminal").list()` |
| `toggle_opencode_vertical()` | `require("quicksilver.terminal").toggle_opencode_vertical()` |
| `toggle_shell_vertical()` | Better handled via betterTerm or custom spawn |
| `<leader>tn` | `<leader>tn` (unchanged, uses terminal module) |
| `<leader>tl` | `<leader>tl` (unchanged) |

---

## Updated Test Cases for betterTerm Implementation

### Test Case 1: Spawn Terminal with Default Terminals
**Prerequisite:** Neovim with quicksilver config loaded

**Step:**
```vim
:lua require("quicksilver.terminal").setup_defaults()
```

**Expected Result:**
- Three default terminals spawn: lazygit, node, python
- All run in background (focus=false)
- Can be toggled individually

**Actual Result:** __________________

---

### Test Case 2: Toggle Terminal
**Prerequisite:** Default terminals are running

**Step:**
```vim
:lua require("quicksilver.terminal").toggle("lazygit")
```

**Expected Result:**
- LazyGit terminal window opens/focuses
- User is in insert mode in terminal

**Actual Result:** __________________

---

### Test Case 3: List Terminals
**Step:**
```vim
:lua vim.print(require("quicksilver.terminal").list())
```

**Expected Result:**
- Shows table with terminal names as keys
- Each entry has: name, cmd, direction, bufnr, winnr, tabnr

**Actual Result:** __________________

---

### Test Case 4: Send Command to Terminal
**Step:**
```vim
:lua require("quicksilver.terminal").send("node", "console.log('test')\n")
```

**Expected Result:**
- Command sent to node terminal
- Output appears in terminal

**Actual Result:** __________________

---

### Test Case 5: Rename Terminal
**Step:**
```vim
:lua require("quicksilver.terminal").rename("node", "nodejs")
```

**Expected Result:**
- Terminal renamed from "node" to "nodejs"
- Old key removed, new key added

**Actual Result:** __________________

---

### Test Case 6: Close Terminal
**Step:**
```vim
:lua require("quicksilver.terminal").close("python")
```

**Expected Result:**
- Python terminal removed from list
- Buffer deleted if valid

**Actual Result:** __________________

---

### Test Case 7: Toggle LazyGit Integration
**Step:**
```vim
:lua require("quicksilver.terminal").toggle("lazygit")
```

Or use keymap:
```vim
<leader>tg
```

**Expected Result:**
- LazyGit interface opens in floating window

**Actual Result:** __________________

---

### Test Case 8: Edge Case - Missing Terminal
**Step:**
```vim
:lua require("quicksilver.terminal").toggle("nonexistent")
```

**Expected Result:**
- Warning notification: "Terminal 'nonexistent' not found"
- Returns false gracefully

**Actual Result:** __________________

---

### Test Case 9: Edge Case - Invalid Command
**Prerequisite:** betterTerm loaded

**Step:**
```vim
:lua require("quicksilver.terminal").spawn("bad", "nonexistentcommand12345", {direction="horizontal"})
```

**Expected Result:**
- Terminal attempts to spawn
- Error from shell (command not found)
- Terminal still registered in list

**Actual Result:** __________________

---

## Keymap Verification

| Keymap | Action | Status |
|--------|--------|--------|
| `<C-t>t` | Toggle terminal | ✅ Uses betterTerm |
| `<leader>tg` | Toggle LazyGit | ✅ Uses terminal module |
| `<leader>tn` | Spawn terminal (new) | ✅ |
| `<leader>tl` | List terminals | ✅ |
| `<leader>toS` | Send line to terminal | ✅ |
| `<leader>toR` | Rename terminal | ✅ |
| `<leader>toC` | Close terminal | ✅ |

---

## Test Summary

| Category | Total | Passed | Failed | Pending |
|----------|-------|--------|--------|---------|
| Terminal Spawn | 1 | | | |
| Terminal Toggle | 1 | | | |
| Terminal List | 1 | | | |
| Send Command | 1 | | | |
| Rename Terminal | 1 | | | |
| Close Terminal | 1 | | | |
| LazyGit Integration | 1 | | | |
| Edge Cases | 2 | | | |
| **TOTAL** | **9** | | | |

---

## Quick Verification Commands

```vim
" Test 1: Setup defaults (spawns lazygit, node, python)
:lua require("quicksilver.terminal").setup_defaults()

" Test 2: Toggle LazyGit
:lua require("quicksilver.terminal").toggle("lazygit")

" Test 3: List all terminals
:lua vim.print(require("quicksilver.terminal").list())

" Test 4: Send command to node
:lua require("quicksilver.terminal").send("node", "1+1\n")

" Test 5: Close a terminal
:lua require("quicksilver.terminal").close("python")

" Test 6: Select terminal via UI
:lua require("quicksilver.terminal").select()
```

---

## Notes

- All tests should be performed in a **fresh Neovim instance**
- Use `qa!` or `:qa!` to exit without saving
- betterTerm handles terminal spawning differently than ToggleTerm
- Default terminals (lazygit, node, python) are spawned with `focus=false`
