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
  vim.keymap.set('n', '<C-l>', api.tree.change_root_to_node,        opts('Change root to node'))
  vim.keymap.set('n', '<C-h>', api.node.navigate.parent_close,        opts('Close parent node'))
  vim.keymap.set('n', 'l', api.node.open.edit,        opts('Open in current buffer'))
  vim.keymap.set('n', 'L', function()
    api.node.open.vertical()
    api.tree.focus()
  end,        opts('Open in vertical split'))
  vim.keymap.set('n', 'h', api.node.navigate.parent_close,        opts('Close parent node'))
  vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
  vim.keymap.set('n', 'A', api.tree.expand_all, opts('Expand All'))
end

-- empty setup using defaults
require("nvim-tree").setup({
  reload_on_bufenter = true,
  sync_root_with_cwd = true,
  respect_buf_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = true,
    ignore_list = {},
  },
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

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  desc = "Open Nvim-Tree on the given directory from command line",
  group = vim.api.nvim_create_augroup("NvimTreeSetGivenDirectory", { clear = true }),
  pattern = "*",
  command = "if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') | wincmd p | enew | execute 'cd '.argv()[0] | endif",
})

vim.api.nvim_create_autocmd("QuitPre", {
  callback = function()
    local invalid_win = {}
    local wins = vim.api.nvim_list_wins()
    for _, w in ipairs(wins) do
      local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(w))
      if bufname:match("NvimTree_") ~= nil then
	table.insert(invalid_win, w)
      end
    end
    if #invalid_win == #wins - 1 then
      -- Should quit, so we close all invalid windows.
      for _, w in ipairs(invalid_win) do vim.api.nvim_win_close(w, true) end
    end
  end
})
