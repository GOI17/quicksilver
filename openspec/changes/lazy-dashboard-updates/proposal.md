# Proposal: lazy-dashboard-updates

## Intent

Show plugin updates from lazy.nvim on the startup dashboard. Users need visibility into available plugin updates without manually running `:Lazy` — they want to see at a glance if their plugins are outdated when Neovim starts.

## Scope

### In Scope
- Modify `lua/plugins/dashboard.lua` to display plugin update count from lazy.nvim
- Display both update count AND startup time in footer
- Add shortcut button to trigger `Lazy update`

### Out of Scope
- Automatic plugin updates (manual trigger only)
- Update notifications outside dashboard context
- Modifying dashboard theme or other visual elements

## Approach

Use event-based updates with `LazyVimStarted` to get accurate update status. This event fires after lazy.nvim finishes loading, providing accurate update counts.

**Technical implementation:**
1. Listen for `LazyVimStarted` event
2. Call `require("lazy").status.updates()` to get update count
3. Call `require("lazy").stats()` to get startup time
4. Display both in dashboard footer area

**Why this approach:**
- `LazyVimStarted` ensures lazy.nvim has completed its work (unlike `VimEnter` which may fire too early)
- Avoids polling or manual refresh
- Leverages existing lazy.nvim APIs that are already stable

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lua/plugins/dashboard.lua` | Modified | Add update count and startup time display in footer |
| `init.lua` | No change | lazy.nvim already configured |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Dashboard fails if lazy.nvim unavailable | Low | Add guard: `pcall(require, "lazy")` before using APIs |
| API breaking changes in lazy.nvim | Low | Use stable documented APIs (`status.updates`, `stats`) with error handling |

## Rollback Plan

1. Run `git checkout lua/plugins/dashboard.lua` to restore original file
2. Restart Neovim — dashboard returns to previous state

## Dependencies

- lazy.nvim (already installed and configured)
- dashboard-nvim plugin (already installed)
- LazyVimStarted autocmd (provided by lazy.nvim)

## Success Criteria

- [ ] Dashboard shows plugin update count (e.g., "5 updates") on startup
- [ ] Startup time displayed in footer alongside update count
- [ ] Shortcut button to run `Lazy update` works correctly
- [ ] No errors in Neovim startup related to dashboard
- [ ] Works correctly when lazy.nvim checker finds no updates
