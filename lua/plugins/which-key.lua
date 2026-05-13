return {
  "folke/which-key.nvim",
  lazy = false,
  opts = {
    preset = "helix",
    delay = 0,
    triggers = {
      { "<leader>", mode = { "n", "v" } },
      { "<auto>", mode = "nxso" },
    },
    spec = {
      {
        mode = { "n", "v" },
        { "<leader>a", group = "AI" },
        { "<leader>b", group = "Buffers" },
        { "<leader>c", group = "Code" },
        { "<leader>d", group = "Database" },
        { "<leader>f", group = "Find / Format" },
        { "<leader>g", group = "Git" },
        { "<leader>gc", group = "Changes" },
        { "<leader>gr", group = "Reviews" },
        { "<leader>h", group = "Harpoon" },
        { "<leader>l", group = "LSP" },
        { "<leader>q", group = "Quit" },
        { "<leader>s", group = "Search" },
        { "<leader>sn", group = "Noice" },
        { "<leader>n", group = "Neotest" },
        { "<leader>t", group = "Telescope" },
        { "<leader>w", group = "Windows" },
        { "<leader>y", group = "Yank" },
        { "[", group = "Previous" },
        { "]", group = "Next" },
        { "g", group = "Goto" },
        { "z", group = "Fold" },
      },
    },
  },
  keys = {
    {
      "<leader>fk",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Show Buffer Keymaps",
    },
  },
}
