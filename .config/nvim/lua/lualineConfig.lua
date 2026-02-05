local navic = require('nvim-navic')

-- Define on_attach before using it
local on_attach = function(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end
  -- Optional: Add keymaps or other buffer-local settings here
end

-- Setup navic
navic.setup({
  highlight = true,
  separator = " > ",
  depth_limit = 0,
})

-- old setup
-- Setup lualine
-- local function lsp_attached()
--   return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
-- end
-- 
-- require("lualine").setup({
--   sections = {
--     lualine_c = {
--       { "filename" },
--       {
--         function()
--           return require("nvim-navic").get_location()
--         end,
--         cond = function()
--           return lsp_attached()
--             and require("nvim-navic").is_available()
--         end,
--       },
--     },
--   },
-- })
-- old setup

-- Helper: check if any LSP is attached
local function lsp_attached()
  return next(vim.lsp.get_clients({ bufnr = 0 })) ~= nil
end

-- Helper: get current function name from navic
-- local function current_function()
--   local navic = require("nvim-navic")
-- 
--   if not navic.is_available() then
--     return "Navic not available"
--   end
-- 
--   local data = navic.get_data()
--   if not data or #data == 0 then
--     return "No data from Navic"
--   end
-- 
--   -- Walk backwards to find the innermost function/method
--   for i = #data, 1, -1 do
--     local symbol = data[i]
--     if
--       symbol.kind == "Function"
--       or symbol.kind == "Method"
--       or symbol.kind == "Constructor"
--     then
--       return "f: " .. symbol.name
--     end
--   end
-- 
--   return "Function ended"
-- end

local function current_function()
  local navic = require("nvim-navic")

  if not navic.is_available() then
    return "Navic not available"
  end

  local data = navic.get_data()
  if not data or #data == 0 then
    return "No data available"
  end

  local SymbolKind = vim.lsp.protocol.SymbolKind

  for i = #data, 1, -1 do
    local symbol = data[i]
    if
      symbol.kind == SymbolKind.Function
      or symbol.kind == SymbolKind.Method
      or symbol.kind == SymbolKind.Constructor
    then
      return "󰡱 : " .. symbol.name
    end
  end

  return "Function ended"
end

require("lualine").setup({
  sections = {
    lualine_c = {
      { "filename" },
      {current_function},
      {
        current_function,
        cond = function()
          return lsp_attached()
            and require("nvim-navic").is_available()
            and current_function() ~= ""
        end,
      },
    },
  },
})
