# Proposal: top-bar-with-search

## Intent

Add a new top bar component to the Neovim UI that provides quick access to file search (Telescope) from a visible, always-accessible location. This addresses the need for a more discoverable file search trigger beyond keybindings, improving UX for users who prefer visual/clickable interfaces.

## Scope

### In Scope
- Create new top bar component at window top (winbar)
- Implement dynamic visibility toggle (show/hide via user setting)
- Center placeholder input "Search files" that triggers Telescope file finder on click
- Apply specified colors: bar background #363646, input border #16161D, input background #1a1a22

### Out of Scope
- Modifying existing status bar (lualine)
- Adding search to other locations (quickfix, etc.)
- Creating new Telescope pickers (use existing file finder)

## Approach

**Add a custom winbar** using Neovim's native winbar API (`winbar` option in Neovim 0.10+). The winbar will:
1. Define a custom winbar in `lua/quicksilver/ui/` (new directory)
2. Use `vim.wo.winbar` to set the bar per window
3. Create a clickable "Search files" component using `vim.ui.input` or Telescope's native picker
4. Add visibility toggle in `lua/quicksilver/options.lua` 
5. Apply exact colors from spec using `hl` groups

Reference: Existing winbar in `lua/quicksilver/terminal/winbar.lua` shows the pattern.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lua/quicksilver/ui/` | New | Create winbar module for top bar |
| `lua/quicksilver/options.lua` | Modified | Add `g.topbar_visible` setting |
| `lua/plugins/telescope.lua` | Modified | May need to ensure picker is accessible |
| `init.lua` | Modified | Source the new ui module |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Winbar conflicts with existing winbar | Low | Check existing winbar in terminal/winbar.lua first |
| Click events not working in Neovim version | Low | Verify Neovim 0.10+ (0.11 is minimum for quicksilver) |
| Colors not matching spec exactly | Medium | Test in actual Neovim, may need tweaking |

## Rollback Plan

1. Remove `lua/quicksilver/ui/` directory
2. Revert changes to `lua/quicksilver/options.lua`
3. Revert changes to `init.lua`
4. Restore original telescope.lua if modified

## Dependencies

- Neovim 0.10+ (winbar API requirement)
- telescope.nvim (already installed)
- User setting: `g.topbar_visible` (boolean, default true)

## Success Criteria

- [ ] Top bar appears at window top when enabled
- [ ] Clicking "Search files" opens Telescope file finder
- [ ] Colors match spec: bar #363646, border #16161D, input bg #1a1a22
- [ ] Visibility can be toggled via `g.topbar_visible`
- [ ] Does not break existing status bar (lualine)
- [ ] Works in Neovim 0.11