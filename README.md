# Neovim Configuration

A professional Neovim setup optimized for Python development with AI assistance, debugging capabilities, and terminal integration.

## Architecture

### Entry Point
- **init.lua** - Bootstraps the configuration by loading `lua/config/lazy.lua`

### Core Configuration (`lua/config/`)
- **lazy.lua** - Sets up Lazy.nvim plugin manager
- **options.lua** - Vim options (disables LSP semantic tokens, prioritizes Tree-sitter)
- **keymaps.lua** - Custom keybindings
- **autocmds.lua** - Autocommands (forces Tree-sitter for Python files)

### Plugins (`lua/plugins/`)
32 plugins organized by functionality (see below)

### Custom Implementation (`opencode/`)
Custom opencode.nvim fork with session management and terminal providers

---

## Plugin Categories

### Code Editing & Completion

**nvim-treesitter** (`treesitter.lua`)
- Syntax highlighting, indentation, and code folding
- Languages: bash, c, html, javascript, json, lua, markdown, python, tsx, typescript, vim, yaml

**nvim-lspconfig** (`lsp.lua`)
- LSP client configuration
- **pyright** - Python type checking (basic mode)
- **sourcekit** - Swift language server

**nvim-cmp** (`cmp.lua`)
- Completion engine
- Tab to confirm, Enter disabled
- Sources: LSP, buffer, path

**copilot.vim** (`copilot.lua`)
- GitHub Copilot integration

**codecompanion.nvim** (`codecomp.lua`)
- Claude Code chat interface
- `<C-c>c` - Toggle chat
- `<C-c>a` - Actions menu
- `<C-c>s` - Send selection

---

### Navigation & Movement

**harpoon** (`harpoon.lua`)
- Quick file jumping with persistent marks
- `<leader>a` - Add file
- `<C-e>` - Toggle menu
- `<C-f>`, `<C-t>`, `<C-n>`, `<C-g>` - Jump to files 1-4

**hop.nvim** (`hop.lua`)
- Fast within-buffer navigation
- `s` - Hop to word
- `<leader>hS` - Hop to bigram
- `<leader>hl` - Hop to line
- `<leader>hc` - Hop to camelCase
- `<leader>hn` - Hop to treesitter nodes

**leap.nvim** (`leap.lua`)
- Cross-window jumping
- `S` - Leap forward
- `<leader>lS` - Leap across windows
- `<leader>lr` - Remote leap

**vim-tmux-navigator** (`tmux.lua`)
- Seamless tmux/nvim pane navigation
- `<C-h/j/k/l>` - Navigate directions
- `<C-\>` - Previous pane

---

### AI Coding Assistants

**claudecode.nvim** (`claudecode.lua`)
- Claude Code integration with diff management
- `<C-a>c` - Toggle Claude Code
- `<C-a>f` - Focus chat
- `<C-a>r` - Resume session
- `<C-a>C` - Continue
- `<C-a>y` - Accept diff
- `<C-a>n` - Deny diff

**avante.nvim** (`avante.lua`)
- Alternative Claude integration via ACP
- Extensive UI for AI conversations

**opencode.lua** (`opencode.lua`)
- Custom opencode integration (currently disabled)
- Integration work in progress - see OPENCODE_INTEGRATION_PLAN.md

> **Note:** Multiple AI assistants are configured. `claudecode.nvim` and `avante.nvim` are active.

---

### Development & Debugging

**nvim-dap** (`dap.lua`)
- Debug Adapter Protocol client
- `dr` - Continue/Start debugging
- `<leader>do` - Step over
- `<leader>di` - Step into
- `<leader>dO` - Step out
- `<leader>db` - Toggle breakpoint
- `<leader>dB` - Conditional breakpoint
- `<leader>dU` - Toggle UI
- `<leader>dx` - Close UI
- `<leader>dR` - Open REPL

**dap-python** (`dap.lua`)
- Python debugging adapter
- FastAPI/uvicorn configuration included
- Custom breakpoint symbols: 🔴 🟡 ❌

**neotest** (`neotest.lua`)
- Test framework with pytest adapter
- `<leader>tr` - Run nearest test
- `<leader>tf` - Run file tests
- `<leader>td` - Debug test
- `<leader>tt` - Toggle summary
- `<leader>to` - Toggle output panel

**neotest-python** (`neotest.lua`)
- pytest adapter with conda environment support

---

### Database Tools

**vim-dadbod** (`vimdadbod.lua`)
- Database connection interface
- Commands: `:DB`, `:DBExec`

**vim-dadbod-ui** (`vimdadbodui.lua`)
- Database browser UI
- Commands: `:DBUI`, `:DBUIToggle`, `:DBUIAddConnection`

**vim-dadbod-completion** (`vimdadbod.lua`)
- SQL auto-completion
- Triggers on sql, mysql, plsql filetypes

---

### REPL & Terminal

**vim-slime** (`slime.lua`)
- Send code to REPL
- Target: Neovim terminal
- IPython support with cell markers (`# %%`)
- Cell navigation utilities

**vim-floaterm** (`floaterm.lua`)
- Floating terminal windows
- `<leader>ft` - Toggle float terminal

---

### Python Development

**venv-selector.nvim** (`venv-selector.lua`)
- Virtual environment switcher
- Searches conda envs in `/opt/homebrew/anaconda3/envs`
- `<leader>vs` - Select venv
- `<leader>vc` - Cached venv selection

---

### Code Navigation

**nvim-navbuddy** (`nvimbuddy.lua`)
- LSP-powered code structure navigator
- `<leader>vn` - Open navbuddy
- `<leader>vN` - Focus parent nodes

**nvim-navic** (`nvimbuddy.lua`)
- Breadcrumb component for navbuddy
- Auto-attaches to LSP buffers

---

### UI & Visual

**tokyonight.nvim** (`colorscheme.lua`)
- Color scheme (moon style)
- Custom Tree-sitter highlight groups configured
- Explicit colors for variables, functions, keywords, etc.

**markview.nvim** (`markview.lua`)
- Markdown preview and rendering
- Loads on markdown filetypes

---

### Git

**neogit** (`neogit.lua`)
- Magit-like git interface
- Dependencies: telescope, diffview
- `<leader>gg` - Open neogit

---

### Other

**leetcode.nvim** (`leetcode.lua`)
- LeetCode problem solving integration

---

## Key Keybindings

### General Navigation
- `H` / `L` - Jump to line start/end
- `K` / `J` - Move lines up/down (visual mode)
- `kj` - Escape terminal mode (context-aware)

### File & Search
- `<leader>fw` - Grep search
- `<leader>fz` - Fuzzy find in current buffer

### Terminal
- `<leader>ft` - Toggle floating terminal
- `<leader>gg` - Open lazygit
- `[c` / `]c` - Navigate terminal buffers

### Comments
- `<leader>/` - Toggle comment

### Tabs
- `<leader>tn` - New tab

---

## Plugin Dependencies & Interactions

### LSP Ecosystem
```
nvim-lspconfig
  ├─ nvim-dap (debugging)
  ├─ neotest (test discovery)
  ├─ venv-selector (Python env detection)
  └─ nvim-navbuddy (code navigation)
```

### Completion & Syntax
```
nvim-treesitter (primary highlighting)
  ├─ LSP integration
  ├─ neotest (test parsing)
  ├─ codecompanion (context awareness)
  └─ flash/hop (smart jumping)

nvim-cmp (completion)
  └─ Enhanced by codecompanion, avante
```

### AI Assistants
```
claudecode.nvim → snacks.nvim
avante.nvim → plenary, nui, cmp, snacks, telescope
codecompanion.nvim → treesitter, plenary
```

### Development Stack
```
nvim-dap (debugger)
  ├─ dap-python (Python adapter)
  └─ neotest
       └─ neotest-python (pytest)
```

### Database
```
vim-dadbod (core)
  ├─ vim-dadbod-ui (interface)
  └─ vim-dadbod-completion (SQL completion)
```

---

## Python-Specific Configuration

### LSP Configuration
- **pyright** with basic type checking mode
- Semantic tokens disabled (autocmds force Tree-sitter highlighting)

### Environment Management
- Conda environment auto-detection
- venv-selector searches `/opt/homebrew/anaconda3/envs`

### Debugging
- DAP configured for Python with debugpy
- FastAPI/uvicorn launch configuration
- Custom breakpoint symbols

### REPL Workflow
- vim-slime configured for IPython
- Cell markers: `# %%`
- Send code blocks to Neovim terminal

---

## Design Patterns

### Lazy Loading
Most plugins use event-based or command-based loading to reduce startup time

### Leader Key Organization
- `<leader>c` - Code actions
- `<leader>d` - Debug
- `<leader>v` - View/Navigate
- `<leader>h` - Hop navigation
- `<leader>l` - Leap navigation
- `<leader>t` - Tests/Tabs/Terminal
- `<leader>f` - Find/Files

### Mode-Aware Keybindings
Different behaviors in normal, insert, visual, and terminal modes

### Context Awareness
- Terminal escape (`kj`) disabled in lazygit, Telescope, toggleterm
- Tree-sitter for semantic analysis
- LSP diagnostics integration

---

## Active Development

### Current Status
- **Modified:** lazy-lock.json, opencode.lua
- **Deleted:** claude.lua (old plugin)
- **New:** claudecode.lua, codecomp.lua, copilot.lua

### Integration Project
See `OPENCODE_INTEGRATION_PLAN.md` for details on merging opencode implementations:
- Goal: Combine quick context injection with full buffer UI
- Status: opencode.lua currently commented out
- Active: claudecode.nvim and avante.nvim provide Claude integration

---

## Notable Workflows

### Quick File Navigation
1. Mark important files with Harpoon (`<leader>a`)
2. Jump instantly with `<C-f/t/n/g>`
3. Use hop (`s`) for within-file jumps
4. Use leap (`S`) for cross-window jumps

### REPL-Driven Development
1. Open IPython in terminal
2. Use `# %%` to mark code cells
3. Send cells to REPL with vim-slime
4. Debug with DAP when needed

### Test-Driven Development
1. Write tests in pytest format
2. Run nearest test: `<leader>tr`
3. Debug failing test: `<leader>td`
4. View summary: `<leader>tt`

### AI-Assisted Coding
1. Toggle Claude Code: `<C-a>c`
2. Send code context: `<C-c>s`
3. Accept/deny suggestions: `<C-a>y` / `<C-a>n`
4. Use multiple AI backends as needed

### Database Work
1. Toggle DBUI: `:DBUIToggle`
2. Connect to database
3. Browse schema and execute queries
4. SQL completion available in query buffers

---

## Requirements

- Neovim >= 0.9.0
- Python 3 with debugpy for debugging
- Conda or virtualenv for Python environments
- Git for version control
- Optional: tmux for terminal multiplexing
- Optional: GitHub Copilot account
- Optional: Claude API key for AI features

---

## Installation

1. Clone this config to `~/.config/nvim/`
2. Launch Neovim - Lazy.nvim will auto-install
3. Run `:Lazy sync` to install all plugins
4. Restart Neovim

---

## Customization

### Adding New Plugins
Create a new file in `lua/plugins/` with the plugin specification:

```lua
return {
  "author/plugin-name",
  config = function()
    -- Plugin configuration
  end,
}
```

Lazy.nvim will automatically detect and load it.

### Modifying Keybindings
Edit `lua/config/keymaps.lua` to add or change keybindings.

### Adjusting LSP
Edit `lua/plugins/lsp.lua` to add new language servers or modify configurations.

---

## Troubleshooting

### Tree-sitter Highlighting Not Working
- Run `:TSUpdate` to update parsers
- Check `:TSInstallInfo` for installation status

### LSP Not Attaching
- Verify language server installed: `:LspInfo`
- Check Python environment with venv-selector

### Tests Not Discovered
- Ensure pytest installed in active venv
- Check neotest output: `<leader>to`

### Debugging Not Starting
- Verify debugpy installed: `pip install debugpy`
- Check DAP configuration: `:lua require('dap').configurations`

---

## License

Personal configuration - use freely and adapt to your needs.
# nvim-config
