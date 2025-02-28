-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true
-- disable annoying banner
vim.g.netrw_banner = 0        
-- open in prior window
vim.g.netrw_browse_split = 4  
-- open splits to the right
vim.g.netrw_altv = 1          
-- tree view
vim.g.netrw_liststyle = 3     

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
    vim.keymap.set('n', '<C-l>', api.tree.change_root_to_node,        opts('Up'))
    vim.keymap.set('n', '<C-h>', api.node.navigate.parent_close,        opts('Up'))
    vim.keymap.set('n', 'l', api.node.open.edit,        opts('Up'))
    vim.keymap.set('n', 'h', api.node.navigate.parent_close,        opts('Up'))
    vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
    vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
end

-- empty setup using defaults
require("nvim-tree").setup({
  on_attach = my_on_attach,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})
