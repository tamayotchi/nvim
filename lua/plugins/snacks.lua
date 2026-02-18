return {
  "folke/snacks.nvim",
  lazy = false,
  opts = {
    lazygit = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = false }, -- we set this in options.lua
    words = { enabled = true },
    image = { enabled = false },
    terminal = { enabled = false },
    explorer = { enabled = true },
  },
  keys = {
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit (cwd)",
    },
    {
      "<leader>e",
      function()
        Snacks.explorer()
      end,
      desc = "File Explorer",
    },
  },
}
