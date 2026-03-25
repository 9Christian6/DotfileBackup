-- local navic = require("nvim-navic")
-- 
-- navic.setup({
--   highlight = true,
--   separator = " > ",
--   depth_limit = 10,
-- })
-- 
-- local function navic_location()
--   if navic.is_available() then
--     return navic.get_location()
--   end
--   return "navic not available"
-- end
-- 
-- require("lualine").setup({
--   sections = {
--     lualine_c = {
--       { "filename" },
--       {
-- 	navic_location,
-- 	cond = function()
-- 	  return navic.is_available()
-- 	end,
--       },
--     },
--   },
-- })

local navic = require("nvim-navic")

navic.setup({
  highlight = true,
  separator = " > ",
  depth_limit = 10,
})

local function navic_location()
  if navic.is_available() then
    return navic.get_location()
  end
  return ""
end

require("lualine").setup({
  sections = {
    lualine_c = {
      {
        "filename",
        path = 1, -- show path relative to current working directory
      },
      {
        navic_location,
        cond = function()
          return navic.is_available()
        end,
      },
    },
  },
})
