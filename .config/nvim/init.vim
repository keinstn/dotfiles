call plug#begin()
if executable('brew')
  Plug '/usr/local/opt/fzf'
else
  Plug '~/.fzf'
endif
Plug 'altercation/vim-colors-solarized'
Plug 'alvan/vim-closetag'
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'christoomey/vim-tmux-navigator'
Plug 'dag/vim-fish'
Plug 'ervandew/supertab'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jparise/vim-graphql'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'mechatroner/rainbow_csv'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ncm2/ncm2'
Plug 'ncm2/ncm2-bufword'
Plug 'ncm2/ncm2-path'
Plug 'posva/vim-vue'
Plug 'rhysd/clever-f.vim'
Plug 'roxma/nvim-yarp' " For ncm2
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'w0rp/ale'
call plug#end()

" Following commands are automatically executed by vim-plug.
" But I write them explicitly.
syntax enable
filetype plugin indent on

""" General
set hidden
set number
set nowrap
set cursorline
set textwidth=80
set colorcolumn=80

set ignorecase
set smartcase

set expandtab
set shiftwidth=4
set softtabstop=4
set tabstop=4

set incsearch
set hlsearch

set nobackup
set noswapfile

" leader
let mapleader=","

" clipboard
set clipboard+=unnamedplus

" Language support
setlocal completeopt-=preview

""" CSS
autocmd FileType css set completefunc=syntaxcomplete#Complete
autocmd FileType css set omnifunc=syntaxcomplete#Complete
autocmd FileType css
    \ if &omnifunc != '' |
    \   call SuperTabChain(&omnifunc, "<c-n>") |
    \ endif

""" Python
autocmd FileType python setlocal sw=4 sts=4 ts=4 et

""" Javascript
autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et

""" Vimscript
autocmd FileType vim setlocal sw=2 sts=2 ts=2 et

""" YAML
autocmd FileType yaml setlocal sw=2 sts=2 ts=2 et


""" Vue
autocmd FileType vue setlocal sw=2 sts=2 ts=2 et


""" Git commit
autocmd FileType gitcommit setlocal spell

""" Go
autocmd FileType go BufWritePre :call LanguageClient#textDocument_formatting_sync()
autocmd FileType go nmap <leader>b <Plug>(go-build)
autocmd FileType go nmap <leader>r <Plug>(go-run)

""" Mappings

" edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>:echo 'Reloaded vimrc!'<CR>

""" Plugins

" Colorscheme
set background=dark
colorscheme solarized

" vim tmux navigator
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <c-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <c-j> :TmuxNavigateDown<cr>
nnoremap <silent> <c-k> :TmuxNavigateUp<cr>
nnoremap <silent> <c-l> :TmuxNavigateRight<cr>
nnoremap <silent> <c-\> :TmuxNavigatePrevious<cr>

" supertab
let g:SuperTabDefaultCompletionType = "<c-n>"

" vim indent guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=darkgrey

" vim fzf
command! -bang -nargs=* Find
      \ call fzf#vim#grep(
      \ 'rg --column --line-number --no-heading --fixed-strings
      \ --ignore-case --no-ignore --hidden --follow --glob "!.git/*"
      \ --color "always" '.shellescape(<q-args>), 1, <bang>0
      \ )
nnoremap ; :Files<Cr>

" ale
let g:ale_fix_on_save = 1
let g:ale_linters = {
      \ 'python': ['flake8'],
      \ 'go': ['gopls']
      \}
let g:ale_fixers = {
      \ '*': ['trim_whitespace', 'remove_trailing_lines'],
      \ 'python': ['black', 'isort'],
      \ 'javascript': ['prettier', 'eslint'],
      \ 'vue': ['prettier', 'eslint']
      \}

" LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'css': ['/usr/local/bin/css-languageserver', '--stdio'],
    \ 'go': ['gopls'],
    \ 'javascript': ['/usr/local/bin/javascript-typescript-stdio'],
    \ 'python': ['pyls'],
    \ 'vue': ['/usr/local/bin/vls'],
    \ }


nnoremap <F5> :call LanguageClient_contextMenu()<CR>
nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

" ncm2
autocmd BufEnter * call ncm2#enable_for_buffer()
set completeopt=noinsert,menuone,noselect
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
