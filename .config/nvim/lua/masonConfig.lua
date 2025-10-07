local M = {
  "williamboman/mason.nvim",
  config = function()
    -- import mason
    local mason = require("mason")

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })
  end,
}
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "ltex" }
})
return M
