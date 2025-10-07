local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Define which LSP servers you want to use
local servers = { "clangd", "texlab" }

local lspconfig = require('lspconfig')

-- Define on_attach before using it
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Optional: Add keymaps or other buffer-local settings here
end

-- Setup Clangd
lspconfig.clangd.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        editsNearCursor = true
      }
    }
}

-- Setup TexLab
lspconfig.texlab.setup {
    capabilities = capabilities,
    on_attach = on_attach,
}

-- Setup Anakin (Python)
lspconfig.anakin_language_server.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  cmd = { "/home/christian/Opt/PythonEnvs/LSP/bin/anakinls" },
  filetypes = { "python" },
  root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
  settings = {
    anakinls = {
      diagnostic_on_change = true,
      help_on_hover = true,
      mypy_enabled = true,
      yapf_style_config = "pep8",
    }
  }
}

