# Proposal: integrated-terminal

## Intent

Enhance the existing betterterm.nvim terminal integration to fully replicate VS Code's integrated terminal experience, enabling multi-terminal support, proper lazygit integration, and exposing advanced features currently hidden behind missing keymaps.

## Scope

### In Scope
- Implement multi-terminal support (multiple terminal instances)
- Add toggle_opencode() function for terminal toggle in opencode workflow
- Create advanced keymaps for terminal navigation and management
- Fix lazygit integration in lualine statusline
- Update README.md to reflect actual implementation
- Implement planned features from TESTCASES_MULTITERMINAL.md

### Out Scope
- Migrating to toggleterm (explicitly rejected)
- Adding terminal multiplexing beyond single neovim instance
- Custom terminal emulator UI changes

## Approach

**Keep betterterm and enhance it** — The existing betterterm.nvim setup is solid (~700 LOC), has a VS Code-like tabbed interface, but has unused features (tabs, rename, send commands) and missing glue code. We'll:
1. Implement the missing `toggle_opencode()` function in telescope.lua
2. Add keymaps for betterterm's unused features in keymaps.lua
3. Wire up lazygit properly in lualine.lua
4. Document actual behavior in README.md

## Affected Files
- `lua/plugins/betterterm.lua` — enhance configuration, enable all features
- `lua/quicksilver/keymaps.lua` — expose advanced terminal keymaps
- `lua/plugins/telescope.lua` — add toggle_opencode() function
- `lua/plugins/lualine.lua` — integrate lazygit status properly
- `README.md` — fix documentation inconsistencies
- `TESTCASES_MULTITERMINAL.md` — implement planned multi-terminal features

## Risks

| Risk | Impact | Mitigation |
|------|--------|-------------|
| betterterm API changes | Low | Plugin is stable, minimal surface area |
| Keymap conflicts | Low | Prefix with leader, check existing mappings |
| Multi-term edge cases | Medium | Test incrementally, keep fallback |

## Rollback Plan

1. Revert keymap changes in `lua/quicksilver/keymaps.lua`
2. Revert config changes in `lua/plugins/betterterm.lua`
3. Restore README.md from git
4. Remove any new files created

## Success Criteria

- [ ] `toggle_opencode()` works from any context
- [ ] Can open 3+ terminal instances simultaneously
- [ ] Can rename terminals via betterterm UI
- [ ] Can send commands to terminal from normal mode
- [ ] Lazygit shows in lualine when terminal is running
- [ ] README.md accurately describes terminal functionality
- [ ] All existing terminal tests pass

## Timeline Estimate

- Phase 1: toggle_opencode + basic keymaps (1 task)
- Phase 2: Multi-terminal support (1 task)  
- Phase 3: Lazygit integration (1 task)
- Phase 4: Documentation fix (1 task)
