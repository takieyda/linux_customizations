" ==========  Vim-Plug settings  ==========

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
augroup InstallPlugins
    autocmd!
    autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
        \| PlugInstall --sync | source $MYVIMRC
        \| endif
augroup END

" Plugin list
call plug#begin()
    Plug 'godlygeek/tabular'
"    Plug 'preservim/vim-markdown'
    Plug 'tommcdo/vim-lion'
    Plug 'thaerkh/vim-indentguides'
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'kien/rainbow_parentheses.vim'
    Plug 'christoomey/vim-tmux-navigator'
    "Plug 'vim-scripts/AutoComplPop'
    Plug 'dracula/vim',{'as':'dracula'}
call plug#end()



" ==========  Theme Related  ==========
set background=dark                        " For compatibility with tmux
set termguicolors
"colorscheme dracula

augroup ColorChanges
    autocmd!
    autocmd ColorScheme * highlight Normal ctermbg=NONE guibg=NONE| " Black background
    autocmd ColorScheme * highlight CursorLine
                \ term=underline cterm=underline gui=underline
                \ ctermbg=NONE guibg=NONE
    highlight CursorLine guibg=NONE
    highlight Folded guibg=NONE
augroup END



" ==========  Vim-Airline / Theme  ==========
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" Theme related
let g:airline#extensions#tabline#enabled=1  " Top line showing tabes of open files
let g:airline_skip_empty_sections=1         " Collapses empty bottom row sections
let g:airline_powerline_fonts=1             " Powerline like fonts and symbols
let g:airline_section_z = airline#section#create(
    \ ['windowswap', '%p%% ', 'linenr','maxlinenr',':%v'])    "
let g:airline_theme='dracula'               " Set theme



" ==========  Basic Settings  ==========
syntax enable                    " Syntax highlighting on
filetype plugin indent on    " Filetype detection, syntax highlighting, indenting on
set laststatus=2             " Bottom row always visible
set number relativenumber    " Show line numbers
set incsearch                " Incremental search, starts search as typed
set hlsearch                 " Highlight search, highlights matching results
set expandtab                " Tab replacedwith  the appropriate number of spaces
set tabstop=4                " Tab set to 4 spaces
set shiftwidth=4             " Indention amount for < and > commands
set mouse=a                  " Mouse text select, no line nums, and pane resizinge
set showmatch                " Show matching (,{ when ),} is entered
set ignorecase               " Case insensitive search
set clipboard=unnamedplus    " Allows for yanking to clipboard
set splitbelow splitright    " Split window either below or right of current pane
set cursorline               " Horizontal line on screen where cursor issues
set scrolloff=24             " Keep working line in middle of screen
set hidden                   " Allows changing buffer without requiring writing

augroup Resize
    autocmd!
    autocmd VimResized * wincmd =|
augroup END

" Keybinds
map <leader>h :noh<CR>|  " Clear highlighting, leader is \
cmap w!! w !sudo tee > /dev/null %|  " Sudo trick, write file with :w!!
nnoremap <leader>o :Files<CR>|  " fzf open files
nnoremap <leader>l :Buffers<cr>|  " fzf open buffers



" ==========  VIM Scripts  ==========

    "  ========== IndentGuides  ==========
    let g:indentguides_spacechar = '▏' "'┆'
    let g:indentguides_tabchar = '|'
    let g:indentguides_toggleListMode = 0

    " ==========  Markdown and Header Folding  ==========
    set conceallevel=3
    let g:vim_markdown_folding_style_pythonic = 1
    let g:vim_markdown_follow_anchor = 1

    " ==========  Folding Settings  ==========
    " This will enable code folding. zo/zR to open/all, zc/zM clost/all
    " Use the marker method of folding. {{{,}}} fold markers
    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup END
    
    " ==========  Rainbow Parentheses  ==========
    augroup RainbowParens
        autocmd!
        autocmd VimEnter * RainbowParenthesesToggleAll
        autocmd Syntax * RainbowParenthesesLoadChevron
    augroup END
