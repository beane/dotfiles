filetype plugin indent on
syntax enable
set nocompatible

" Install vim plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

" fuzzy finder settings
set path+=**
set wildmenu

set foldmethod=indent
set helpheight=999
set ruler
set nohlsearch
set wrapscan
set mouse=h " for neovim

" stops annoying time delay
set timeoutlen=1000 ttimeoutlen=0

" keep cursor in the middle of the screen
" set scrolloff=999
" set relativenumber

" tab logic
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

autocmd FileType html setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab
autocmd FileType python setlocal expandtab
autocmd FileType haskell setlocal tabstop=4 shiftwidth=4 softtabstop=4 expandtab
autocmd FileType ruby setlocal tabstop=2 shiftwidth=2 softtabstop=2 expandtab

runtime macros/matchit.vim

" use these to auto-open folds
autocmd BufEnter ?* silent! %foldopen!
autocmd BufEnter ?* silent! %foldopen!

" Tweaks for browsing
" thanks to https://github.com/mcantor/no_plugins/blob/0a313c353899d3d4e51b754b15027c4452120f79/no_plugins.vim#L120-L133
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
" let g:netrw_list_hide=netrw_gitignore#Hide()
" let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'

" lets you use j/k to navigate wrapped lines in a more natural way
noremap j gj
noremap k gk

noremap gj j
noremap gk k

" easier escape sequence
nnoremap ! :!

vnoremap 0 ^
nnoremap 0 ^

vnoremap ^ 0
nnoremap ^ 0

" better search
nnoremap / q/i
nnoremap q/ /

vnoremap / q/i
vnoremap q/ /

" better search
nnoremap : q:i
nnoremap q: :

vnoremap : q:i
vnoremap q: :

" quick save
nnoremap <C-s> :update<Enter>
vnoremap <C-s> :update<Enter>

nnoremap <Leader>c :call Comment(&ft)<CR>
vnoremap <Leader>c :call Comment(&ft)<CR>

" wiki
noremap <Leader>wj :VimwikiDiaryIndex<Enter>
noremap <Leader>wn :VimwikiMakeDiaryNote<Enter>

" if file is larger than 10mb
let g:LargeFile = 1024 * 1024 * 10
augroup LargeFile
    autocmd BufReadPre * call HandleLargeFiles()
augroup END

" shortcut to execute file
noremap <Leader>e :call Execute()<CR>
fun! Execute()
  :execute 'update'
  :execute '! ./%'
endfun

set tabline=%!MyTabLine()
set showtabline=2

" could be interesting
" Ctrl j/k to navigate horizontal splits
" map <C-J> <C-W>j<C-W>_
" map <C-K> <C-W>k<C-W>_
" set wmh=0
" Ctrl h/l to navigate vertical splits
" map <C-H> <C-W>h<C-W><bar>
" map <C-L> <C-W>l<C-W><bar>
" set wmw=0

" Function Definitions

" simple_comment.vim v0.1
" toggles line comments
" boisvertmaxime@gmail.com
fun! Comment(ft)
    " get cursor position
    let lineNum = line(".")
    let colNum = col(".")

    let dic = {'cpp':'//','tex':'%','java':'//','haskell':'--','c':'//', 'ruby':'#','vim':'"','sh':'#','bash':'#','javascript':'//','sql':'#','python':'#'}
    " insert comment character
    if has_key(dic, a:ft)
        let c = dic[a:ft]
        exe "s@^@".c." @ | s@^".c." ".c." @@e"
    endif

    " reset cursor
    call cursor(lineNum, colNum)
endfun

function! HandleLargeFiles()
    let f=getfsize(expand("<afile>"))
    if f > g:LargeFile || f == -2
        call PromptOpenLargeFile()
    endif
endfunction

function! PromptOpenLargeFile()
    let choice = confirm("The file is larger than " . (g:LargeFile / 1024 / 1024) . " MB - Do you want to open it?", "&Yes\n&No", 2)
    if choice == 0 || choice == 2
        :q
    endif
endfunction

" from :help setting-tabline
function! MyTabLine()
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
  return s
endfunction

" with help from http://vim.wikia.com/wiki/Show_tab_number_in_your_tab_line
function! MyTabLabel(n)
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

