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
        { "<leader>tr", builtin.resume, desc = "[t]elescope [r]esume" },
        { "<leader><space>", builtin.buffers, desc = "[<Space>] Find existing buffers" },

        -- File pickers
        { "<leader>ff", builtin.find_files, desc = "[s]earch [f]iles" },
        -- { "<leader>gf", builtin.git_files, desc = "[s]earch [g]it files" },
        { "<leader>fh", builtin.help_tags, desc = "[s]earch [h]elp" },

        -- Search pickers
        { "<leader>fg", builtin.live_grep, desc = "[l]ive [g]rep" },
        -- { "<leader>gw", builtin.grep_string, desc = "[g]rep [w]ord under cursor" },

        -- Git pickers
        -- { "<leader>gb", builtin.git_branches, desc = "[g]it [s]witch" },

        -- Document pickers
        { "<leader>lds", builtin.lsp_document_symbols, desc = "[l]sp [d]ocument [s]ymbols" },
        { "<leader>lws", builtin.lsp_dynamic_workspace_symbols, desc = "[l]sp [w]orkspace [s]ymbols" },

        -- I don't use these as often. Consider removing?
        { "<leader>?", builtin.oldfiles, desc = "[?] Find recently opened files" },
        {
          "<leader>/",
          function()
            -- You can pass additional configuration to telescope to change theme, layout, etc.
            builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
              winblend = 10,
              previewer = false,
            }))
          end,
          desc = "[/] Fuzzily search in current buffer",
        },
        { "<leader>gcf", builtin.git_status, desc = "[g]ithub [c]hanged [f]iles" },
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
