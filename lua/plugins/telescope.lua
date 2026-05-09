local fzf = "nvim-telescope/telescope-fzf-native.nvim"
local ui_select = "nvim-telescope/telescope-ui-select.nvim"

return {
  {
    fzf,
    build = "make",
    lazy = true,
  },
  {
    ui_select,
    lazy = true,
  },
  {
    "nvim-telescope/telescope.nvim",
    version = false, -- use HEAD instead of old 0.1.x
    dependencies = {
      "nvim-lua/plenary.nvim",
      fzf,
      ui_select,
    },
    opts = {
      defaults = {
        mappings = {
          i = {
            ["<C-d>"] = "results_scrolling_down",
            ["<C-u>"] = "results_scrolling_up",

            ["<Down>"] = "preview_scrolling_down",
            ["<Up>"] = "preview_scrolling_up",
          },
        },
      },
      pickers = {
        git_branches = {
          mappings = {
            i = {
              ["<C-d>"] = "results_scrolling_down",
            },
            n = {
              ["d"] = "git_delete_branch",
            },
          },
        },
        buffers = {
          mappings = {
            i = {
              ["<C-d>"] = "delete_buffer",
            },
          },
        },
      },
    },
    keys = function()
      local builtin = require("telescope.builtin")

      return {
        { "<leader><space>", builtin.buffers, desc = "Buffers" },
        { "<leader>ff", builtin.find_files, desc = "Find Files" },
        { "<leader>fg", builtin.live_grep, desc = "Live Grep" },

        { "<leader>?", builtin.oldfiles, desc = "Recent Files" },
        {
          "<leader>/",
          function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
              winblend = 10,
              previewer = false,
            }))
          end,
          desc = "Search in Current Buffer",
        },
        { "<leader>gcf", builtin.git_status, desc = "Changed Files" },
      }
    end,
    config = function(_, opts)
      local telescope = require("telescope")

      telescope.setup(opts)
      pcall(telescope.load_extension, "fzf")
      pcall(telescope.load_extension, "ui-select")
    end,
  },
}
