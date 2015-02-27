filetype plugin indent on

set nocompatible

syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set nonumber
set ruler

set hlsearch
set wrapscan

runtime macros/matchit.vim

nnoremap j gj
nnoremap k gk

"easier escape sequences
inoremap ;; <Esc>
vnoremap ;; <Esc>
nnoremap ; :
nnoremap ! :!

"quick save
nnoremap s :w<Enter>

