" ==========  Vim-Plug settings  ========== 

" Install vim-plug if not found
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
    \| PlugInstall --sync | source $MYVIMRC
    \| endif

" Plugin list
call plug#begin()
    Plug 'godlygeek/tabular'
    Plug 'preservim/vim-markdown'
    Plug 'tommcdo/vim-lion'
    Plug 'thaerkh/vim-indentguides'
    Plug 'scrooloose/nerdtree'
    "Plug 'vim-scripts/AutoComplPop'
    Plug 'dracula/vim',{'as':'dracula'}
call plug#end()



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
set background=dark                        " For compatibility with tmux
"packadd! dracula
"colorscheme dracula



" ==========  Basic Settings  ========== 
syntax enable                    " Syntax highlighting on
highlight Normal ctermbg=NONE" Black background
filetype plugin indent on    " Filetype detection, syntax highlighting, indenting on
set laststatus=2             " Bottom row always visible
set number                   " Show line numbers
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
autocmd VimResized * wincmd =
set cursorline               " Horizontal line on screen where cursor issues
set scrolloff=24             " Keep working line in middle of screen

" Clear highlighting
map <leader>h :noh<CR>
" Sudo trick, write file with :w!!
cmap w!! w !sudo tee > /dev/null %



" ==========  VIM Scripts  ========== 

    " ==========  AutoComplPop Settings  ========== 
    set complete+=kspell
    set completeopt=menuone,preview
        
    " ==========  NERDTree Configuration  ========== 
    nnoremap <silent> <C-k><C-B> :NERDTreeToggle<CR>
    nnoremap <C-k>nf :NERDTreeFind<CR>
    " NERDTree open on vim open
    augroup nerdtree_open
        autocmd!
        autocmd VimEnter * NERDTreeCWD | wincmd p
    augroup END
    let NERDTreeShowBookmarks=1
    let NERDTreeIgnore=['.git']
    let NERDTreeStatusline="%{exists('b:NERDTree')?fnamemodify(b:NERDTree.root.path.str(), ':~'):''}"
    
    autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
    
    " https://github.com/preservim/nerdtree/issues/21#issuecomment-907483
    " Close all open buffers on entering a window if the only
    " buffer that's left is the NERDTree buffer
    function! s:CloseIfOnlyNerdTreeLeft()
        if exists("t:NERDTreeBufName")
            if bufwinnr(t:NERDTreeBufName) != -1
                if winnr("$") == 1
                    q
                endif
            endif
        endif
    endfunction
    
    "  ========== IndentGuides  ========== 
    let g:indentguides_spacechar = '▏' "'┆'
    let g:indentguides_tabchar = '|'
    autocmd VimEnter * IndentGuidesToggle
    
    
    " ==========  Markdown and Header Folding  ========== 
    set conceallevel=2
    let g:vim_markdown_folding_style_pythonic = 1
    let g:vim_markdown_follow_anchor = 1
    
    " ==========  Folding Settings  ========== 
    " This will enable code folding.
    " Use the marker method of folding.
    augroup filetype_vim
        autocmd!
        autocmd FileType vim setlocal foldmethod=marker
    augroup END 
