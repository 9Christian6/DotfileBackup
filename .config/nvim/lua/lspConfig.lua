local capabilities = require('cmp_nvim_lsp').default_capabilities()
local servers = { "clangd" }
local lspconfig = require('lspconfig')
lspconfig.clangd.setup({
    capabilities = capabilities,
    offsetEncoding = { "utf-8", "utf-16" },
    textDocument = {
      completion = {
        editsNearCursor = true
      }
    }
})

local on_attach = function(clinet, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end
