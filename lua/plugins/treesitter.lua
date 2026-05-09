local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "diff",
  "eex",
  "elixir",
  "heex",
  "html",
  "javascript",
  "jsdoc",
  "json",
  "lua",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
}

local autotag_filetypes = {
  "eex",
  "heex",
  "html",
  "javascriptreact",
  "typescriptreact",
  "xml",
}

local function install_missing_parsers(treesitter)
  local installed = treesitter.get_installed()
  local missing = vim.tbl_filter(function(parser)
    return not vim.list_contains(installed, parser)
  end, ensure_installed)

  if #missing == 0 then
    return
  end

  vim.schedule(function()
    treesitter.install(missing)
  end)
end

local function has_query(lang, query)
  return #vim.api.nvim_get_runtime_file(string.format("queries/%s/%s.scm", lang, query), false) > 0
end

local function start_treesitter(args)
  local ok = pcall(vim.treesitter.start, args.buf)
  if not ok then
    return
  end

  local lang = vim.treesitter.language.get_lang(vim.bo[args.buf].filetype)
  if lang and has_query(lang, "indents") then
    vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

local function setup_treesitter(_, opts)
  local ok, treesitter = pcall(require, "nvim-treesitter")
  if not ok then
    vim.notify("nvim-treesitter is not available yet. Run :Lazy sync", vim.log.levels.WARN)
    return
  end

  treesitter.setup(opts)
  vim.treesitter.language.register("json", { "jsonc" })

  install_missing_parsers(treesitter)

  local group = vim.api.nvim_create_augroup("treesitter-autostart", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = "*",
    callback = start_treesitter,
  })
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    opts = {
      install_dir = vim.fn.stdpath("data") .. "/site",
    },
    config = setup_treesitter,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = autotag_filetypes,
    opts = {},
  },
}
