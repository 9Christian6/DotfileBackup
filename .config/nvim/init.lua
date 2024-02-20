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
	Plug 'lervag/vimtex'
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
	Plug 'nvim-treesitter/nvim-treesitter'
    	Plug 'cdelledonne/vim-cmake'
    	Plug 'Valloric/YouCompleteMe' 
	Plug 'lambdalisue/suda.vim'
vim.call('plug#end')

--////////////////////////////////////////////////////////////////////////////
--Telescope
--////////////////////////////////////////////////////////////////////////////
local function find_in_current()
	require('telescope.builtin').find_files( { cwd = vim.fn.expand('%:p:h') })
end

--////////////////////////////////////////////////////////////////////////////
--set colorscheme
--////////////////////////////////////////////////////////////////////////////
vim.cmd('colorscheme onedark')
vim.cmd('hi Search guibg=#B31B97')

--////////////////////////////////////////////////////////////////////////////
--nvim-tree
--////////////////////////////////////////////////////////////////////////////
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

--////////////////////////////////////////////////////////////////////////////
--smooth scrolling
--////////////////////////////////////////////////////////////////////////////
require('neoscroll').setup({
    easing_function = "quadratic" -- Default easing function
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
--vimtex 
--////////////////////////////////////////////////////////////////////////////
vim.g.syntax = enable

--////////////////////////////////////////////////////////////////////////////
-- Set Leader
--////////////////////////////////////////////////////////////////////////////
vim.g.mapleader = "\\"

--////////////////////////////////////////////////////////////////////////////
-- Set Keybinds / Keybinds
--////////////////////////////////////////////////////////////////////////////

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
	":Telescope find_files hidden=true cwd=.<CR>",
	{noremap = true}
)

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

vim.api.nvim_set_keymap(
	"n",
	"<Leader>l",
	":VimtexCompile<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<Leader>g",
	":YcmCompleter GoTo<CR>",
	{noremap = true}
)

vim.api.nvim_set_keymap(
	"n",
	"<F6>",
	":NvimTreeToggle<CR>",
	{noremap = true}
)
