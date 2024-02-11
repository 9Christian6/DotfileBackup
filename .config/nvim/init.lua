--////////////////////////////////////////////////////////////////////////////
--set variables
--////////////////////////////////////////////////////////////////////////////
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.path = vim.opt.path + "**"
vim.opt.wildmenu = true
vim.opt.mouse = a


--////////////////////////////////////////////////////////////////////////////
--call vim Plug
--////////////////////////////////////////////////////////////////////////////
local Plug = vim.fn['plug#']
vim.call('plug#begin')
	Plug 'nvim-tree/nvim-web-devicons' -- optional
	Plug 'nvim-tree/nvim-tree.lua'
    	Plug 'joshdick/onedark.vim'
	Plug 'karb94/neoscroll.nvim'
	Plug 'vimlab/split-term.vim'
vim.call('plug#end')

--////////////////////////////////////////////////////////////////////////////
--set colorscheme
--////////////////////////////////////////////////////////////////////////////
vim.cmd('colorscheme onedark')

--////////////////////////////////////////////////////////////////////////////
--nvim-tree begin
--////////////////////////////////////////////////////////////////////////////
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true

local function my_on_attach(bufnr)
  local api = require "nvim-tree.api"

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- custom mappings
    -- vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
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
--////////////////////////////////////////////////////////////////////////////
--smooth scrolling begin
--////////////////////////////////////////////////////////////////////////////
require('neoscroll').setup({
    easing_function = "quadratic" -- Default easing function
    -- Set any other options as needed
})

local t = {}
-- Syntax: t[keys] = {function, {function arguments}}
-- Use the "sine" easing function
t['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '350', [['sine']]}}
t['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '350', [['sine']]}}
-- Use the "circular" easing function
t['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']]}}
t['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '500', [['circular']]}}
-- Pass "nil" to disable the easing animation (constant scrolling speed)
t['<C-y>'] = {'scroll', {'-0.10', 'false', '100', nil}}
t['<C-e>'] = {'scroll', { '0.10', 'false', '100', nil}}
-- When no easing function is provided the default easing function (in this case "quadratic") will be used
t['zt']    = {'zt', {'300'}}
t['zz']    = {'zz', {'300'}}
t['zb']    = {'zb', {'300'}}

require('neoscroll.config').set_mappings(t)

--////////////////////////////////////////////////////////////////////////////
-- automatically closing nvim-tree if buffer is closed
--////////////////////////////////////////////////////////////////////////////
local function tab_win_closed(winnr)
  local api = require"nvim-tree.api"
  local tabnr = vim.api.nvim_win_get_tabpage(winnr)
  local bufnr = vim.api.nvim_win_get_buf(winnr)
  local buf_info = vim.fn.getbufinfo(bufnr)[1]
  local tab_wins = vim.tbl_filter(function(w) return w~=winnr end, vim.api.nvim_tabpage_list_wins(tabnr))
  local tab_bufs = vim.tbl_map(vim.api.nvim_win_get_buf, tab_wins)
  if buf_info.name:match(".*NvimTree_%d*$") then            -- close buffer was nvim tree
    -- Close all nvim tree on :q
    if not vim.tbl_isempty(tab_bufs) then                      -- and was not the last window (not closed automatically by code below)
      api.tree.close()
    end
  else                                                      -- else closed buffer was normal buffer
    if #tab_bufs == 1 then                                    -- if there is only 1 buffer left in the tab
      local last_buf_info = vim.fn.getbufinfo(tab_bufs[1])[1]
      if last_buf_info.name:match(".*NvimTree_%d*$") then       -- and that buffer is nvim tree
        vim.schedule(function ()
          if #vim.api.nvim_list_wins() == 1 then                -- if its the last buffer in vim
            vim.cmd "quit"                                        -- then close all of vim
          else                                                  -- else there are more tabs open
            vim.api.nvim_win_close(tab_wins[1], true)             -- then close only the tab
          end
        end)
      end
    end
  end
end

vim.api.nvim_create_autocmd("WinClosed", {
  callback = function ()
    local winnr = tonumber(vim.fn.expand("<amatch>"))
    vim.schedule_wrap(tab_win_closed(winnr))
  end,
  nested = true
})

--////////////////////////////////////////////////////////////////////////////
-- Set Leader
--////////////////////////////////////////////////////////////////////////////
vim.g.mapleader = "\\"

--////////////////////////////////////////////////////////////////////////////
-- Set Keybinds / Keybinds
--////////////////////////////////////////////////////////////////////////////
-- Integrated terminal stuff
vim.api.nvim_set_keymap(
	"n",
	"<LEADER>t",
	":set splitbelow<CR>:10Term<CR>",
	--":set splitbelow :vsplit term://zsh<CR>I",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"t",
	"<Esc>",
	"<C-\\><C-n>",
	{noremap = true}
)

-- Write Quit hotkeys
vim.api.nvim_set_keymap(
	"n",
	"<LEADER>w",
	":w<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>q",
	":q<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<LEADER>wq",
	":wq<CR>",
	{noremap = true}
)

-- Format hotkey
vim.api.nvim_set_keymap(
	"n",
	"<LEADER>f",
	"gg=G<CR>",
	{noremap = true}
)

-- Remap for browsing in big text blocks
vim.api.nvim_set_keymap(
	"n",
	"j",
	"gj",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"k",
	"gk",
	{noremap = true}
)

-- Colored column end
-- Changed vim.opt.cc = 80

-- FILE BROWSING:
-- Tweaks for browsing
vim.g.netrw_banner = 0        -- disable annoying banner
vim.g.netrw_browse_split = 4  -- open in prior window
vim.g.netrw_altv = 1          -- open splits to the right
vim.g.netrw_liststyle = 3     -- tree view
-- Changed vim.g.netrw_list_hide = netrw_gitignore#Hide()
-- Changed vim.g.netrw_list_hide. = ',\(^\|\s\s\)\zs\.\S\+'

-- NOW WE CAN:
-- - :edit a folder to open a file browser
-- - <CR>/v/t to open in an h-split/v-split/tab
-- - check |netrw-browse-maps| for more mappings

--VIMTEX CONFIGURATION BEGIN

--Ignore Warnings
-- let g:vimtex_quickfix_enabled = 0

-- This is necessary for VimTeX to load properly. The "indent" is optional.
--- Note that most plugin managers will do this automatically.
-- filetype plugin indent on

-- This enables Vim's and neovim's syntax-related features. Without this, some
-- VimTeX features will not work (see ":help vimtex-requirements" for more
-- info).
vim.g.syntax = enable

-- Viewer options: One may configure the viewer either by specifying a built-in
-- viewer method:
-- let g:vimtex_view_method = 'okular'

-- Or with a generic interface:
--Open nerdtree on F6
vim.api.nvim_set_keymap(
	"n",
	"<F6>",
	":NvimTreeToggle<CR>",
	{noremap = true}
)

-- Changed vim.api.nvim_set_keymap(
-- Changed 	"n",
-- Changed 	"<Esc>",
-- Changed 	"<C-\><C-n>",
-- Changed 	{noremap = true}
-- Changed )

-- Changed vim.opt.g:NERDTreeMapCustomOpen = "l"
-- Changed vim.opt.g:NERDTreeMapCloseDir = "h"

-- Changed source $HOME/.config/nvim/vim-plug/plugins.vim


