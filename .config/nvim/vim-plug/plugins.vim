" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    "File tree
    Plug 'nvim-tree/nvim-web-devicons' " optional
    Plug 'nvim-tree/nvim-tree.lua'
    " i3config syntax
    Plug 'mboughaba/i3config.vim'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    " Plug 'preservim/nerdtree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    " Auto completion
    Plug 'codota/TabNine'
    " Writing with sudo permissions
    Plug 'lambdalisue/suda.vim'
    "Autocompletion
    Plug 'vim-scripts/AutoComplPop'
    "Clang-autoformat
    Plug 'rhysd/vim-clang-format'
    "Language server for C++
    Plug 'Valloric/YouCompleteMe' 
    "Colorschemes
    Plug 'joshdick/onedark.vim'
    "Compile Latex code
    " Plug 'lervag/vimtex'
    "onedark colortheme
    Plug 'joshdick/onedark.vim'
    "Cmake integration
    Plug 'cdelledonne/vim-cmake'
    "Firefox vim integration
    Plug 'glacambre/firenvim'
    "YouCompleteMe
    Plug 'ycm-core/YouCompleteMe'
call plug#end()
