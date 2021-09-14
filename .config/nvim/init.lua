-------------------- HELPERS -------------------------------
local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
local fmt = string.format

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  if opts then options = vim.tbl_extend('force', options, opts) end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'
local paq = require('paq-nvim').paq
paq {'savq/paq-nvim', opt=true}

paq {'alvan/vim-closetag'}
paq {'ap/vim-css-color'}
paq {'christoomey/vim-tmux-navigator'}
paq {'ervandew/supertab'}
paq {'jiangmiao/auto-pairs'}
paq {'joshdick/onedark.vim'}
paq {'junegunn/vim-easy-align'}
paq {'lukas-reineke/indent-blankline.nvim', branch = 'lua'}
paq {'lukas-reineke/format.nvim'}
paq {'mattn/emmet-vim'}
paq {'mechatroner/rainbow_csv'}
paq {'neovim/nvim-lspconfig'}
paq {'nvim-lua/completion-nvim'}
paq {'nvim-lua/plenary.nvim'}
paq {'nvim-lua/popup.nvim'}
paq {'nvim-telescope/telescope.nvim'}
paq {'nvim-treesitter/nvim-treesitter'}
paq {'rhysd/clever-f.vim'}
paq {'tpope/vim-fugitive'}
paq {'tpope/vim-repeat'}
paq {'tpope/vim-surround'}
paq {'wellle/context.vim'}

-------------------- GLOBAL --------------------------------
g['mapleader'] = ','

-------------------- PLUGIN SETUP --------------------------
-- supertab
g['SuperTabDefaultCompletionType'] = '<c-n>'

-- context.vim
g['context_enabled'] = 0
map('n', '<leader>cd', ':ContextDisable<CR>')
map('n', '<leader>ce', ':ContextEnable<CR>')

-- format.nvim
require "format".setup {
  ["*"] = {
    {cmd = {"sed -i '' 's/[ \t]*$//'"}}
  },
  javascript = {
    {cmd = {"prettier -w", "./node_modules/.bin/eslint --fix"}}
  },
  go = {
    {cmd = {"gofmt -w", "goimports -w"}}
  },
  ruby = {
    {cmd = {"rbprettier --write"}}
  },
  rust = {
    {cmd = {"rustfmt"}}
  },
}


cmd([[
augroup Format
  autocmd!
  autocmd BufWritePost * FormatWrite
augroup END
]])

-- telescope
map('n', ';', ':Telescope find_files<CR>')
map('n', '<leader>ff', ':Telescope find_files<CR>')
map('n', '<leader>fg', ':Telescope live_grep<CR>')
map('n', '<leader>fb', ':Telescope buffers<CR>')
map('n', '<leader>fh', ':Telescope help_tags<CR>')

-- emmet-vim
g['user_emmet_leader_key'] = '<C-Z>'

-------------------- OPTIONS -------------------------------
local indent, width = 4, 80
cmd 'colorscheme onedark'
opt('b', 'expandtab', true)               -- Use spaces instead of tabs
opt('b', 'formatoptions', 'crqnj')        -- Automatic formatting options
opt('b', 'shiftwidth', indent)            -- Size of an indent
opt('b', 'smartindent', true)             -- Insert indents automatically
opt('b', 'tabstop', indent)               -- Number of spaces tabs count for
opt('b', 'textwidth', width)              -- Maximum width of text
opt('o', 'completeopt', 'menuone,noinsert,noselect')  -- Completion options
opt('o', 'hidden', true)                  -- Enable background buffers
opt('o', 'ignorecase', true)              -- Ignore case
opt('o', 'joinspaces', false)             -- No double spaces with join
opt('o', 'pastetoggle', '<F2>')           -- Paste mode
opt('o', 'scrolloff', 4 )                 -- Lines of context
opt('o', 'shiftround', true)              -- Round indent
opt('o', 'sidescrolloff', 8 )             -- Columns of context
opt('o', 'smartcase', true)               -- Don't ignore case with capitals
opt('o', 'splitbelow', true)              -- Put new windows below current
opt('o', 'splitright', true)              -- Put new windows right of current
opt('o', 'termguicolors', true)           -- True color support
opt('o', 'updatetime', 100)               -- Delay before swap file is saved
opt('o', 'clipboard', 'unnamedplus')      -- Clipboard
opt('w', 'colorcolumn', tostring(width))  -- Line length marker
opt('w', 'cursorline', true)              -- Highlight cursor line
opt('w', 'list', true)                    -- Show some invisible characters
opt('w', 'number', true)                  -- Show line numbers
opt('w', 'signcolumn', 'yes')             -- Show sign column
opt('w', 'wrap', false)                   -- Disable line wrap

-------------------- MAPPINGS ------------------------------
map('n', '<leader>ev', ':e $MYVIMRC<CR>')
map('n', '<leader>sv', ":luafile $MYVIMRC<CR>:echo 'Reloaded vimrc!'<CR>")

-------------------- FILETYPES -----------------------------
cmd 'autocmd FileType python setlocal sw=4 sts=4 ts=4 et'
cmd 'autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et'
cmd 'autocmd FileType lua setlocal sw=2 sts=2 ts=2 et'
cmd 'autocmd FileType go setlocal sw=4 sts=4 ts=4 noet'
cmd 'autocmd FileType gitcommit setlocal spell'

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'

for ls, cfg in pairs({
  pylsp = {
    root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
  },
  gopls = {},
  solargraph = {},
  tsserver = {},
  rust_analyzer = {},
}) do
  cfg["on_attach"] = require'completion'.on_attach
  lsp[ls].setup(cfg)
end

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
