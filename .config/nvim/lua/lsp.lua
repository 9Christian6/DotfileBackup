local M = {}
local border_style = "rounded"

local function setup_float_style()
  local normal = vim.api.nvim_get_hl(0, { name = "Normal", link = false })
  local normal_bg = normal.bg
  local normal_fg = normal.fg

  vim.api.nvim_set_hl(0, "NormalFloat", { bg = normal_bg, fg = normal_fg })
  vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#FF00FF", bg = normal_bg })
  vim.api.nvim_set_hl(0, "FloatTitle", { fg = "#FF00FF", bg = normal_bg, bold = true })

  vim.api.nvim_set_hl(0, "Pmenu", { bg = normal_bg, fg = normal_fg })
  vim.api.nvim_set_hl(0, "PmenuSbar", { bg = normal_bg })
  vim.api.nvim_set_hl(0, "PmenuThumb", { bg = "#FF00FF" })

  pcall(function()
    vim.o.winborder = border_style
  end)
end

local function setup_lsp_handlers()
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = border_style,
  })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = border_style,
  })
end

local function make_capabilities()
  local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok then
    return cmp_nvim_lsp.default_capabilities()
  end
  return vim.lsp.protocol.make_client_capabilities()
end

local function on_attach(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  local ok, navic = pcall(require, "nvim-navic")
  if ok and client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

local lspconfig_util = require("lspconfig.util")
local unpack = table.unpack or unpack
local biome_root_files = {
  "biome.json",
  "biome.jsonc",
  "biome.config.js",
  "package.json",
  "package-lock.json",
  "yarn.lock",
  "pnpm-lock.yaml",
  "bun.lock",
  "bun.lockb",
  ".git",
}

local function biome_root_dir(fname)
  local matcher = lspconfig_util.root_pattern(unpack(biome_root_files))
  return matcher(fname) or vim.fs.dirname(fname)
end

local server_overrides = {
  pyright = function(config)
    return vim.tbl_deep_extend("force", config, {
      settings = {
        python = {
          analysis = {
            typeCheckingMode = "basic",
          },
        },
      },
    })
  end,
  ruff = function(config)
    config.on_attach = function(client, bufnr)
      client.server_capabilities.hoverProvider = false
      client.server_capabilities.documentFormattingProvider = false
      on_attach(client, bufnr)
    end
    return config
  end,
  bacon_ls = function(config)
    config.filetypes = { "rust" }
    return config
  end,
  biome = function(config)
    config.cmd = { "biome", "lsp-proxy" }
    config.filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }
    config.root_dir = function(bufnr, on_dir)
      local fname = vim.api.nvim_buf_get_name(bufnr)
      if fname == "" then
        return
      end
      on_dir(biome_root_dir(fname))
    end
    config.workspace_required = true
    return config
  end,
}

local function apply_server_override(server_name, base_config)
  local override = server_overrides[server_name]
  if not override then
    return base_config
  end
  return override(base_config)
end

local function setup_diagnostics()
  vim.diagnostic.config({
    float = {
      border = border_style,
      source = "always",
      header = "",
      prefix = "",
    },
  })
end

local ensured_servers = {
  "clangd",
  "texlab",
  "pyright",
  "ruff",
  "biome",
}

local function define_server_configs(capabilities)
  for _, server_name in ipairs(ensured_servers) do
    local server_config = apply_server_override(server_name, {
      capabilities = capabilities,
      on_attach = on_attach,
    })
    vim.lsp.config(server_name, server_config)
  end
end

local function setup_mason(capabilities)
  require("mason").setup({
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
    },
  })

  local mason_lspconfig = require("mason-lspconfig")
  mason_lspconfig.setup({
    ensure_installed = ensured_servers,
    automatic_enable = true,
  })

  define_server_configs(capabilities)
end

function M.setup()
  local float_style_group = vim.api.nvim_create_augroup("FloatStyle", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = float_style_group,
    callback = setup_float_style,
  })
  setup_float_style()
  setup_lsp_handlers()
  setup_diagnostics()
  setup_mason(make_capabilities())
end

return M
