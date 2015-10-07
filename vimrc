filetype plugin indent on

set nocompatible
set paste
set foldmethod=indent

" use these to persist folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

syntax on
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
autocmd FileType python setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType haskell setlocal noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 expandtab

" keep cursor in the middle of the screen
" set scrolloff=999
" set relativenumber

set ruler

set hlsearch
set wrapscan

runtime macros/matchit.vim

" lets you use j/k to naturally navigate wrapped lines
noremap j gj
noremap k gk

noremap gj j
noremap gk k

" easier escape sequences
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

" fun! ICanHazTabs()
"   vimgrep '\t' %:p
" endfun

" file is larger than 10mb
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
  autocmd BufReadPre * call HandleLargeFiles()
augroup END

function HandleLargeFiles()
  let f=getfsize(expand("<afile>"))
  if f > g:LargeFile || f == -2
    call PromptOpenLargeFile()
  endif
endfunction

function PromptOpenLargeFile()
  let choice = confirm("The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB - Do you want to open it?", "&Yes\n&No", 2)
  if choice == 0 || choice == 2
    :q
  endif
endfunction
