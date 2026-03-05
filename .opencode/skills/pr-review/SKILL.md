---
name: pr-review
description: Review pull requests for Neovim configuration changes
---

## What I do

- Analyze PR changes for quality and correctness
- Check for breaking changes
- Verify configuration syntax
- Suggest improvements

## When to use me

Use this when reviewing pull requests to the Neovim configuration.

## Review Checklist

### Code Quality
- [ ] Lua syntax is valid
- [ ] Idiomatic Lua patterns used
- [ ] No hardcoded paths
- [ ] Error handling in place

### Neovim Specific
- [ ] LSP servers properly configured
- [ ] Keybindings don't conflict
- [ ] Plugin specs are correct
- [ ] Performance considerations

### Git
- [ ] Commits are atomic
- [ ] Commit messages are clear
- [ ] No secrets exposed

## Output Format

```markdown
## Review Summary
[Brief overview]

## Changes
[What was modified]

## Suggestions
- [Priority] Description

## Approve/Request Changes
[Final verdict with reasoning]
```
