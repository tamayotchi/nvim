local conform = "stevearc/conform.nvim"

local function web_formatters(bufnr)
  local conform_ok, conform_mod = pcall(require, "conform")
  if not conform_ok then
    return { "prettierd", "prettier", stop_after_first = true }
  end

  if conform_mod.get_formatter_info("biome", bufnr).available then
    return { "biome", "prettierd", "prettier", stop_after_first = true }
  end

  return { "prettierd", "prettier", stop_after_first = true }
end

return {
  {
    conform,
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
    end,
    opts = {
      default_format_opts = {
        lsp_format = "fallback",
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
      notify_on_error = true,
      notify_no_formatters = true,
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
        },
      },
      formatters_by_ft = {
        cpp = { "clang-format" },
        css = web_formatters,
        html = web_formatters,
        javascript = web_formatters,
        javascriptreact = web_formatters,
        json = web_formatters,
        jsonc = web_formatters,
        lua = { "stylua" },
        markdown = web_formatters,
        scss = web_formatters,
        typescript = web_formatters,
        typescriptreact = web_formatters,
        yaml = { "prettierd", "prettier", stop_after_first = true },
        elixir = { "mix" },
        heex = { "mix" },
        terraform = { "terraform_fmt" },
      },
    },
    keys = {
      {
        "<leader>fb",
        function()
          require("conform").format({ async = true, lsp_format = "fallback" })
        end,
        desc = "[f]ormat [b]uffer",
      },
    },
  },
}
