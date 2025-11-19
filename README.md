# Neovim Configuration

Modern Neovim setup for full-stack development with LSP, autocompletion, and Git integration.

## Structure

```
~/.config/nvim/
├── init.lua                 # Entry point
├── lua/
│   ├── config/
│   │   ├── options.lua      # Editor settings
│   │   └── keymaps.lua      # Key bindings
│   └── plugins/
│       ├── completion.lua   # nvim-cmp + LuaSnip
│       ├── diagnostics.lua  # Error display (Trouble)
│       ├── editor.lua       # Telescope + Treesitter
│       ├── git.lua          # Gitsigns
│       ├── lsp.lua          # Language servers (Mason)
│       └── ui.lua           # Theme + Neo-tree
└── lazy-lock.json           # Plugin versions
```

## Features

- **LSP**: TypeScript, Vue, HTML, CSS, JSON, Tailwind, Python, Java
- **Autocompletion**: Context-aware with icons
- **Syntax**: Treesitter highlighting
- **File Explorer**: Neo-tree with custom folder colors
- **Fuzzy Finder**: Telescope
- **Git Integration**: Inline blame + change indicators
- **Diagnostics**: Inline errors with Trouble panel

## Requirements

- Neovim ≥ 0.10
- Git
- Node.js (for LSP servers)
- [Nerd Font](https://www.nerdfonts.com/) (for icons)

## Installation

```bash
# Backup existing config
mv ~/.config/nvim ~/.config/nvim.backup

# Clone this config
git clone https://github.com/JuansesDev/dotfiles-nvim.git ~/.config/nvim

# Start Neovim (plugins auto-install)
nvim
```

## Key Bindings

| Key | Action |
|-----|--------|
| `<leader>e` | Toggle file explorer |
| `<leader>ff` | Find files |
| `<leader>fg` | Search text |
| `<leader>xx` | Show diagnostics |
| `<leader>gp` | Preview git hunk |
| `<leader>gb` | Toggle git blame |
| `<C-h/j/k/l>` | Navigate splits |

**Leader key**: `Space`

## Customization

Edit files in `lua/config/` for general settings, or `lua/plugins/` for plugin-specific config.
