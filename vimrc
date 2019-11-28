"
" Oldgit's Vim Configuration
"

"-----------------------------------------------------------------------------
" Global Stuff
"-----------------------------------------------------------------------------

" Set global os variable for operating system
if !exists("g:os")
  if has("win64") || has("win32") || has("win16")
    let g:os = "Windows"
  else
    let g:os = substitute(system('uname'), '\n', '', '')
    if "Linux" =~ g:os
      let g:os = substitute(system('cat /etc/issue'), ' .*$', '', '')
    endif
  endif
endif

if "Debian" =~ g:os
  runtime! debian.vim
endif

function! FindGitDirOrRoot()
  let filedir = expand('%:p:h')
  if isdirectory(filedir)
    let cmd = 'bash -c "(cd ' . filedir . '; git rev-parse --show-toplevel 2>/dev/null)"'
    let gitdir = system(cmd)
    if strlen(gitdir) == 0
      return '/'
    else
      return gitdir[:-2] " chomp
    endif
  else
    return '/'
  endif
endfunction

set nocompatible              " be iMproved, required

" ---- Vim Plug install if necessary ----
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source ~/.vimrc
endif

" ---- Vim Plug plugins ----
if has("nvim")
  call plug#begin('~/.local/share/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" visual themes
Plug 'lifepillar/vim-solarized8'
Plug 'endel/vim-github-colorscheme'
" visual status line
Plug 'itchyny/lightline.vim'
" rainbow parentheses for javascript, clojure, etc.
Plug 'luochen1990/rainbow'

" visual select list and add increment numbers
Plug 'iiey/visincr'

" highlight trailing white space
Plug 'ntpeters/vim-better-whitespace'

" align text in columns
Plug 'godlygeek/tabular'

" navigation
Plug 'scrooloose/nerdtree'
Plug 'qpkorr/vim-bufkill'
Plug 'easymotion/vim-easymotion'
Plug 'tpope/vim-unimpaired'
" switch between file pairs
Plug 'derekwyatt/vim-fswitch'
Plug 'Shougo/neomru.vim'
Plug 'Shougo/denite.nvim'

" clojure syntax
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" clojure cider-nrepl
Plug 'tpope/vim-fireplace'

" silver searcher
Plug 'rking/ag.vim'

" templating
" Plug 'drmingdrmer/xptemplate'

" git
Plug 'tpope/vim-fugitive'

" markdown
Plug 'plasticboy/vim-markdown'

" misc - may need this...
Plug 'xolox/vim-misc'

" undo history
Plug 'sjl/gundo.vim'

" languages / file types
Plug 'sheerun/vim-polyglot'
" play2/akka config
Plug 'GEverding/vim-hocon'
" emmet for HTML + CSS
Plug 'mattn/emmet-vim'

" syntax linting
Plug 'neomake/neomake'

" Java Development
Plug 'majutsushi/tagbar'
Plug 'sbdchd/neoformat'
Plug 'artur-shaik/vim-javacomplete2'

" neo autocomplete with tern
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'ternjs/tern_for_vim', { 'do': 'npm install' }

" seemless tmux vim window navigation
Plug 'christoomey/vim-tmux-navigator'

" All of your Plugs must be added before the following line
call plug#end()

" Add xptemplate global personal directory value
if has("unix")
  set runtimepath+=~/.vim/xpt-personal
endif

if has('gui_running')
  set guifont=SourceCodePro-Regular:h14
endif

" Tabstops are 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

" set visual bell -- no more beeping!
set vb

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Solarized
if "Debian" =~ g:os
  let g:solarized_use16 = 1
else
  set termguicolors
endif
syntax enable
set background=light
colorscheme solarized8

" rainbow parentheses off, toggle with :RainbowToggle
let g:rainbow_active = 0

" Create xmllint maker
let g:neomake_xml_xmllint_maker = {
    \ 'exe': 'xmllint',
    \ 'args': ['--format'],
    \ 'errorformat': '%A%f:%l:\ %m,%-Z%p^,%-C%.%#'
    \ }

" Switch on linters on buffer open, save
let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_json_enabled_makers = ['jsonlint']
let g:neomake_xml_enabled_makers = ['xmllint']
autocmd! BufWritePost,BufEnter * Neomake

let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'fugitive', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"R":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ },
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' }
      \ }

" set the forward slash to be the slash of note.  Backslashes suck
set shellslash

if has("unix")
  set shell=zsh
else
  set shell=cmd.exe
endif

" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
set hidden

" Make the 'cw' and like commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions+=$

" tell VIM to always put a status line in, even if there is only one window
set laststatus=2

" Don't update the display while executing macros
set lazyredraw

" Don't show the current command in the lower right corner.  In OSX, if this is
" set and lazyredraw is set then it's slow as molasses, so we unset this
set showcmd

" Show the current mode
set showmode

" Switch on syntax highlighting.
syntax on

" Hide the mouse pointer while typing
set mousehide

" Keep some stuff in the history
set history=100

"  These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" Allow the cursor to go in to "invalid" places
set virtualedit=all

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" Add the unnamed register to the clipboard
set clipboard+=unnamed

" Automatically read a file that has changed on disk
set autoread

" line numbering on
set number
set relativenumber

" Make the command-line completion better
set wildmenu

" Types of files to ignore when autocompleting things
set wildignore+=*.o,*.class,*.git,*.svn

" Various characters are "wider" than normal fixed width characters, but the
" default setting of ambiwidth (single) squeezes them into "normal" width, which
" sucks.  Setting it to double makes it awesome.
set ambiwidth=double

" OK, so I'm gonna remove the VIM safety net ...
set nobackup
set nowritebackup
set noswapfile

" Let the syntax highlighting for Java files allow cpp keywords
let java_allow_cpp_keywords = 1

" I don't want to have the default keymappings for my scala plugin evaluated
let g:scala_use_default_keymappings = 0

" leader key
let mapleader = ','

" Wipe out all buffers
nmap <silent> ,wa :1,9000bwipeout<cr>

" Toggle paste mode
nmap <silent> ,p :set invpaste<CR>:set paste?<CR>

" cd to the directory containing the file in the buffer
nmap <silent> ,cd :lcd %:h<CR>
nmap <silent> ,cr :lcd <c-r>=FindGitDirOrRoot()<cr><cr>
nmap <silent> ,md :!mkdir -p %:p:h<CR>

" Turn off that stupid highlight search
nmap <silent> ,n :nohls<CR>

" The following beast is something i didn't write... it will return the
" syntax highlighting group that the current "thing" under the cursor
" belongs to -- very useful for figuring out what to change as far as
" syntax highlighting goes.
nmap <silent> ,qq :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

" set text wrapping toggles
nmap <silent> ,jw :set invwrap<cr>
nmap <silent> ,jW :windo set invwrap<cr>

" allow command line editing like emacs
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <Down>
cnoremap <C-P>      <Up>
cnoremap <ESC>b     <S-Left>
cnoremap <ESC><C-B> <S-Left>
cnoremap <ESC>f     <S-Right>
cnoremap <ESC><C-F> <S-Right>
cnoremap <ESC><C-H> <C-W>

" Maps to make handling windows a bit easier
noremap <silent> <C-F9>  :vertical resize -10<CR>
noremap <silent> <C-F10> :resize +10<CR>
noremap <silent> <C-F11> :resize -10<CR>
noremap <silent> <C-F12> :vertical resize +10<CR>
noremap <silent> ,s8 :vertical resize 83<CR>
noremap <silent> ,cj :wincmd j<CR>:close<CR>
noremap <silent> ,ck :wincmd k<CR>:close<CR>
noremap <silent> ,ch :wincmd h<CR>:close<CR>
noremap <silent> ,cl :wincmd l<CR>:close<CR>
noremap <silent> ,cc :close<CR>
noremap <silent> ,cw :cclose<CR>
noremap <silent> ,ml <C-W>L
noremap <silent> ,mk <C-W>K
noremap <silent> ,mh <C-W>H
noremap <silent> ,mj <C-W>J
noremap <silent> <C-7> <C-W>>
noremap <silent> <C-8> <C-W>+
noremap <silent> <C-9> <C-W>+
noremap <silent> <C-0> <C-W>>

" Edit the vimrc file
nmap <silent> ,ev :e $MYVIMRC<CR>
nmap <silent> ,sv :so $MYVIMRC<CR>

" Make horizontal scrolling easier
" nmap <silent> <C-o> 10zl
" nmap <silent> <C-i> 10zh

" Underline the current line with '='
nmap <silent> ,u= :t.\|s/./=/g\|:nohls<cr>
nmap <silent> ,u- :t.\|s/./-/g\|:nohls<cr>
nmap <silent> ,u~ :t.\|s/./\\~/g\|:nohls<cr>

" Shrink the current window to fit the number of lines in the buffer.  Useful
" for those buffers that are only a few lines
nmap <silent> ,sw :execute ":resize " . line('$')<cr>

" Use the bufkill plugin to eliminate a buffer but keep the window layout
nmap ,bd :BD<cr>

" Make the current file executable
nmap ,x :w<cr>:!chmod 755 %<cr>:e<cr>

"-----------------------------------------------------------------------------
" Neovim terminal
"-----------------------------------------------------------------------------
" map <Esc> to exit terminal mode:
:tnoremap <Esc> <C-\><C-n>

"-----------------------------------------------------------------------------
" Fugitive
"-----------------------------------------------------------------------------
" Thanks to Drew Neil
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \  noremap <buffer> .. :edit %:h<cr> |
  \ endif
autocmd BufReadPost fugitive://* set bufhidden=delete

nmap ,gs :Gstatus<cr>
nmap ,ge :Gedit<cr>
nmap ,gw :Gwrite<cr>
nmap ,gr :Gread<cr>

"-----------------------------------------------------------------------------
" NERD Tree Plugin Settings
"-----------------------------------------------------------------------------
" Toggle the NERD Tree on an off with F7
nmap <F7> :NERDTreeToggle<CR>

" Close the NERD Tree with Shift-F7
nmap <S-F7> :NERDTreeClose<CR>

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

"-----------------------------------------------------------------------------
" AG (SilverSearcher) Settings
"-----------------------------------------------------------------------------
function! AgProjectRoot(pattern)
  let dir = FindGitDirOrRoot()
  execute ':Ag ' . a:pattern . ' ' . dir
endfunction

command! -nargs=+ AgProjectRoot call AgProjectRoot(<q-args>)

nmap ,sr :AgForProjectRoot
let g:agprg = '/usr/local/bin/ag'
let g:ag_results_mapping_replacements = {
\   'open_and_close': '<cr>',
\   'open': 'o',
\ }

"-----------------------------------------------------------------------------
" FSwitch mappings
"-----------------------------------------------------------------------------
nmap <silent> ,of :FSHere<CR>
nmap <silent> ,ol :FSRight<CR>
nmap <silent> ,oL :FSSplitRight<CR>
nmap <silent> ,oh :FSLeft<CR>
nmap <silent> ,oH :FSSplitLeft<CR>
nmap <silent> ,ok :FSAbove<CR>
nmap <silent> ,oK :FSSplitAbove<CR>
nmap <silent> ,oj :FSBelow<CR>
nmap <silent> ,oJ :FSSplitBelow<CR>

"-----------------------------------------------------------------------------
" XPTemplate settings
"-----------------------------------------------------------------------------
" let g:xptemplate_brace_complete = ''

"-----------------------------------------------------------------------------
" Gundo settings
"-----------------------------------------------------------------------------
let g:gundo_prefer_python3 = 1
nmap <F5> :GundoToggle<CR>

"-----------------------------------------------------------------------------
" markdown settings
"-----------------------------------------------------------------------------
let g:vim_markdown_folding_disabled = 1

"-----------------------------------------------------------------------------
" deoplete settings
"-----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1
let g:deoplete#omni_patterns = {}
let g:deoplete#omni_patterns.java = '[^. *\t]\.\w*'
let g:deoplete#sources = {}
let g:deoplete#sources._ = []
let g:deoplete#file#enable_buffer_path = 1

"-----------------------------------------------------------------------------
" Omnicomplete settings
"-----------------------------------------------------------------------------
autocmd InsertLeave,CompleteDone * if pumvisible() == 0 | pclose | endif

filetype plugin on
autocmd FileType groovy setlocal ts=4 sts=4 sw=4
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType java setlocal omnifunc=javacomplete#Complete

" tern
if exists('g:plugs["tern_for_vim"]')
  let g:tern_map_keys = 1
  let g:tern_map_prefix = ','
  let g:tern_show_argument_hints = 'on_hold'
  let g:tern_show_signature_in_pum = 1
  autocmd FileType javascript setlocal omnifunc=tern#Complete
endif

"-----------------------------------------------------------------------------
" neomake mappings
"-----------------------------------------------------------------------------
autocmd! BufWritePost,BufEnter * Neomake
nmap <Leader><Space>o :lopen<CR>      " open location window
nmap <Leader><Space>c :lclose<CR>     " close location window
nmap <Leader><Space>, :ll<CR>         " go to current error/warning
nmap <Leader><Space>n :lnext<CR>      " next error/warning
nmap <Leader><Space>p :lprev<CR>      " previous error/warning

"-----------------------------------------------------------------------------
" neomake mappings
"-----------------------------------------------------------------------------
augroup astyle
  autocmd!
  autocmd BufWritePre * Neoformat
augroup END

"-----------------------------------------------------------------------------
" Denite Settings
"-----------------------------------------------------------------------------
" Change file/rec command.
call denite#custom#var('file/rec', 'command',
      \ ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
" Change grep command.
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'default_opts', ['-i', '--vimgrep'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'separator', ['--'])
call denite#custom#var('grep', 'final_opts', [])

autocmd FileType denite call s:denite_settings()

function! s:denite_settings() abort
  nnoremap <silent><buffer><expr> <CR>
        \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> <C-v>
        \ denite#do_map('do_action', 'vsplit')
  nnoremap <silent><buffer><expr> d
        \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
        \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> <Esc>
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> q
        \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
        \ denite#do_map('open_filter_buffer')
endfunction

autocmd FileType denite-filter call s:denite_filter_settings()

function! s:denite_filter_settings() abort
  nmap <silent><buffer> <Esc> <Plug>(denite_filter_quit)
endfunction

" Key mapped to ctrlp
nnoremap <C-p> :Denite file/rec<cr>
nmap ,ff :Denite file/rec<cr>
nmap ,fb :Denite buffer<cr>
nmap ,fg :Denite grep<cr>
