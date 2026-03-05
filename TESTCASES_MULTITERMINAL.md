# Multi-Terminal Feature Test Cases

## Quicksilver Neovim Config - Toggleterm Extension

---

## 1. Spawn Terminal Tests

### Test Case 1.1: Create Terminal with Custom Name
**Step:**
```vim
:lua spawn_terminal()
```
When prompted for name, enter: `mydev`
When prompted for command, enter: `htop`

**Expected Result:**  
- New vertical terminal opens with name `mydev`
- Terminal runs `htop` command
- Terminal is registered in the terminals list
- User is placed in insert mode inside the terminal

**Actual Result:** __________________

---

### Test Case 1.2: Create Terminal with Custom Command
**Step:**
```vim
:lua spawn_terminal()
```
When prompted for name, enter: `logs`
When prompted for command, enter: `tail -f /var/log/system.log`

**Expected Result:**  
- New vertical terminal opens with name `logs`
- Terminal runs the `tail -f` command
- Command output is visible in terminal

**Actual Result:** __________________

---

### Test Case 1.3: Empty Name Handling (Cancel)
**Step:**
```vim
:lua spawn_terminal()
```
Press Enter without entering a name (or Escape)

**Expected Result:**  
- Function returns early
- No terminal is created
- No error message displayed

**Actual Result:** __________________

---

### Test Case 1.4: Empty Command (Default Shell)
**Step:**
```vim
:lua spawn_terminal()
```
When prompted for name, enter: `defaultshell`
When prompted for command, press Enter without entering anything

**Expected Result:**  
- New vertical terminal opens with name `defaultshell`
- Terminal runs default shell (vim.o.shell - likely zsh/bash)
- User gets interactive shell prompt

**Actual Result:** __________________

---

### Test Case 1.5: Use Default Shell via Empty Input
**Step:**
```vim
:lua spawn_terminal()
```
When prompted for name, enter: `interactive`
When prompted for command, leave empty and press Enter

**Expected Result:**  
- Terminal opens with interactive shell
- User can execute commands

**Actual Result:** __________________

---

## 2. List Terminal Tests

### Test Case 2.1: Show All Registered Terminals
**Prerequisite:** At least 2 terminals created (e.g., `mydev`, `logs` from previous tests)

**Step:**
```vim
:lua list_terminals()
```

**Expected Result:**  
- vim.ui.select dropdown appears
- Shows list: `["opencode", "shell", "mydev", "logs"]` (all registered terminals)
- User can navigate with arrow keys

**Actual Result:** __________________

---

### Test Case 2.2: Select and Toggle a Terminal
**Prerequisite:** Terminals exist (run Test 2.1 first)

**Step:**
```vim
:lua list_terminals()
```
Select `shell` from the list

**Expected Result:**  
- If shell terminal was closed: opens in vertical split
- If shell terminal was open: closes it
- Terminal toggles to opposite state

**Actual Result:** __________________

---

### Test Case 2.3: Empty Terminal List Message
**Prerequisite:** This must be tested on a fresh Neovim instance without any spawn_terminal calls

**Step:**
```vim
:lua list_terminals()
```

**Expected Result:**  
- Notification appears: "No terminals registered. Use :spawn_terminal to create one."
- Info-level notification (not error)
- No crash or exception

**Actual Result:** __________________

---

### Test Case 2.4: Cancel Terminal Selection
**Step:**
```vim
:lua list_terminals()
```
Press Escape or Ctrl+C to cancel selection

**Expected Result:**  
- Selection menu closes
- No terminal toggled
- No error message

**Actual Result:** __________________

---

## 3. Existing Functionality Tests (Backward Compatibility)

### Test Case 3.1: opencode Terminal Still Works
**Step:**
```vim
:lua toggle_opencode_vertical()
```

**Expected Result:**  
- opencode terminal opens in vertical split
- User is in insert mode
- Terminal runs `opencode` command

**Actual Result:** __________________

---

### Test Case 3.2: shell Terminal Still Works (Vertical)
**Step:**
```vim
:lua toggle_shell_vertical()
```

**Expected Result:**  
- shell terminal opens in vertical split (35% width)
- User gets shell prompt
- In insert mode

**Actual Result:** __________________

---

### Test Case 3.3: shell Terminal Horizontal Mode
**Step:**
```vim
:lua toggle_shell_horizontal()
```

**Expected Result:**  
- shell terminal opens in horizontal split (15 rows)
- User gets shell prompt

**Actual Result:** __________________

---

### Test Case 3.4: shell Terminal Tab Mode
**Step:**
```vim
:lua toggle_shell_tab()
```

**Expected Result:**  
- shell terminal opens in new tab
- User gets shell prompt

**Actual Result:** __________________

---

### Test Case 3.5: opencode Terminal Tab Mode
**Step:**
```vim
:lua toggle_opencode_tab()
```

**Expected Result:**  
- opencode terminal opens in new tab
- User is in insert mode

**Actual Result:** __________________

---

### Test Case 3.6: Skill Picker Still Works
**Step:**
```vim
:lua opencode_skill_pick()
```
Select "Lua expert" from the list

**Expected Result:**  
- opencode terminal opens (if not already open)
- Sends `/skills Lua expert\n` command to terminal

**Actual Result:** __________________

---

## 4. Keymap Tests

### Test Case 4.1: <leader>tn Spawns New Terminal
**Step:**
Press `<leader>tn` (Leader is typically backslash on standard setups)

**Expected Result:**  
- Same behavior as calling `spawn_terminal()` directly
- Prompts for terminal name

**Actual Result:** __________________

---

### Test Case 4.2: <leader>tl Lists Terminals
**Step:**
Press `<leader>tl`

**Expected Result:**  
- Same behavior as calling `list_terminals()` directly
- Shows terminal selection list

**Actual Result:** __________________

---

## 5. Edge Cases

### Test Case 5.1: Duplicate Terminal Names
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `duplicate`
Enter command: `echo "first"`

Then run again:
```vim
:lua spawn_terminal()
```
Enter name: `duplicate`
Enter command: `echo "second"`

**Expected Result:**  
- Second terminal **overwrites** the first in the terminals table
- Only one terminal named `duplicate` exists
- Latest terminal is toggleable

**Actual Result:** __________________

---

### Test Case 5.2: Special Characters in Terminal Names
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `test-node@prod`
Enter command: `node --version`

**Expected Result:**  
- Terminal is created and opens successfully
- Name with `@` works correctly
- Terminal is registered and toggleable

**Actual Result:** __________________

---

### Test Case 5.3: Spaces in Terminal Names
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `my special term`
Enter command: `pwd`

**Expected Result:**  
- Terminal is created with spaces in name
- vim.ui.select displays it correctly
- Terminal toggles properly

**Actual Result:** __________________

---

### Test Case 5.4: Unicode Characters in Terminal Names
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `测试终端`
Enter command: `ls`

**Expected Result:**  
- Terminal created with unicode name
- List shows unicode correctly
- Terminal functions properly

**Actual Result:** __________________

---

### Test Case 5.5: Very Long Commands
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `longcmd`
Enter command: `for i in {1..100}; do echo "Line $i"; done`

**Expected Result:**  
- Terminal opens and executes long command
- Command runs to completion
- Output is displayed

**Actual Result:** __________________

---

### Test Case 5.6: Command with Pipes
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `piped`
Enter command: `ls -la | grep lua | wc -l`

**Expected Result:**  
- Pipeline executes correctly
- Output shows count of lua files

**Actual Result:** __________________

---

### Test Case 5.7: Empty Command (Explicit Empty String)
**Step:**
```vim
:lua spawn_terminal()
```
Enter name: `emptycmd`
Press Enter immediately when asked for command

**Expected Result:**  
- Terminal opens with default shell
- Interactive shell prompt appears (same as Test 1.4)

**Actual Result:** __________________

---

## 6. Integration Tests

### Test Case 6.1: Full Workflow - Create, List, Toggle, Close
**Step:**
1. `<leader>tn` → name: `workflow`, command: `vim --version`
2. Terminal opens, verify vim version output
3. Close terminal (same key or :q)
4. `<leader>tl` → select `workflow`
5. Terminal reopens

**Expected Result:**  
- Complete workflow works end-to-end
- Terminal state persists correctly

**Actual Result:** __________________

---

### Test Case 6.2: Mixed Built-in and Custom Terminals
**Step:**
1. `<leader>tl` - verify shows `opencode` and `shell`
2. `<leader>tn` - create `custom1`
3. `<leader>tl` - verify now shows `opencode`, `shell`, `custom1`
4. Toggle through each using list

**Expected Result:**  
- All terminals (built-in + custom) appear in list
- All are toggleable

**Actual Result:** __________________

---

## Test Summary

| Category | Total | Passed | Failed | Pending |
|----------|-------|--------|--------|---------|
| Spawn Terminal | 5 | | | |
| List Terminals | 4 | | | |
| Backward Compatibility | 6 | | | |
| Keymaps | 2 | | | |
| Edge Cases | 7 | | | |
| Integration | 2 | | | |
| **TOTAL** | **26** | | | |

---

## Quick Verification Commands

Run these minimal commands to verify core functionality:

```vim
" Test 1: Spawn terminal
:lua spawn_terminal()

" Test 2: List terminals  
:lua list_terminals()

" Test 3: Toggle existing opencode
:lua toggle_opencode_vertical()

" Test 4: Toggle existing shell
:lua toggle_shell_vertical()

" Test 5: Skill picker
:lua opencode_skill_pick()

" Test 6: Via keymaps
<leader>tn
<leader>tl
```

---

## Notes

- All tests should be performed in a **fresh Neovim instance** for edge case tests
- Use `qa!` or `:qa!` to exit without saving
- Test with different shell types if applicable (bash, zsh, fish)
- Verify terminal direction matches configuration (vertical = 35% width, horizontal = 15 rows)
