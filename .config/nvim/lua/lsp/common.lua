local navic = require("nvim-navic")

local M = {}

M.on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
end

return M
