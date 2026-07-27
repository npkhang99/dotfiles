call plug#begin('~/.vim/plugged')

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'sonph/onehalf', { 'rtp': 'vim' }

call plug#end()

let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

set termguicolors
set path+=**

syntax on
set background=dark

let g:airline_theme='onehalfdark'

autocmd BufWritePre * %s/\s\+$//e
" Do not fail before vim-plug installs the theme on a new machine.
silent! colorscheme onehalfdark

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

" Match the zsh Ctrl+Backspace behavior (the terminal sends Ctrl+H).
inoremap <C-H> <C-W>

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
