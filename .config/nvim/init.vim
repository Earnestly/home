" XDG_CONFIG_HOME/nvim/init.vim

" The first directory of the rtp should be the home directory of nvim, under
" which I'd like to store packages under a more reasonbly named directory.
let pkgdir = split(&rtp, ',', 0)[0] . '/packages'

call plug#begin(pkgdir)
    Plug 'benekastah/neomake'
    autocmd! BufWritePost * Neomake

    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'rust-lang/rust.vim', {'for': 'rust'}
    Plug 'dleonard0/pony-vim-syntax', {'for': 'pony'}

    " Various local packages.
    Plug pkgdir . '/vim-ktap', {'for': 'ktap'}
    Plug pkgdir . '/vim-draft', {'for': 'draft'}
    Plug pkgdir . '/vim-promela', {'for': 'promela'}
    Plug pkgdir . '/vim-ats', {'for': ['dats', 'sats']}
call plug#end()

unlet pkgdir

" Keys.
map Q q:

" Settings.
set cc=80
set number
set hidden
"set backup " https://github.com/neovim/neovim/issues/3496
set showcmd
set undofile
set linebreak
set scrolloff=1
set cinoptions+=t0
set formatoptions+=j

syntax on
filetype indent plugin on

runtime! macros/matchit.vim

" 4 spaced expanded tabs by default.
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

if &t_Co > 255 || has('gui_running')
    set background=dark

    let base16colorspace=256
    colorscheme base16-ocean

    "let g:zenburn_high_Contrast=1
    "colorscheme zenburn
endif

set guioptions=acM
set guifont=Inconsolatazi4\ 12

set smartcase
set ignorecase

set cursorline
set statusline=%n\ %F\ %M%=%y%w%r%h\ %{&fenc}\ %l,%c\ %p%%\ %L

" Speed up ESC in msec.
set ttimeoutlen=50

" Use the Xorg's primary buffer as default register.
set clipboard=unnamed

" Set directories.
"set undodir=~/.cache/vim/undo
"set directory=~/.cache/vim/swap
"set backupdir=~/.cache/vim/backup
"set viminfo+=n~/.cache/vim/viminfo

" Fancy arrows are not welcome.
" let g:no_rust_conceal = 1
" let g:haskell_conceal = 0
" 
" " Make bash the default for `sh` files.
" let g:is_bash = 1
" 
" Use clang when checking C/C++ syntax.
" let g:syntastic_c_compiler = 'clang'
" let g:syntastic_c_compiler_options = '-std=c11'
" let g:syntastic_c_remove_include_errors = 1
" 
" let g:syntastic_cpp_compiler = 'clang++'
" let g:syntastic_cpp_compiler_options = '-std=c++14'
" let g:syntastic_cpp_remove_include_errors = 1
" 
" " Haskell.
" let g:syntastic_haskell_hdevtools_args = '-g-Wall'
