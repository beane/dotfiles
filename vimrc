filetype plugin indent on

syntax on

" paste allow the ctrl char to be used in mappings while in insert mode
" set paste
set nocompatible
set foldmethod=indent
set helpheight=999
set ruler
set hlsearch
set wrapscan
set mouse=h " for neovim

" keep cursor in the middle of the screen
" set scrolloff=999
" set relativenumber

" tab logic
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
autocmd FileType python setlocal noexpandtab " use expandtab if needed
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

" use these to persist folds
autocmd BufWinLeave ?* mkview!
autocmd BufWinEnter ?* silent! loadview

runtime macros/matchit.vim

" lets you use j/k to naturally navigate wrapped lines
noremap j gj
noremap k gk

noremap gj j
noremap gk k

" easier escape sequences
vnoremap ;; <Esc>
nnoremap ! :!

" shortcut to execute file
nnoremap <C-E> :call Run()<CR>
fun! Run()
  :! ./%
endfun

" stops annoying time delay
set timeoutlen=1000 ttimeoutlen=0

" Ctrl j/k to navigate horizontal splits
" map <C-J> <C-W>j<C-W>_
" map <C-K> <C-W>k<C-W>_
" set wmh=0
" Ctrl h/l to navigate vertical splits
" map <C-H> <C-W>h<C-W><bar>
" map <C-L> <C-W>l<C-W><bar>
" set wmw=0

" quick save
nnoremap s :update<Enter>
" doesn't work when paste is enabled
inoremap <C-S> <C-O>:update<Enter>

" simple_comment.vim v0.1
" toggles line comments
" boisvertmaxime@gmail.com
fun! Comment(ft)
    " get cursor position
    let lineNum = line(".")
    let colNum = col(".")

    let dic = {'cpp':'//','tex':'%','java':'//','haskell':'--','c':'//', 'ruby':'#','vim':'"','sh':'#','bash':'#','javascript':'//','sql':'#'}
    " insert comment character
    if has_key(dic, a:ft)
        let c = dic[a:ft]
        exe "s@^@".c." @ | s@^".c." ".c." @@e"
    endif

    " reset cursor
    call cursor(lineNum, colNum)
endfun

nnoremap <silent> # :call Comment(&ft)<CR>
vnoremap <silent> # :call Comment(&ft)<CR>

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

" kill spaces/tabs at the end of every line
" fun! KillWhitespace()
"     let lineNum = line(".")
"     let colNum = col(".")
"     %s/\s*$//g
"     call cursor(lineNum, colNum)
" endfun

" autocmd BufWritePre * call KillWhitespace()

" fun! ICanHazTabs()
"     vimgrep '\t' %:p
" endfun

" from :help setting-tabline
function MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for viewing)
    let s .= '[' . (i + 1) . ']'

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= '%{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

" with help from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufnr = buflist[winnr - 1]
  let file = bufname(bufnr)
  let buftype = getbufvar(bufnr, 'buftype')

  if buftype == 'nofile'
    if file =~ '\/.'
      let file = substitute(file, '.*\/\ze.', '', '')
    endif
  else
    let file = fnamemodify(file, ':p:t')
  endif
  if file == ''
    let file = '[No Name]'
  endif
  return file
endfunction

set tabline=%!MyTabLine()
set showtabline=2

