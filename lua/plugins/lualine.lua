return {
  "nvim-lualine/lualine.nvim",
  -- See `:help lualine.txt`
  opts = {
    options = {
      icons_enabled = false,
      theme = "auto",
      component_separators = "|", -- fix when font with icons is working properly
      section_separators = "", -- fix when font with icons is working properly
    },
  },
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
