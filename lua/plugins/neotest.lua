return {
  "nvim-neotest/neotest",
  event = "VeryLazy",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "vim-test/vim-test",
    "jfpedroza/neotest-elixir",
    "nvim-neotest/neotest-jest",
    "nvim-neotest/neotest-plenary",
    "nvim-neotest/neotest-vim-test",
  },
  keys = {
    {
      "<leader>nrt",
      function()
        require("neotest").run.run()
      end,
      desc = "neotest run test...",
    },
    {
      "<leader>nrf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "neotest run file",
    },
    {
      "<leader>ns",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "neotest summary",
    },
    {
      "<leader>no",
      function()
        require("neotest").output.open({
          enter = true,
          auto_close = true,
          last_run = true,
        })
      end,
      desc = "neotest output",
    },
  },
  opts = function()
    return {
      output = {
        open_on_run = false,
      },
      status = {
        signs = true,
      },
      adapters = {
        require("neotest-jest")({
          cwd = function()
            return vim.fn.getcwd()
          end,
          env = {
            LOG_SILENT = "true",
          },
        }),
        require("neotest-elixir")({}),
        require("neotest-plenary"),
        require("neotest-vim-test")({
          ignore_file_types = {
            "elixir",
            "javascript",
            "javascriptreact",
            "lua",
            "typescript",
            "typescriptreact",
          },
        }),
      },
    }
  end,
  config = function(_, opts)
    require("neotest").setup(opts)
  end,
}
