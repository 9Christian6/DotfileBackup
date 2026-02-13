local lspconfig = require("lspconfig")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local common = require("lsp.common")

-- texlab
lspconfig.texlab.setup({
  capabilities = capabilities,
  on_attach = common.on_attach,
})

-- anakin
lspconfig.anakin_language_server.setup({
  capabilities = capabilities,
  on_attach = common.on_attach,
  cmd = { "/home/christian/Opt/PythonEnvs/myVirtualEnv/bin/anakinls" },
  filetypes = { "python" },
  root_dir = lspconfig.util.root_pattern(
    "pyproject.toml",
    "setup.py",
    "setup.cfg",
    "requirements.txt",
    ".git"
  ),
})
