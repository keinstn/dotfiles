call plug#begin()
Plug '/usr/local/opt/fzf'
Plug 'christoomey/vim-tmux-navigator'
Plug 'dag/vim-fish'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'rhysd/clever-f.vim'
Plug 'scrooloose/nerdtree'
Plug 'w0rp/ale'
call plug#end()

" Following commands are automatically executed by vim-plug.
" But I write them explicitly.
syntax enable
filetype plugin indent on

""" General
set number
set nowrap
set cursorline
set textwidth=80
set colorcolumn=80

set ignorecase
set smartcase

set expandtab
set tabstop=2
set shiftwidth=2

set incsearch
set hlsearch

" leader
let mapleader=","

""" Mappings

" edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

""" Plugins

" vim tmux navigator
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

" vim indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey

" vim fzf
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

" ale
let g:ale_fix_on_save = 1
let g:ale_fixers = ['remove_trailing_lines', 'trim_whitespace']
