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
      local omarchy_theme_dir = vim.fn.expand("~/.config/omarchy/current/theme")

      local function read_omarchy_colors()
        local colors = {}
        local path = omarchy_theme_dir .. "/colors.toml"

        if vim.fn.filereadable(path) == 0 then
          return colors
        end

        for _, line in ipairs(vim.fn.readfile(path)) do
          local key, value = line:match('^%s*([%w_]+)%s*=%s*"(#[%x]+)"')
          if key and value then
            colors[key] = value
          end
        end

        return colors
      end

      local function is_light_hex(hex)
        local r, g, b = hex:match("#(%x%x)(%x%x)(%x%x)")
        if not r then
          return false
        end

        local luminance = (0.2126 * tonumber(r, 16) + 0.7152 * tonumber(g, 16) + 0.0722 * tonumber(b, 16)) / 255
        return luminance > 0.5
      end

      local theme_colors = read_omarchy_colors()
      local is_light = vim.fn.filereadable(omarchy_theme_dir .. "/light.mode") == 1
        or (theme_colors.background and is_light_hex(theme_colors.background))

      vim.o.background = is_light and "light" or "dark"
      opts.flavour = is_light and "latte" or "mocha"

      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")

      -- Helix/Omarchy-like transparent palette. Pull colors from the active
      -- Omarchy theme so Neovim stays readable when switching between dark and
      -- light modes while keeping the terminal background visible.
      local c = {
        bg = "NONE",
        fg = theme_colors.foreground or (is_light and "#4c4f69" or "#e6e6e6"),
        float_bg = theme_colors.background or (is_light and "#eff1f5" or "#000000"),
        selection_fg = theme_colors.selection_foreground or (is_light and "#eff1f5" or "#000000"),
        selection_bg = theme_colors.selection_background or (is_light and "#dc8a78" or "#ffcc66"),
        color0 = theme_colors.color0 or (is_light and "#bcc0cc" or "#262626"),
        color1 = theme_colors.color1 or (is_light and "#d20f39" or "#e65c5c"),
        color2 = theme_colors.color2 or (is_light and "#40a02b" or "#66cc66"),
        color3 = theme_colors.color3 or (is_light and "#df8e1d" or "#ffcc66"),
        color4 = theme_colors.color4 or (is_light and "#1e66f5" or "#6699ff"),
        color5 = theme_colors.color5 or (is_light and "#ea76cb" or "#cc66cc"),
        color6 = theme_colors.color6 or (is_light and "#179299" or "#66cccc"),
        color8 = theme_colors.color8 or (is_light and "#7c7f93" or "#404040"),
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
      hl("Search", { fg = c.selection_fg, bg = c.selection_bg })
      hl("IncSearch", { fg = c.selection_fg, bg = c.selection_bg })
      hl("Pmenu", { fg = c.fg, bg = c.float_bg })
      hl("PmenuSel", { fg = c.selection_fg, bg = c.selection_bg })
      hl("WinSeparator", { fg = c.color8, bg = c.bg })

      hl("TelescopeNormal", { fg = c.fg, bg = c.bg })
      hl("TelescopeBorder", { fg = c.color8, bg = c.bg })
      hl("TelescopeTitle", { fg = c.fg, bg = c.color0 })
      hl("TelescopePromptNormal", { fg = c.fg, bg = c.bg })
      hl("TelescopePromptBorder", { fg = c.color8, bg = c.bg })
      hl("TelescopePromptPrefix", { fg = c.color1, bg = c.bg })
      hl("TelescopeResultsNormal", { fg = c.fg, bg = c.bg })
      hl("TelescopeResultsBorder", { fg = c.color8, bg = c.bg })
      hl("TelescopePreviewNormal", { fg = c.fg, bg = c.bg })
      hl("TelescopePreviewBorder", { fg = c.color8, bg = c.bg })
      hl("TelescopeSelection", { fg = c.fg, bg = c.color0 })
      hl("TelescopeMatching", { fg = c.color4, bold = true })

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
