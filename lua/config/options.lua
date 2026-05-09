-- LazyVim globals
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.autoformat = true

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true
opt.shiftround = true

-- Line wrapping
opt.wrap = false
opt.linebreak = true
opt.breakindent = true

-- Search settings
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = false

-- Cursor line
opt.cursorline = true
opt.scrolloff = 4
opt.sidescrolloff = 8

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.list = true
opt.fillchars = {
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Splits
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"

-- Folding
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldtext = ""

-- Status
opt.laststatus = 3
opt.showmode = false

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.pumblend = 10
opt.pumheight = 10

-- Behavior
opt.autoread = true
opt.autowrite = true
opt.confirm = true
opt.mouse = "a"
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.timeoutlen = 300

-- Clipboard
opt.clipboard = ""

-- Formatting
opt.formatexpr = "v:lua.vim.lsp.formatexpr()"
opt.formatoptions = "jcroqlnt"

-- Grep
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"

-- Misc
opt.inccommand = "nosplit"
opt.jumpoptions = "view"
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.smoothscroll = true
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.conceallevel = 2
opt.ruler = false

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

vim.cmd([[let g:netrw_bufsettings = "noma nomod nu nobl nowrap ro"]])
