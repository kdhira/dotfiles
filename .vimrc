" Author: Kevin Hira
" Adapted from script by Max Lay
" Taken from https://github.com/kalda341/dotfiles/blob/master/editors/vim/vimrc

syntax on
set nocompatible

"set spell spelllang=en_nz
nmap <Leader>zz :set spell! spelllang=en_nz<CR>

filetype on
filetype plugin on

set backspace=indent,eol,start

set shell=/bin/bash

let mapleader = "\\"

" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
    execute '!mkdir -p ~/.vim/autoload'
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    :qall
endif

call plug#begin()
""Autocompletion of quotes, brackets, etc
Plug 'Raimondi/delimitMate'
"For commenting lines
Plug 'scrooloose/nerdcommenter'
"Easy file and buffer selection
Plug 'ctrlpvim/ctrlp.vim'
"For dealing with surrounds
Plug 'tpope/vim-surround'
"Line diff symbols
Plug 'airblade/vim-gitgutter'
"Bottom status
Plug 'itchyny/lightline.vim'
"Live Markdown
Plug 'shime/vim-livedown'
"Catppuccin theme
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()

set history=200

"Indentation and tabs
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab
set smarttab smartindent
set autoindent
map <Leader>rt :%retab!<CR>
map <Leader>ut :set noexpandtab<CR>
map <Leader>u<space> :set expandtab<CR>

map <Leader>u2 :set ts=2 sts=2 sw=2<CR>
map <Leader>u4 :set ts=4 sts=4 sw=4<CR>

"Indent entire document
map <Leader><C-i> mzgg=G'z

"Reload file if edits happen somewhere else
set autoread

"Statusline stuff
"Display status line always
set laststatus=2
set ruler
set showcmd
set ch=1

"Ignore some file types
set wildmenu                    " Cool cmd completion
set wildignorecase
"%% is directory containing current file
cabbr <expr> %% expand('%:p:h')
set wildignore+=.hg,.git,.svn   " Version control
set wildignore+=*.pyc           " Python byte code
set wildignore+=*.beam           " Erlang byte code
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg
set wildignore+=*.class,*.o

"Display whitespace
set showbreak=↪\ 
set listchars=tab:→\ ,trail:·,extends:>,precedes:<,nbsp:·
set list
set wrap linebreak
"Line numbers and limits
set number                      " Show line numbers
"set cc=120                      " Ver line in 120 column
set cursorline

"Movement
set scrolloff=10                 " Start scrolling n lines before border
"Scroll wrapped lines normally
noremap  <buffer> <silent> k gk
noremap  <buffer> <silent> j gj

"End of line
inoremap <C-e> <C-o>$
"Start of line
inoremap <C-a> <C-o>^

"Search
set hlsearch                    " Highlight searches
set incsearch                   " Highlight dynamically as pattern is typed
set ignorecase                  " Ignore case of searches
nmap <Leader>/ :nohlsearch<CR>

"Allows undo after file is closed
if exists("&undodir")
    set undofile
    let s:undodir = expand('~/.vim/undo')
    if !isdirectory(s:undodir)
        call mkdir(s:undodir, 'p', 0700)
    endif
    let &undodir = s:undodir
endif
"Swap files and backup are super annoying. I save often
set noswapfile
set nobackup

"Lightline config
let g:lightline = {
    \ 'active': {
    \   'left': [ [ 'mode', 'paste' ],
    \             [ 'readonly', 'modified' ],
    \             [ 'filepathAbbreviated' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'percent' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ],
    \            [ 'spell' ] ]
    \ },
    \ 'component_function': {
    \   'gitbranch': 'fugitive#head',
    \   'filepathAbbreviated': 'LightLineFilename',
    \   'hunksummay': 'GetHunkSummary'
    \ },
    \ }

let g:lightline.tabline = {
    \ 'left': [ [ 'tabs' ] ],
    \ 'right': [ ] }

let g:lightline.tab = {
    \ 'active': [ 'tabnum', 'filename', 'modified' ],
    \ 'inactive': [ 'tabnum', 'filename', 'modified' ] }

function! GetHunkSummary()
    let summary = gitgutter#hunk#summary(bufnr("%"))
    "See vim-gitgutter/autoload/gitgutter/diff.vim#L62 for info about
    "getbufvar
    if fugitive#head() != '' && gitgutter#utility#getbufvar(bufnr("%"), 'tracked', 0)
        return '+' . summary[0] . ' ~' . summary[1] . ' -' . summary[2]
    else
        return ''
    endif
endfunction

"Taken from https://github.com/itchyny/lightline.vim/issues/87
function! LightLineFilename()
  let name = "/"
  if expand('%') =~ '^/'
      let name = '/'
  endif
    let subs = split(expand('%:p'), "/")
    let i = 1
    for s in subs
        let parent = name
        if  i == len(subs)
            if i == 1
                let name = s
            else
                let name = parent . '/' . s
            endif
        elseif i == 1
            let name = parent . strpart(s, 0, 4)
        else
            let name = parent . '/' . strpart(s, 0, 4)
        endif
        let i += 1
    endfor
  return name
endfunction

command! LightlineReload call LightlineReload()

function! LightlineReload()
  call lightline#init()
  call lightline#colorscheme()
  call lightline#update()
endfunction

"Theme
set noshowmode
set termguicolors
"set background=dark
set t_Co=256
colorscheme catppuccin_macchiato
let g:lightline.colorscheme = 'catppuccin_macchiato'
"highlight Normal ctermfg=white ctermbg=black
"highlight! link Visual CursorLine

"Set cursorcolumn
nmap <Leader>scc :set cuc<CR>
nmap <Leader>Scc :set nocuc<CR>

"Buffers
noremap <silent><Leader>bp :bprevious<CR>
noremap <silent><Leader>bn :bnext<CR>
noremap <silent><Leader>bc :bd<CR>

"Tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove

"Changlist
noremap <silent><Leader>cp :cprev<CR>
noremap <silent><Leader>cn :cnext<CR>

"Quickfix
noremap <Leader>q :copen<CR>
noremap <Leader>Q :cclose<CR>

"Make it easier to navigate windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

"Vimrc stuff
nmap <silent> <Leader>ev :tabe ~/.vimrc<CR>
nmap <silent> <Leader>sv :so ~/.vimrc<CR>

"Newline
map <Leader>o o<Esc>
map <Leader>O O<Esc>

"Copy, paste and cut to system clipboard
map <Leader>y "+y
map <Leader>x "+d
map <Leader>p :set paste<CR>"+p:set nopaste<CR>
map <Leader>P :set paste<CR>"+P:set nopaste<CR>
"Copy to end of line
noremap Y y$

"Repeat motion
let repmo_key=","
let repmo_revkey="\\"

"Use ; as :
nnoremap ; :

"Saving
nmap <Leader>w :w!<cr>
"Sudo write
cmap w!! w !sudo tee % >/dev/null

"cd
map <Leader>cd :cd %:p:h<cr>:pwd<cr>

"Use local config if available
if filereadable("~/.vimrc.local")
    so ~/.vimrc.local
endif

"Highlight trailing whitespace - http://vim.wikia.com/wiki/Highlight_unwanted_spaces
:highlight ExtraWhitespace ctermbg=darkred guibg=darkred
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
map <Leader>rw :s/\s\+$/<CR>


" Text wrapping maps
nmap <Leader>tw :set tw=80<CR>
nmap <Leader>t0 :set tw=0<CR>

nmap <F5> gT
nmap <F6> gt

imap <F5> <ESC>gT
imap <F6> <ESC>gt

let g:ctrlp_prompt_mappings = {
    \ 'AcceptSelection("e")': ['<c-t>'],
    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
    \ }

autocmd FileType gitcommit setlocal colorcolumn=73
