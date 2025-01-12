" Plug
" Install Plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
" Install packages if not installed
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin()

" Plug 'tpope/vim-commentary' " Comments
" Plug 'tpope/vim-surround' " Surround
" Plug 'wellle/targets.vim' " daa, dab
" Plug 'kana/vim-textobj-user'
" Plug 'kana/vim-textobj-entire' " dae
" Plug 'machakann/vim-highlightedyank'
" let g:highlightedyank_highlight_duration = 100
" Plug 'romainl/vim-cool'
" " Plug 'itchyny/lightline.vim'
" " let g:lightline = { 'colorscheme': 'wombat' }
" Plug 'vimpostor/vim-lumen'

" Themes
Plug 'zaki/zazen'
Plug 'fionn/grb256'
Plug 'aditya-azad/candle-grey'
Plug 'andreasvc/vim-256noir'
Plug 'drsooch/gruber-darker-vim'
Plug 'fxn/vim-monochrome'

call plug#end()

" Options
syntax on
set shortmess+=I
set laststatus=2
set hidden
set ignorecase
set smartcase
set incsearch
set hlsearch
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set scrolloff=10
set sidescrolloff=5
set clipboard^=unnamed,unnamedplus
colorscheme monochrome
set noshowmode

" Keybinds
noremap j gj
noremap k gk
noremap <C-u> <C-u>zz
noremap <C-d> <C-d>zz

