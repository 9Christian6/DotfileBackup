local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lspconfig = require('lspconfig')
local common = require("lsp.common")

-- Setup Clangd
-- lspconfig.clangd.setup {
--     capabilities = capabilities,
--     on_attach = common.on_attach,
--     offsetEncoding = { "utf-8", "utf-16" },
--     textDocument = {
--       completion = {
--         editsNearCursor = true
--       }
--     }
-- }

-- Setup TexLab
lspconfig.texlab.setup {
    capabilities = capabilities,
    on_attach = common.on_attach,
}

-- Setup Anakin (Python)
lspconfig.anakin_language_server.setup {
  capabilities = capabilities,
  on_attach = common.on_attach,
  cmd = { "/home/christian/Opt/PythonEnvs/myVirtualEnv/bin/anakinls" },
  
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
