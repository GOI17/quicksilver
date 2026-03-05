---
name: test-runner
description: Run tests and verify Neovim configuration changes
---

## What I do

- Execute test suites for Neovim plugins
- Run Neovim with minimal config to test changes
- Verify plugin functionality
- Check for runtime errors

## When to use me

Use this when you need to:
- Test plugin changes
- Verify Neovim configuration works
- Check for Lua errors
- Run plugin test suites

## Commands

### Basic Neovim test
```bash
nvim --headless -c "lua vim.print('test')" -c "quit"
```

### Run plugin tests
```bash
nvim --headless -u minimal_init.lua -c "PlenaryBustedDirectory tests {minimal_init = './tests/minimal_init.lua'}"
```

### Check for errors
```bash
nvim --headless +"lua vim.print(vim.inspect(vim.lsp.buf.validate()))" +qa
```
