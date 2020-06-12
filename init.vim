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

" ---- Vim Plug plugins ----
call plug#begin('~/.local/share/nvim/plugged')

" Solarized colorscheme
Plug 'lifepillar/vim-solarized8'

" visual status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" highlight trailing white space
Plug 'ntpeters/vim-better-whitespace'

" languages / file types
Plug 'sheerun/vim-polyglot'
" emmet for HTML + CSS
Plug 'mattn/emmet-vim'

" Clojure / Lisp
Plug 'tpope/vim-unimpaired'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
" clojure cider-nrepl
Plug 'tpope/vim-fireplace'

" Javascript / Typescript / React
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'

" git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rhubarb'
" undo history
Plug 'mbbill/undotree'
" vim-man
Plug 'vim-utils/vim-man'

" fzf
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

" Completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" ALE - Linter with Language Servers
Plug 'dense-analysis/ale'

" All of your Plugs must be added before the following line
call plug#end()

" Set colorscheme
if "Debian" =~ g:os
  let g:solarized_use16 = 1
else
  set termguicolors
endif
set background=light
colorscheme solarized8
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline_section_z = "%4l%#__restore__#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v"
let g:airline_theme = 'sol'

set showcmd		  " Show (partial) command in status line.
set showmatch		" Show matching brackets.
set ignorecase	" Do case insensitive matching
set smartcase		" Do smart case matching
set hlsearch    " Highlight search
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden		  " Hide buffers when they are abandoned
set mouse=a		  " Enable mouse usage (all modes)
set mousehide   " Hide the mouse pointer while typing
set scrolloff=6 " Amount of lines at top/bottom of page
set nowrap
set colorcolumn=120
highlight ColorColumn ctermbg=0 guibg=lightgrey

" Remove the VIM safety net and replace with undofile
set nobackup
set nowritebackup
set noswapfile
set undodir=~/.vim/undodir
set undofile

" Tabstops are 2 spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent

" set visual bell -- no more beeping!
set vb

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Make the 'cw' and like: commands put a $ at the end instead of just deleting
" the text and replacing it
set cpoptions+=$

"Always use clipboard
set clipboard+=unnamedplus

" Automatically read a file that has changed on disk
set autoread

" line numbering on
set number
set relativenumber

" Search into sub-folders, tab completion
set path+=**
set wildmenu
" Types of files to ignore when autocompleting things
set wildignore+=*.o,*.class,*.git,*.svn

" highlight yanked text (neovim)
if exists('##TextYankPost')
  au TextYankPost * silent! lua require'vim.highlight'.on_yank('Substitute', 200)
endif

" change the leader key from "\" to ";" ("," is also popular)
let mapleader=";"

" Toggle paste mode
nmap <silent> <leader>p :set invpaste<CR>:set paste?<CR>

" Turn off that stupid highlight search
nmap <silent> <leader>n :nohls<CR>

" Underline the current line with '='
nmap <silent> <leader>u= :t.\|s/./=/g\|:nohls<cr>
nmap <silent> <leader>u- :t.\|s/./-/g\|:nohls<cr>
nmap <silent> <leader>u~ :t.\|s/./\\~/g\|:nohls<cr>

" allow command line editing like emacs
cnoremap <C-A>      <Home>
cnoremap <C-B>      <Left>
cnoremap <C-E>      <End>
cnoremap <C-F>      <Right>
cnoremap <C-N>      <Down>
cnoremap <C-P>      <Up>

"-----------------------------------------------------------------------------
" DEOPLETE completion
"-----------------------------------------------------------------------------
let g:deoplete#enable_at_startup = 1

"-----------------------------------------------------------------------------
" ALE
"-----------------------------------------------------------------------------
let g:ale_linters = {'clojure': ['clj-kondo']}
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

"-----------------------------------------------------------------------------
" LSP
"-----------------------------------------------------------------------------
" let g:lsp_signs_error = {'text': '✗'}
" let g:lsp_signs_warning = {'text': '!'}
" let g:lsp_signs_info = {'text': 'i'}
" let g:lsp_signs_hint = {'text': '?'}
" let g:lsp_virtual_text_enabled = 0
" let g:lsp_diagnostics_float_cursor = 1
" let g:lsp_diagnostics_float_delay = 1000

"-----------------------------------------------------------------------------
" Neovim terminal
"-----------------------------------------------------------------------------
" map <Esc> to exit terminal mode:
if has("nvim")
  au TermOpen * tnoremap <buffer> <Esc> <c-\><c-n>
  au FileType fzf tunmap <buffer> <Esc>
endif

"-----------------------------------------------------------------------------
" FZF
"-----------------------------------------------------------------------------
" Key mapped to ctrlp
nnoremap <C-p> :Files<cr>
nnoremap <leader>b :Buffers<cr>
nnoremap <leader>h :History<cr>
nnoremap <leader>g :BCommits<cr>
nnoremap <leader>l :Commits<cr>
" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
  \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

