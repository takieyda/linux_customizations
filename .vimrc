if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#enabled=1    " Top line showing tabes of open files
let g:airline_skip_empty_sections=1    " Collapses empty bottom row sections
let g:airline_powerline_fonts=1     " Powerline like fonts and symbols
let g:airline_section_z = airline#section#create(['windowswap', '%p%% ', 'linenr','maxlinenr',':%v'])    " 
let g:airline_theme='dracula'    " Set theme

syntax on    " Syntax highlighting on
filetype plugin indent on    " Filetype detection for syntax highlighting, indenting on

set laststatus=2    " Bottom row always visible
set number    " Show line numbers
set incsearch    " Incremental search, starts searching with each character typed
set hlsearch    " Highlight search, highlights matching results
set expandtab    " Hitting tab in insert mode will insert the appropriate number of spaces
set tabstop=4    " Tab set to 4 spaces
set shiftwidth=4    " Indention amount for < and > commands
set mouse=a     " Allows for mouse selection of text without copying line numbers, and pane resizing with mouse
set showmatch    " Show matching (,{ when ),} is entered
set ignorecase    " Case insensitive search

set splitbelow splitright   " Split window either below or right of current pane

packadd! dracula
colorscheme dracula
