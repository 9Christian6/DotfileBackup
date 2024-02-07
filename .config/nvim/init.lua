vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.path = vim.opt.path + "**"
vim.opt.wildmenu = true
vim.opt.mouse = a


local Plug = vim.fn['plug#']
vim.call('plug#begin')
	Plug 'nvim-tree/nvim-web-devicons' -- optional
	Plug 'nvim-tree/nvim-tree.lua'
    	Plug 'joshdick/onedark.vim'
	Plug 'karb94/neoscroll.nvim'
vim.call('plug#end')

-- Nvim-tree.lua begin
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
vim.opt.termguicolors = true
-- empty setup using defaults
require("nvim-tree").setup({
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
-- Nvim-tree.lua end

--smooth scrolling
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
--smooth scrolling end

-- SET LEADER
vim.g.mapleader = "\\"

-- vim.api.nvim_set_keymap("n", "<ScrollWheelUp>", "<C-y>", { noremap = true })
-- vim.api.nvim_set_keymap("n", "<ScrollWheelDown>", "<C-e>", { noremap = true })

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


vim.cmd('colorscheme onedark')
