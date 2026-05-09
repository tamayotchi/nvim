return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = function()
    return {
      {
        "<leader>ha",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Add File",
      },
      {
        "<C-e>",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Toggle Harpoon Menu",
      },
    }
  end,
  opts = {
    settings = {
      save_on_toggle = true,
      save_on_ui_close = true,
    },
  },
  config = function(_, opts)
    require("harpoon"):setup(opts)
  end,
}
