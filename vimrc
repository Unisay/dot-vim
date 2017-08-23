syntax on
filetype on
filetype plugin indent on

" Color theme {{{
set background=light
let g:lightline = {
      \ 'colorscheme': 'PaperColor',
      \ }
colorscheme PaperColor
" }}}

" Return to last edit position when opening files {{{
augroup last_edit
  autocmd!
  autocmd BufReadPost *
       \ if line("'\"") > 0 && line("'\"") <= line("$") |
       \   exe "normal! g`\"" |
       \ endif
augroup END
" }}}

" Folding {{{
set foldmethod=indent
set foldnestmax=10
set foldlevelstart=99
set foldcolumn=0

augroup vimrcFold
  " fold vimrc itself by categories
  autocmd!
  autocmd FileType vim set foldmethod=marker
  autocmd FileType vim set foldlevel=0
augroup END

" }}}

" Commenting {{{

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" }}}

autocmd BufWritePre * :%s/\s\+$//e " Remove trailing whitespace on save

" Custom keymappins {{{

let mapleader = "\<Space>"
set tm=2000 " Leader key timeout

nmap <leader>qq :wqa<CR>
nmap <leader>w :w<CR>

" Cancel a search with Escape
nnoremap <silent> <Esc> :nohlsearch<Bar>:echo<CR>

" Open window splits in various places
nmap <leader>sh :leftabove  vnew<CR>
nmap <leader>sl :rightbelow vnew<CR>
nmap <leader>sk :leftabove  new<CR>
nmap <leader>sj :rightbelow new<CR>

" Open file prompt with current path
nmap <leader>e :e <C-R>=expand("%:p:h") . '/'<CR>

" Edit config in the new tab
nmap <leader>v :tabnew $MYVIMRC<CR>
nmap <F4> :source $MYVIMRC<CR>

" Syntastic
nmap <leader>sc    :call SyntasticCheck()<CR>
nmap <leader>se    :Errors<CR>
" }}}

" psc-ide-vim {{{
au FileType purescript nmap <buffer> <silent> <leader>t    :<C-U>call PSCIDEtype(PSCIDEgetKeyword(), v:true)<CR>
au FileType purescript nmap <buffer> <silent> <leader>T    :<C-U>call PSCIDEaddTypeAnnotation(matchstr(getline(line(".")), '^\s*\zs\k\+\ze'))<CR>
au FileType purescript nmap <buffer> <silent> <leader><CR> :<C-U>call PSCIDEapplySuggestion()<CR>
au FileType purescript nmap <buffer> <silent> <leader>a    :<C-U>call PSCIDEaddTypeAnnotation()<CR>
au FileType purescript nmap <buffer> <silent> <leader>i    :<C-U>call PSCIDEimportIdentifier(PSCIDEgetKeyword())<CR>
au FileType purescript nmap <buffer> <silent> <leader>r    :<C-U>call PSCIDEload(0,"")<CR>
au FileType purescript nmap <buffer> <silent> <leader>p    :<C-U>call PSCIDEpursuit(PSCIDEgetKeyword())<CR>
au FileType purescript nmap <buffer> <silent> <leader>C    :<C-U>call PSCIDEcaseSplit("!")<CR>
au FileType purescript nmap <buffer> <silent> <leader>f    :<C-U>call PSCIDEaddClause("")<CR>
au FileType purescript nmap <buffer> <silent> <leader>qa   :<C-U>call PSCIDEaddImportQualifications()<CR>
au FileType purescript nmap <buffer> <silent> ]d           :<C-U>call PSCIDEgoToDefinition("", PSCIDEgetKeyword())<CR>
" }}}

" purescript-vim
let purescript_indent_if    = 3
let purescript_indent_case  = 5
let purescript_indent_let   = 4
let purescript_indent_where = 6
let purescript_indent_do    = 3
let purescript_indent_in    = 1
let purescript_indent_dot   = v:true

" Session management {{{
function! SessionFilename()
  return $HOME.'/.vim/session.save'
endfunction

function! SessionSave()
  execute "mksession! ".SessionFilename()
endfunction

function! SessionLoad()
  execute "source ".SessionFilename()
endfunction

map <F2> :call SessionSave() <CR> " Quick write session with F2
map <F3> :call SessionLoad() <CR> " And load session with F3

autocmd VimEnter * call SessionLoad()
autocmd VimLeavePre * call SessionSave()

" }}}

" Graphical Vim settings {{{

" To enable the saving and restoring of screen positions.
let g:screen_size_restore_pos = 1

" To save and restore screen for each Vim instance.
" This is useful if you routinely run more than one Vim instance.
" For all Vim to use the same settings, change this to 0.
let g:screen_size_by_vim_instance = 1

if has("gui_running")
  " Don't blink normal mode cursor
  set guicursor=n-v-c:block-Cursor
  set guicursor+=n-v-c:blinkon0

  set guifont=Iosevka\ 12
  set guioptions-=T
  set guioptions-=e
  set guioptions-=L
  set guioptions-=r
  set guitablabel=%M\ %t

  function! ScreenFilename()
    return $HOME.'/.vim/sizes.save'
  endfunction

  function! ScreenRestore()
    " Restore window size (columns and lines) and position
    " from values stored in vimsize file.
    " Must set font first so columns and lines are based on font size.
    let f = ScreenFilename()
    if has("gui_running") && g:screen_size_restore_pos && filereadable(f)
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      for line in readfile(f)
        let sizepos = split(line)
        if len(sizepos) == 5 && sizepos[0] == vim_instance
          silent! execute "set columns=".sizepos[1]." lines=".sizepos[2]
          silent! execute "winpos ".sizepos[3]." ".sizepos[4]
          return
        endif
      endfor
    endif
  endfunction

  function! ScreenSave()
    " Save window size and position.
    if has("gui_running") && g:screen_size_restore_pos
      let vim_instance = (g:screen_size_by_vim_instance==1?(v:servername):'GVIM')
      let data = vim_instance . ' ' . &columns . ' ' . &lines . ' ' .
            \ (getwinposx()<0?0:getwinposx()) . ' ' .
            \ (getwinposy()<0?0:getwinposy())
      let f = ScreenFilename()
      if filereadable(f)
        let lines = readfile(f)
        call filter(lines, "v:val !~ '^" . vim_instance . "\\>'")
        call add(lines, data)
      else
        let lines = [data]
      endif
      call writefile(lines, f)
    endif
  endfunction

  if !exists('g:screen_size_restore_pos')
    let g:screen_size_restore_pos = 1
  endif

  if !exists('g:screen_size_by_vim_instance')
    let g:screen_size_by_vim_instance = 1
  endif

  autocmd VimEnter * if g:screen_size_restore_pos == 1 | call ScreenRestore() | endif
  autocmd VimLeavePre * if g:screen_size_restore_pos == 1 | call ScreenSave() | endif
endif

" }}}

" Syntastic settings {{{

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" }}}

" Generic properties {{{
set noshowmode     " Lightline already shows mode
set nocompatible   " Switch off VI compatibility mode
set nobackup
set nowritebackup
set nowb
set noswapfile
set ruler
set nocursorline     " Horizontal line on cursor
set nocursorcolumn   " Vertical line on cursor
set number         " show line numbers
set showmatch      " show matching brackets
set mat=2          " how many seconds to show matching brackets
set ai             " Auto indent
set si             " Smart indent
set splitright     " To make vsplit put the new buffer on the right of the current buffer
set splitbelow     " To make split put the new buffer below the current buffer
set viminfo^=%     " Remember info about open buffers on close
set colorcolumn=90 " Colored column
set hlsearch       " Highlight found occurences
set noautochdir    " Do not change directory automatically
" {{{
