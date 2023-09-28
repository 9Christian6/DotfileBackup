" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    " i3config syntax
    Plug 'mboughaba/i3config.vim'
    " Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    " File Explorer
    Plug 'preservim/nerdtree'
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
    "C++ Autocompletion
    "Plug 'Valloric/YouCompleteMe' 
    "Colorschemes
    Plug 'joshdick/onedark.vim'
    "Compile Latex code
    Plug 'lervag/vimtex'
    "Cmake integration
    Plug 'cdelledonne/vim-cmake'
    "Firefox vim integration
    Plug 'glacambre/firenvim'
    call plug#end()
