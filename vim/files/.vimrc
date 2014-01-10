syntax on
filetype plugin indent on
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
"set ignorecase		" Do case insensitive matching
set smartcase		" Do smart case matching
set incsearch		" Incremental search
set autowrite		" Automatically save before commands like :next and :make
set hidden             " Hide buffers when they are abandoned
set autoindent
set smartindent
set so=7
set wildmenu
set wildmode=list:longest,full
set smartcase
set hlsearch
set incsearch
set showmatch
set mat=2
set background=dark
set expandtab
set tabstop=2
set shiftwidth=2
let g:syntastic_puppet_lint_arguments=' --no-documentation-check --no-80chars-check'
let g:syntastic_always_populate_loc_list=1

map <c-n> :lnext<CR>
map <c-p> :lprev<CR>
