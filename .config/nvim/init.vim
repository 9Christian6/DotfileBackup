set number
set relativenumber
set path+=**
set wildmenu
"set mouse=nicr
set mouse=a
map <ScrollWheelUp> CTRL-E
map <ScrollWheelDown> CTRL-Y

" SET LEADER
let mapleader = '\'

nmap <LEADER>w :w<CR>
nmap <LEADER>q :q<CR>
nmap <LEADER>wq :wq<CR>
nnoremap <leader>f gg=G<CR>

" Remap for browsing in big text blocks
nmap j gj
nmap k gk

"Colored column end
set cc=80

" FILE BROWSING:
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" NOW WE CAN:
" - :edit a folder to open a file browser
" - <CR>/v/t to open in an h-split/v-split/tab
" - check |netrw-browse-maps| for more mappings

"VIMTEX CONFIGURATION BEGIN

"Ignore Warnings
let g:vimtex_quickfix_enabled = 0

" This is necessary for VimTeX to load properly. The "indent" is optional.
" Note that most plugin managers will do this automatically.
filetype plugin indent on

" This enables Vim's and neovim's syntax-related features. Without this, some
" VimTeX features will not work (see ":help vimtex-requirements" for more
" info).
syntax enable

" Viewer options: One may configure the viewer either by specifying a built-in
" viewer method:
" let g:vimtex_view_method = 'okular'

" Or with a generic interface:
let g:vimtex_view_general_viewer = 'okular'
let g:vimtex_view_general_options = '--unique file:@pdf\#src:@line@tex'

" VimTeX uses latexmk as the default compiler backend. If you use it, which is
" strongly recommended, you probably don't need to configure anything. If you
" want another compiler backend, you can change it as follows. The list of
" supported backends and further explanation is provided in the documentation,
" see ":help vimtex-compiler".
let g:vimtex_compiler_method = 'latexrun'

" Most VimTeX mappings rely on localleader and this can be changed with the
" following line. The default is usually fine and is the symbol "\".
" let maplocalleader = ","

nmap <LEADER>h :w<CR> :VimtexCompile<CR>

"VIMTEX CONFIGURATION END

"Open nerdtree on F6
nmap <F6> :NERDTreeToggle<CR>

"Integrated Terminal stuff
:tnoremap <Esc> <C-\><C-n>

let g:NERDTreeMapCustomOpen = "l"
let g:NERDTreeMapCloseDir = "h"

source $HOME/.config/nvim/vim-plug/plugins.vim

colorscheme onedark
