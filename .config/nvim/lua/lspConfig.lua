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
