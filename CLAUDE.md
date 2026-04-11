# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

This is a modern Neovim configuration using the Lazy.nvim plugin manager with a modular architecture:

- **`init.lua`**: Entry point that bootstraps Lazy.nvim and loads the configuration
- **`lua/config/`**: Core configuration modules
  - `init.lua`: Loads keymaps and options
  - `keymaps.lua`: Global key mappings and leader key setup
  - `options.lua`: Vim options and settings
- **`lua/plugins/`**: Individual plugin configurations as separate modules
- **`lazy-lock.json`**: Lock file for reproducible plugin versions

### Plugin Architecture

Each plugin is configured in its own file under `lua/plugins/`. The configuration follows a consistent pattern:
- Plugin specifications with dependencies
- Options/configuration tables
- Key mappings specific to the plugin
- Setup functions with custom configuration

### Key Plugin Categories

- **LSP**: `lsp.lua` - Language Server Protocol with mason, mason-lspconfig, and blink.cmp
- **Formatting**: `formatter.lua` - conform.nvim with mason-conform for code formatting
- **Linting**: `linter.lua` - nvim-lint with mason-nvim-lint for code linting
- **Fuzzy Finding**: `telescope.lua` - Telescope with fzf and ui-select extensions
- **Git Integration**: `gitsigns.lua`, `fugitive.lua` - Git status, blame, and commands
- **AI Assistance**: `copilot.lua` - GitHub Copilot integration

## Development Commands

### Formatting
- `<leader>fb` - Format current buffer using conform.nvim
- Supported formatters: clang-format (C++), prettierd (HTML/TypeScript/YAML), jq (JSON), stylua (Lua), eslint_d (TypeScript)

### LSP Operations
- `<leader>ld` - Go to definition
- `<leader>la` - Code actions  
- `<leader>lr` - Find references
- `<leader>lR` - Rename symbol
- `]d` / `[d` - Next/previous diagnostic

### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep
- `<leader><space>` - Find buffers
- `<leader>fh` - Search help tags
- `<leader>lds` - LSP document symbols
- `<leader>lws` - LSP workspace symbols

### Competitive Programming Keybinds
- `<leader>yy` - Yank entire file to system clipboard
- `<leader>yc` - Change entire file content
- `<leader>yp` - Yank file path to clipboard
- `<leader>r` - Compile template.cpp and run with input file

### Quickfix Navigation
- `<leader>co` - Open quickfix window
- `<leader>cc` - Close quickfix window  
- `<leader>cn` / `<leader>cp` - Next/previous error

## Configuration Management

When making changes to this configuration:

1. **Plugin Management**: Add new plugins to `lua/plugins/` as separate files
2. **Mason Dependencies**: Update ensure_installed lists in formatter.lua, linter.lua, and lsp.lua when adding new tools
3. **LSP Setup**: The LSP configuration auto-setups servers via mason-lspconfig handlers
4. **Key Mappings**: Global mappings go in `lua/config/keymaps.lua`, plugin-specific ones in their respective plugin files

## Plugin Dependencies

Critical dependency relationships:
- `mason.nvim` must be setup before `mason-lspconfig.nvim` (see lsp.lua:25)
- Telescope extensions (fzf, ui-select) are loaded after telescope setup
- LSP capabilities are provided by blink.cmp for autocompletion

## Common Issues

- Mason-lspconfig errors: Ensure mason.setup() is called before mason-lspconfig.setup()
- Formatter/linter not working: Check if tools are installed via Mason (:Mason command)
- LSP not attaching: Verify server is in ensure_installed list and properly configured
