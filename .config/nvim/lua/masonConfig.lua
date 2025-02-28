local M = {}
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "ltex" }
})
return M
