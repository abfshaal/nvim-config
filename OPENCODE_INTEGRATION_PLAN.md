# OpenCode.nvim Integration Plan

## Goal
Merge the best features from two opencode.nvim implementations:
- **NickvanDyke/opencode.nvim**: Quick prompt injection with context expansion
- **sudo-tee/opencode.nvim**: Full buffer UI with normal mode navigation

## Problem Statement
**NickvanDyke's implementation:**
- ✅ Quick context injection (`@this`, `@buffer`, `@diagnostics`)
- ✅ Fast workflow with auto-submit
- ❌ Terminal-based input (no normal mode navigation, can't yank/edit easily)

**sudo-tee's implementation:**
- ✅ Full Neovim buffer UI with normal mode (hjkl, yank, visual mode)
- ✅ Persistent sessions with timeline navigation
- ✅ Diff/snapshot management
- ❌ No quick prompt injection with context expansion

## Desired Outcome
Create a combined implementation that provides:
1. **Quick prompt injection** (from NickvanDyke)
   - Pre-fill input with context using `@this`, `@buffer`, etc.
   - Auto-submit option for rapid workflow

2. **Proper buffer UI** (from sudo-tee)
   - Full normal mode navigation in chat buffer
   - Yank, visual selection, all Vim motions
   - Persistent session management

## Key Features to Port

### From NickvanDyke → sudo-tee

**1. Context Expansion System**
- Location: `/tmp/nickvan-opencode/lua/opencode/`
- Key function: `ask(prompt, opts)` with context placeholders
- Placeholders to support:
  - `@this` - Current selection or cursor context
  - `@buffer` - Full buffer contents
  - `@diagnostics` - LSP diagnostics
  - Other context types

**2. Quick Keybinding Pattern**
```lua
vim.keymap.set({ "n", "x" }, "<C-a>", function()
  require("opencode").ask("@this: ", { submit = true })
end)
```
This should:
- Expand `@this` to actual context
- Open sudo-tee's input buffer (not terminal)
- Pre-fill the input with expanded context
- Optionally auto-submit

**3. Tab Completion for Context**
- Auto-complete `@` placeholders in input
- Integration with existing completion systems

## Technical Approach

### Phase 1: Analysis
1. Study NickvanDyke's context expansion implementation
2. Study sudo-tee's buffer/UI management
3. Identify integration points

### Phase 2: Implementation
1. Add context expansion module to sudo-tee
2. Modify `open_input()` to accept pre-filled content
3. Add `ask()` function that:
   - Expands context placeholders
   - Opens input buffer with content
   - Optionally auto-submits
4. Add Tab completion for `@` placeholders in input buffer

### Phase 3: Testing
1. Test quick prompt injection workflow
2. Verify normal mode navigation still works
3. Test all context types (`@this`, `@buffer`, etc.)
4. Ensure persistent sessions work correctly

## Repository Locations
- **NickvanDyke**: `/tmp/nickvan-opencode`
- **sudo-tee**: `/tmp/sudotee-opencode`

## Key Files to Review

### NickvanDyke (Context System)
- `lua/opencode/context.lua` (if exists) - Context expansion logic
- `lua/opencode/init.lua` - Main `ask()` function
- Check how `@this`, `@buffer` are processed

### sudo-tee (UI System)
- `lua/opencode/init.lua` - Main plugin entry
- `lua/opencode/ui/` - UI management
- `lua/opencode/input.lua` (if exists) - Input buffer handling
- Check how `open_input()` works

## Expected Keybindings (Final)
```lua
-- Quick context injection (opens UI with pre-filled context)
vim.keymap.set({ "n", "x" }, "<C-a>", function()
  require("opencode").ask("@this: ", { submit = true })
end, { desc = "Ask opencode with context" })

-- Toggle full UI
vim.keymap.set({ "n", "t" }, "<C-o>", function()
  require("opencode").toggle()
end, { desc = "Toggle opencode" })

-- Add context to existing conversation
vim.keymap.set({ "n", "x" }, "ga", function()
  require("opencode").add_context("@this")
end, { desc = "Add context to opencode" })

-- Quick actions menu
vim.keymap.set({ "n", "x" }, "<C-x>", function()
  require("opencode").select()
end, { desc = "Execute opencode action…" })
```

## Success Criteria
- [ ] Can use `<C-a>` to quickly inject context into opencode
- [ ] Input/chat buffers support full normal mode navigation
- [ ] Can yank, visual select, and edit in chat history
- [ ] Context expansion works for `@this`, `@buffer`, `@diagnostics`
- [ ] Tab completion works for `@` placeholders
- [ ] Persistent sessions maintained
- [ ] All existing sudo-tee features still work

## Notes
- Both plugins interface with the same underlying `opencode` CLI tool
- Focus on merging UI/UX patterns, not rewriting core opencode logic
- Consider whether to fork sudo-tee or contribute upstream
- Test thoroughly with real opencode CLI running

## Next Steps
1. Read through both codebases in a fresh LLM session
2. Map out the exact integration points
3. Implement context expansion in sudo-tee
4. Test the integrated workflow
5. Consider upstreaming changes to sudo-tee

---
*Created: 2025-12-12*
*Target: Unified opencode.nvim with best of both worlds*
