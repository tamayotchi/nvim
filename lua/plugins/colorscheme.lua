local omarchy_current_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local omarchy_theme_roots = {
  vim.fn.expand("~/.local/share/omarchy/themes"),
  vim.fn.expand("~/.config/omarchy/themes"),
}

local function notify(message, level)
  vim.schedule(function()
    vim.notify(message, level or vim.log.levels.WARN, { title = "Omarchy colorscheme" })
  end)
end

local function has_omarchy_theme()
  return vim.fn.filereadable(omarchy_current_theme_file) == 1
end

local function theme_from_file(file)
  if vim.fn.filereadable(file) == 0 then
    return {}, {}
  end

  local ok, specs = pcall(dofile, file)
  if not ok then
    notify("Could not load " .. file .. ": " .. tostring(specs))
    return {}, {}
  end

  if type(specs) ~= "table" then
    notify(file .. " did not return a Lazy spec table")
    return {}, {}
  end

  local theme_specs = {}
  local lazyvim_opts = {}

  for _, spec in ipairs(specs) do
    if type(spec) == "table" and spec[1] == "LazyVim/LazyVim" then
      if type(spec.opts) == "table" then
        lazyvim_opts = vim.tbl_deep_extend("force", lazyvim_opts, spec.opts)
      end
    elseif type(spec) == "table" then
      -- Omarchy theme files are written as LazyVim specs. Reuse the theme
      -- plugin specs, but never import LazyVim itself into this config.
      table.insert(theme_specs, vim.deepcopy(spec))
    end
  end

  return theme_specs, lazyvim_opts
end

local function installable_theme_specs()
  local specs = {}
  local seen_files = {}

  local function add_file(file)
    file = vim.fn.fnamemodify(file, ":p")
    if seen_files[file] then
      return
    end
    seen_files[file] = true

    local theme_specs = theme_from_file(file)
    for _, spec in ipairs(theme_specs) do
      spec.lazy = true
      if spec.priority == nil then
        spec.priority = 1000
      end
      table.insert(specs, spec)
    end
  end

  for _, root in ipairs(omarchy_theme_roots) do
    for _, file in ipairs(vim.fn.globpath(root, "*/neovim.lua", false, true)) do
      add_file(file)
    end
  end

  -- Include the active theme too. This covers freshly-installed Omarchy themes
  -- that are already copied to ~/.config/omarchy/current/theme.
  add_file(omarchy_current_theme_file)

  return specs
end

local function plugin_name(spec)
  if type(spec.name) == "string" then
    return spec.name
  end

  if type(spec[1]) == "string" then
    return spec[1]:match("/([^/]+)$") or spec[1]
  end
end

local function load_plugins(plugins)
  if #plugins == 0 then
    return true
  end

  local ok, err = pcall(function()
    require("lazy").load({ plugins = plugins })
  end)

  if not ok then
    notify("Could not load colorscheme plugins: " .. tostring(err))
  end

  return ok
end

local function load_theme_plugins(theme_specs)
  local plugins = {}
  local seen = {}

  for _, spec in ipairs(theme_specs) do
    local name = plugin_name(spec)
    if name and not seen[name] then
      seen[name] = true
      table.insert(plugins, name)
    end
  end

  load_plugins(plugins)
end

local function apply_colorscheme(colorscheme)
  vim.o.termguicolors = true

  if type(colorscheme) == "function" then
    colorscheme()
    return
  end

  if type(colorscheme) == "string" and colorscheme ~= "" then
    vim.cmd.colorscheme(colorscheme)
    return
  end

  -- LazyVim's default colorscheme is TokyoNight moon.
  load_plugins({ "tokyonight.nvim" })
  vim.cmd.colorscheme("tokyonight")
end

local function apply_current_omarchy_theme()
  local theme_specs, lazyvim_opts = theme_from_file(omarchy_current_theme_file)
  load_theme_plugins(theme_specs)
  apply_colorscheme(lazyvim_opts.colorscheme)
end

local specs = {
  -- LazyVim default/fallback.
  {
    "folke/tokyonight.nvim",
    lazy = true,
    priority = 1000,
    opts = { style = "moon" },
  },
}

vim.list_extend(specs, installable_theme_specs())

table.insert(specs, {
  name = "omarchy-colorscheme-loader",
  dir = vim.fn.stdpath("config"),
  lazy = false,
  priority = 0,
  config = function()
    local omarchy_enabled = has_omarchy_theme()
    local ok, err = pcall(function()
      if omarchy_enabled then
        apply_current_omarchy_theme()
      else
        apply_colorscheme(nil)
      end
    end)

    if not ok then
      notify("Could not apply colorscheme: " .. tostring(err))
      load_plugins({ "tokyonight.nvim" })
      pcall(vim.cmd.colorscheme, "tokyonight")
    end

    local server
    if omarchy_enabled then
      local server_dir = (vim.env.XDG_RUNTIME_DIR or vim.fn.stdpath("run")) .. "/nvim-omarchy"
      vim.fn.mkdir(server_dir, "p")

      server = server_dir .. "/" .. vim.fn.getpid() .. ".pipe"
      pcall(vim.fn.delete, server)
      pcall(vim.fn.serverstart, server)
    end

    vim.api.nvim_create_user_command("OmarchyColorscheme", function()
      local reload_ok, reload_err = pcall(function()
        if has_omarchy_theme() then
          apply_current_omarchy_theme()
        else
          apply_colorscheme(nil)
        end
      end)
      if not reload_ok then
        notify("Could not reload colorscheme: " .. tostring(reload_err))
      end
    end, { desc = "Reload colorscheme from ~/.config/omarchy/current/theme/neovim.lua" })

    if server then
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          pcall(vim.fn.delete, server)
        end,
      })
    end
  end,
})

return specs
