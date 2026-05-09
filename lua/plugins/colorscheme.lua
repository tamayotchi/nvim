return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = { style = "moon" },
  },

  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,
    priority = 1000,
    opts = {
      transparent_background = true,
      term_colors = true,
      styles = {
        comments = { "italic" },
        conditionals = { "italic" },
        keywords = { "italic" },
        parameters = { "italic" },
      },
      lsp_styles = {
        underlines = {
          errors = { "undercurl" },
          hints = { "undercurl" },
          warnings = { "undercurl" },
          information = { "undercurl" },
        },
      },
      integrations = {
        blink_cmp = true,
        fidget = true,
        flash = true,
        gitsigns = true,
        harpoon = true,
        illuminate = true,
        indent_blankline = { enabled = true },
        lsp_trouble = true,
        mason = true,
        mini = true,
        noice = true,
        telescope = true,
        treesitter_context = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Helix/Omarchy-like transparent palette. The font is still owned by
      -- the terminal; these highlights remove Neovim's heavier Catppuccin
      -- backgrounds/bold styles so glyphs look closer to hx.
      local c = {
        bg = "NONE",
        fg = "#e6e6e6",
        color0 = "#262626",
        color1 = "#e65c5c",
        color2 = "#66cc66",
        color3 = "#ffcc66",
        color4 = "#6699ff",
        color5 = "#cc66cc",
        color6 = "#66cccc",
        color8 = "#404040",
      }

      local function hl(group, opts_hl)
        vim.api.nvim_set_hl(0, group, opts_hl)
      end

      hl("Normal", { fg = c.fg, bg = c.bg })
      hl("NormalNC", { fg = c.fg, bg = c.bg })
      hl("NormalFloat", { fg = c.fg, bg = c.bg })
      hl("FloatBorder", { fg = c.color8, bg = c.bg })
      hl("SignColumn", { fg = c.color8, bg = c.bg })
      hl("FoldColumn", { fg = c.color8, bg = c.bg })
      hl("EndOfBuffer", { fg = c.color8, bg = c.bg })
      hl("LineNr", { fg = c.color8, bg = c.bg })
      hl("CursorLineNr", { fg = c.fg, bg = c.bg })
      hl("CursorLine", { bg = c.color0 })
      hl("Visual", { bg = c.color0 })
      hl("Search", { fg = "#000000", bg = c.color3 })
      hl("IncSearch", { fg = "#000000", bg = c.color3 })
      hl("Pmenu", { fg = c.fg, bg = "#000000" })
      hl("PmenuSel", { fg = "#000000", bg = c.fg })
      hl("WinSeparator", { fg = c.color8, bg = c.bg })

      hl("Comment", { fg = c.color8, italic = true })
      hl("Keyword", { fg = c.color5 })
      hl("Conditional", { fg = c.color5, italic = true })
      hl("Repeat", { fg = c.color5, italic = true })
      hl("Statement", { fg = c.color5 })
      hl("Function", { fg = c.color4 })
      hl("Type", { fg = c.color3 })
      hl("Constant", { fg = c.color3 })
      hl("String", { fg = c.color2 })
      hl("Character", { fg = c.color6 })
      hl("Number", { fg = c.color3 })
      hl("Boolean", { fg = c.color3 })
      hl("Identifier", { fg = c.fg })
      hl("Operator", { fg = c.color6 })
      hl("Delimiter", { fg = c.color8 })
      hl("Special", { fg = c.color5 })
      hl("Directory", { fg = c.color4 })

      hl("@comment", { link = "Comment" })
      hl("@keyword", { fg = c.color5 })
      hl("@keyword.return", { fg = c.color5, italic = true })
      hl("@keyword.conditional", { fg = c.color5, italic = true })
      hl("@keyword.repeat", { fg = c.color5, italic = true })
      hl("@keyword.function", { fg = c.color5 })
      hl("@function", { fg = c.color4 })
      hl("@function.builtin", { fg = c.color4 })
      hl("@function.call", { fg = c.color4 })
      hl("@method", { fg = c.color4 })
      hl("@method.call", { fg = c.color4 })
      hl("@type", { fg = c.color3 })
      hl("@type.builtin", { fg = c.color5 })
      hl("@constructor", { fg = c.color4 })
      hl("@constant", { fg = c.color3 })
      hl("@constant.builtin", { fg = c.color3 })
      hl("@number", { fg = c.color3 })
      hl("@boolean", { fg = c.color3 })
      hl("@string", { fg = c.color2 })
      hl("@character", { fg = c.color6 })
      hl("@variable", { fg = c.fg })
      hl("@variable.parameter", { fg = c.color5, italic = true })
      hl("@variable.builtin", { fg = c.color1 })
      hl("@property", { fg = c.color4 })
      hl("@field", { fg = c.color4 })
      hl("@punctuation", { fg = c.color8 })
      hl("@punctuation.bracket", { fg = c.color8 })
      hl("@punctuation.delimiter", { fg = c.color8 })
      hl("@operator", { fg = c.color6 })
      hl("@tag", { fg = c.color4 })
      hl("@tag.attribute", { fg = c.color3 })
      hl("@namespace", { fg = c.color3, italic = true })

      hl("@lsp.type.function", { link = "@function" })
      hl("@lsp.type.method", { link = "@function" })
      hl("@lsp.type.interface", { link = "@type" })
      hl("@lsp.type.class", { link = "@type" })
      hl("@lsp.type.type", { link = "@type" })
      hl("@lsp.type.parameter", { link = "@variable.parameter" })
      hl("@lsp.type.property", { link = "@property" })
      hl("@lsp.mod.readonly", {})
      hl("@lsp.mod.declaration", {})
      hl("@lsp.mod.defaultLibrary", {})
    end,
  },
}
