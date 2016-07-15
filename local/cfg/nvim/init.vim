" LOCALDIR/nvim/init.vim

if empty($LOCALDIR)
    let pkgdir = $HOME . '/local/data' . '/nvim/packages'
else
    let pkgdir = $LOCALDIR . '/data' . '/nvim/packages'
endif

call plug#begin(pkgdir)
    Plug 'benekastah/neomake'
    autocmd! BufWritePost * Neomake

    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-commentary'
    Plug 'alerque/vim-sile', {'for': 'sile'}
    Plug 'weakish/rcshell.vim', {'for': 'rc'}
    Plug 'jakwings/vim-pony', {'for': 'pony'}
    Plug 'rust-lang/rust.vim', {'for': 'rust'}

    " Various local packages.
    Plug pkgdir . '/vim-ada', {'for': 'ada'}
    Plug pkgdir . '/vim-ktap', {'for': 'ktap'}
    Plug pkgdir . '/vim-draft', {'for': 'draft'}
    Plug pkgdir . '/vim-promela', {'for': 'promela'}
    Plug pkgdir . '/vim-ats', {'for': ['dats', 'sats']}
call plug#end()

unlet pkgdir

" Replace ex-mode with vim's command-line window.
map Q q:

" Settings.
set cc=80
set title
set number
set hidden
set backup
set showcmd
set undofile
set linebreak
set nohlsearch
set scrolloff=1
set cinoptions+=t0

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
endif

set smartcase
set ignorecase

set cursorline
set statusline=%n\ %F\ %M%=%y%w%r%h\ %{&fenc}\ %l,%c\ %p%%\ %L

" Speed up ESC in msec.
set ttimeoutlen=50

" Use the Xorg's primary buffer as default register.
set clipboard=unnamed

" Set directories.
set backupdir=$LOCALDIR/data/nvim/backup

" XXX Vim doesn't mkdir the backupdir path (bug?) so let's do that ourselves
" instead.
if !isdirectory($LOCALDIR . "/data/nvim/backup")
    call mkdir($LOCALDIR . "/data/nvim/backup", "p")
endif

" Prevent neomake reporting its exit status and suppressing the write message.
" https://github.com/benekastah/neomake/issues/238
let neomake_verbose = 0

" Use clang when checking C/C++ syntax.
let g:neomake_cpp_clang_args = neomake#makers#ft#c#clang()['args'] + ['-std=c99']
let g:neomake_cpp_clang_args = neomake#makers#ft#cpp#clang()['args'] + ['-std=c++11']
