filetype plugin indent on

set nocompatible

syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" keep cursor in the middle of the screen
" set scrolloff=999
" set relativenumber

set ruler

set hlsearch
set wrapscan

runtime macros/matchit.vim

noremap j gj
noremap k gk

noremap gj j
noremap gk k

" easier escape sequences
inoremap ;; <Esc>
vnoremap ;; <Esc>
nnoremap ! :!

" quick save
nnoremap s :update<Enter>

" simple_comment.vim v0.1
" toggles line comments
" boisvertmaxime@gmail.com
fun! Comment(ft)
" get cursor position
  let lineNum = line(".")
  let colNum = col(".")

  let dic = {'cpp':'//','tex':'%','java':'//','haskell':'--','c':'//', 'ruby':'#','vim':'"','sh':'#','bash':'#','javascript':'//'}
  if has_key(dic, a:ft)
    let c = dic[a:ft]
    exe "s@^@".c." @ | s@^".c." ".c." @@e"
  endif

" reset cursor
  call cursor(lineNum, colNum)
endfun

nnoremap <silent> # :call Comment(&ft)<CR>
vnoremap <silent> # :call Comment(&ft)<CR>

" kill spaces/tabs at the end of every line
" fun! KillWhitespace()
"   let lineNum = line(".")
"   let colNum = col(".")
"   %s/\s*$//g
"   call cursor(lineNum, colNum)
" endfun

" autocmd BufWritePre * call KillWhitespace()
