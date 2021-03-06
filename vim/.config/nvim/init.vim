" vim:fdm=marker:foldlevel=0
" General settings {{{
set encoding=utf-8 nobomb
scriptencoding utf-8

set t_ut=
set background=dark
set termguicolors
syntax on
set mouse=
set history=1000
set laststatus=2
set number
set noshowmode
set shortmess=atI
set splitright
set splitbelow
set textwidth=99

let mapleader = ";"
" }}}

" Local directories for swap {{{
set directory=~/.cache/vim/swaps
set undodir=~/.cache/vim/undo
if ! filewritable(expand("~/.cache/vim/"))
   silent execute '!mkdir "~/.cache/vim"'
endif
if ! filewritable(expand(&directory))
   silent execute '!mkdir "' . &directory . '"'
endif

set undofile
set nobackup
set nowritebackup
" }}}

" Indentation/Formatting {{{
set autoindent
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set nojoinspaces
" }}}

" Folding {{{
set foldenable
set foldcolumn=0
" set foldmethod=syntax
set foldlevel=99
" }}}

" Search {{{
set hlsearch
set ignorecase
set smartcase
set incsearch
set wrapscan
" }}}

" Python {{{
" If available use virtualenv for python
if has('nvim')
   let s:virtualenv_python3 = glob(expand('$WORKON_HOME/neovim/bin/python'))
   if !empty(s:virtualenv_python3)
      let g:python3_host_prog = s:virtualenv_python3
    else
      let g:python3_host_prog = "/usr/bin/python"
   endif
endif
" }}}

" Local custom file to allow for device specific configuration
runtime custom/local.vim

" Custom commands {{{

" Source and edit init
command! SI :source ~/.config/nvim/init.vim
command! SE :tabedit ~/.config/nvim/init.vim

" Show / Hide 100 cols line
function! ToggleShowWidth()
   if &cc > 0
      let &cc = 0
      let &textwidth = 0
   else
      let &cc = 100
      let &textwidth = 99
   endif
endfunc
map <F7> :call ToggleShowWidth()<CR>

" Automatic retabbing
function! Retab(before, after)
   let &tabstop=a:before
   set noexpandtab
   execute '%retab!<CR>'
   let &tabstop=a:after
   set expandtab
   execute '%retab!<CR>'
endfunc

" Set tabsize
function! SetTabWidth(width)
  let &tabstop=a:width
  let &softtabstop=a:width
  let &shiftwidth=a:width
endfunc

" Switch between source and header file (specific to athena based analysis projects)
let g:code_switcher_headers = ["h", "hh"]
let g:code_switcher_source = ["c", "cc", "cxx", "cpp"]
function! AthenaSwitchHeaderSource()
  let folder=expand("%:p:h")
  let parentfolder=expand("%:p:h:h")
  let filename=expand("%:t:r")
  let extension=expand("%:e")
  if index(g:code_switcher_headers, extension) >= 0
    for ext in g:code_switcher_source
      let otherfile=globpath(parentfolder, "**/" . filename . "." . ext)
      if filereadable(otherfile)
        exec 'edit' otherfile
        break
      endif
    endfor
  elseif index(g:code_switcher_source, extension) >= 0
    for ext in g:code_switcher_headers
      let otherfile=globpath(parentfolder, "**/" . filename . "." . ext)
      if filereadable(otherfile)
        exec 'edit' otherfile
        break
      endif
    endfor
  endif
endfunction
command! THS call AthenaSwitchHeaderSource()
map <F11> :call AthenaSwitchHeaderSource()<CR>

cabbr <expr> %% expand('%:p:h')

" Terminal {{{
function! VTerm()
   execute "vsplit"
   execute "terminal"
endfunction
function! Term()
   execute "split"
   execute "terminal"
endfunction
command! T call Term()
command! VT call VTerm()
" }}}

" }}}

" Keybindings {{{

" Make sure function keys will not insert something
inoremap <F1> <nop>
inoremap <F2> <nop>
inoremap <F3> <nop>
inoremap <F4> <nop>
inoremap <F5> <nop>
inoremap <F6> <nop>
inoremap <F7> <nop>
inoremap <F8> <nop>
inoremap <F9> <nop>
inoremap <F10> <nop>
inoremap <F11> <nop>
inoremap <F12> <nop>

" Allow movement in insert mode with ALT
inoremap <A-h> <Left>
inoremap <A-j> <Down>
inoremap <A-k> <Up>
inoremap <A-l> <Right>

" Fast moving of windows
nnoremap <leader><C-H> <c-w>H
nnoremap <leader><C-J> <c-w>J
nnoremap <leader><C-K> <c-w>K
nnoremap <leader><C-L> <c-w>L

" Write file
nnoremap <leader>w :update<CR>

" Run black on the file
nnoremap <leader>b :Black<CR>

" Fast sudo write
command! SudoWrite execute ":w !sudo tee %<CR>"

" Use system clipboard
set clipboard=unnamedplus

" Use tab and shift+tab for indentation
vmap <Tab> >gv
vmap <S-Tab> <gv

" Spell check
function! ToggleSpellCheck()
   if &spell == 0
      echo "Spell check enabled"
      setlocal spell spelllang=en_gb
   else
      echo "Spell check disabled"
      setlocal nospell
   endif
endfunc
nnoremap <F4> :call ToggleSpellCheck()<CR>

" Follow file in new window
nnoremap <Leader>gg :vertical wincmd f<CR>

" Clear search
nnoremap <Leader>n :noh<CR>

" GoTo next quickfix in file
nnoremap <S-F> :cnf<CR>

" Warn when pressing ö (;/: in US layout) in normal mode to warn that the
" keyboard layout is german.
function! WarnKeyboardLayout()
   echo "Caution: Keyboard layout is german!"
endfunc
nnoremap ö :call WarnKeyboardLayout()<CR>
nnoremap Ö :call WarnKeyboardLayout()<CR>

" Terminal
tnoremap <Esc> <C-\><C-n>
tnoremap HH <c-\><c-n><c-w>h
tnoremap JJ <c-\><c-n><c-w>j
tnoremap KK <c-\><c-n><c-w>k
tnoremap LL <c-\><c-n><c-w>l
nnoremap <F2> :T<CR>
nnoremap <S-F2> :VT<CR>

" Strip trailing whitespace (,ss) {{{
function! StripWhitespace () " {{{
   let save_cursor = getpos(".")
   let old_query = getreg('/')
   :%s/\s\+$//e
   call setpos('.', save_cursor)
   call setreg('/', old_query)
endfunction " }}}
" }}}

" }}}

" Plugins {{{

" set the runtime path to include vim-plug and initialize
call plug#begin('~/.config/nvim/plugged')

" Polyglot disable has to be set before loading it
let g:polyglot_disabled = ['csv']

Plug 'scrooloose/nerdcommenter'
Plug 'majutsushi/tagbar'
Plug 'raimondi/delimitmate'
Plug 'SirVer/ultisnips'
" Plug 'tmhedberg/simpylfold'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'terryma/vim-multiple-cursors'
Plug 'romgrk/winteract.vim'
Plug 'itchyny/lightline.vim'
Plug 'zhou13/vim-easyescape'
Plug 'farmergreg/vim-lastplace'
Plug 'kien/ctrlp.vim'
Plug 'neomutt/neomutt.vim'
Plug 'sheerun/vim-polyglot'
Plug 'fneuhaus/oceanic-neo'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-SpellCheck'
Plug 'lervag/vimtex'
Plug 'christoomey/vim-tmux-navigator'
Plug 'troydm/zoomwintab.vim'
Plug 'psf/black', { 'branch': 'stable' }

if has('nvim')
   Plug 'neomake/neomake'
   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
   Plug 'zchee/deoplete-jedi'
   Plug 'fneuhaus/vim-dicts'
endif


call plug#end()

" Load plugin settings
runtime custom/nerd.vim
runtime custom/tagbar.vim
runtime custom/ultisnips.vim
runtime custom/gitgutter.vim
runtime custom/vim-multiple-cursors.vim
runtime custom/winteract.vim
runtime custom/lightline.vim
runtime custom/easyescape.vim
runtime custom/vim_tmux_navigator.vim
runtime custom/zoomwintab.vim
runtime custom/vimtex.vim
runtime custom/vim-polyglot.vim

if has('nvim')
   runtime custom/neomake.vim
   runtime custom/deoplete.vim
   runtime custom/vim-dicts.vim
endif

" colorscheme NeoSolarized
colorscheme oceanic-neo
" }}}
