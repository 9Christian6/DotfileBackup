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
	Plug 'nvim-lua/plenary.nvim'
	Plug 'nvim-telescope/telescope.nvim'
    	Plug 'cdelledonne/vim-cmake'
	Plug 'lambdalisue/suda.vim'
	Plug 'jiangmiao/auto-pairs'
	Plug 'mbbill/undotree'
	Plug 'ThePrimeagen/harpoon'
	Plug 'williamboman/mason.nvim'
	Plug 'williamboman/mason-lspconfig.nvim'
	Plug 'neovim/nvim-lspconfig'
	Plug 'hrsh7th/cmp-nvim-lsp'
	Plug 'hrsh7th/cmp-buffer'
	Plug 'hrsh7th/cmp-path'
	Plug 'hrsh7th/cmp-cmdline'
	Plug 'hrsh7th/nvim-cmp'
	Plug 'hrsh7th/cmp-vsnip'
	Plug 'hrsh7th/vim-vsnip'
	Plug 'L3MON4D3/LuaSnip'
	Plug 'saadparwaiz1/cmp_luasnip'
	Plug 'rafamadriz/friendly-snippets'
	Plug 'junegunn/fzf'
	Plug 'junegunn/fzf.vim'
	Plug 'lervag/vimtex'
	Plug 'stevearc/conform.nvim' -- , { 'for': ['python', 'lua', 'javascript'] }
	Plug 'frabjous/knap'
	Plug 'MeanderingProgrammer/render-markdown.nvim'
	Plug 'kdheepak/cmp-latex-symbols'
vim.call('plug#end')
