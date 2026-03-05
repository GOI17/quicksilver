---
name: lua-style-guide
description: Lua coding standards and best practices for Neovim plugins
---

## What I do

- Enforce Lua coding standards
- Check for idiomatic Lua patterns
- Verify Neovim API usage
- Validate lazy.nvim plugin spec

## Guidelines

### Formatting
- Use 2 spaces for indentation
- UpperCamelCase for modules, lower_snake_case for variables
- Prefer local over global variables
- Use table literals `{}` instead of `require("plenary.table")`

### Neovim APIs
- Use `vim.api.nvim_*` over `vim.cmd`
- Prefer `vim.fn.*` for Vim functions
- Use `vim.opt.*` for settings (not `vim.cmd`)

### Lazy.nvim
- Use proper plugin spec structure
- Ensure lazy-loading for performance
- Define dependencies correctly
