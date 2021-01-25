call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'sainnhe/edge'
Plug 'artanikin/vim-synthwave84'

call plug#end()

set termguicolors
set path+=**

syntax on
set background=dark

let g:edge_style='neon'
" let g:edge_disable_italic_comment=1

autocmd BufWritePre * %s/\s\+$//e
colors synthwave84

set nu
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
set cindent
set smarttab
set breakindent

set hlsearch

set backspace=indent,eol,start
set clipboard=unnamed,unnamedplus

set ruler
set showcmd
set autoread

set incsearch
set ignorecase
set smartcase

nnoremap <Tab> >>_
nnoremap <S-Tab> <<_
inoremap <S-Tab> <C-D>
vnoremap <Tab> >gv
vnoremap <S-Tab> <gv
