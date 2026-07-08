return {
  -- LSP configuration
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    opts = {
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = {
          spacing = 4,
          source = "if_many",
          prefix = "●",
        },
        severity_sort = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "⛔",
            [vim.diagnostic.severity.WARN] = "⚠️",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = "ℹ️",
          },
        },
      },
      inlay_hints = {
        enabled = true,
        exclude = { "vue" },
      },
      codelens = {
        enabled = false,
      },
      servers = {
        bashls = {},
        biome = {},
        clangd = {},
        dockerls = {},
        jsonls = {},
        pyright = {},
        elixirls = {},
        terraformls = {},
        -- Native TypeScript 7 LSP (installed by Mason as `tsgo`).
        tsgo = {},
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              doc = {
                privateName = { "^_" },
              },
              hint = {
                enable = true,
                setType = false,
                paramType = true,
                paramName = "Disable",
                semicolon = "Disable",
                arrayIndex = "Disable",
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- Setup diagnostics
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      vim.api.nvim_create_user_command("LspInfo", function()
        vim.cmd("checkhealth vim.lsp")
      end, { desc = "Show LSP health/info" })

      -- Setup keymaps on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = args.buf, desc = desc })
          end

          map("gd", vim.lsp.buf.definition, "Go to Definition")
          map("gr", vim.lsp.buf.references, "References")
          map("K", vim.lsp.buf.hover, "Hover")
          map("gK", vim.lsp.buf.signature_help, "Signature Help")
          map("<c-k>", vim.lsp.buf.signature_help, "Signature Help", "i")
          map("<leader>lca", vim.lsp.buf.code_action, "Code Action", { "n", "v" })
          map("<leader>lR", vim.lsp.buf.rename, "Rename Symbol")

          -- Enable inlay hints if supported
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if
            client
            and client:supports_method("textDocument/inlayHint")
            and opts.inlay_hints.enabled
            and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[args.buf].filetype)
          then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })

      -- Setup LSP servers using modern Neovim 0.11+ API
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      for server, config in pairs(opts.servers) do
        config.capabilities = capabilities
        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end
    end,
  },

  -- Mason
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = {
        -- LSP servers (using Mason package names)
        "bash-language-server",
        "clangd",
        "dockerfile-language-server",
        "json-lsp",
        "elixir-ls",
        "lua-language-server",
        "pyright",
        "terraform-ls",
        "tsgo",
        -- Formatters
        "biome",
        "clang-format",
        "prettierd",
        "jq",
        "stylua",
        "shfmt",
        -- Linters
        "eslint_d",
        "jsonlint",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Mason LSP Config
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      -- LSP servers are enabled explicitly in opts.servers above.
      automatic_enable = false,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  -- Blink completion
  {
    "Saghen/blink.cmp",
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    version = "*",
    opts = {
      keymap = {
        preset = "default",
        ["<C-y>"] = { "accept", "fallback" },
        ["<CR>"] = {},
      },
      appearance = {
        use_nvim_cmp_as_default = false,
        nerd_font_variant = "mono",
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
      completion = {
        accept = {
          auto_brackets = {
            enabled = true,
          },
        },
        menu = {
          draw = {
            treesitter = { "lsp" },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 200,
        },
        ghost_text = {
          enabled = vim.g.ai_cmp or false,
        },
      },
      signature = { enabled = true },
    },
  },
}
