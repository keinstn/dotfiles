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
local use = require('packer').use
require('packer').startup(function()
  use 'wbthomason/packer.nvim'

  use 'alvan/vim-closetag'
  use 'christoomey/vim-tmux-navigator'
  use 'ervandew/supertab'
  use 'gorodinskiy/vim-coloresque'
  use 'jiangmiao/auto-pairs'
  use 'joshdick/onedark.vim'
  use 'junegunn/vim-easy-align'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'mattn/emmet-vim'
  use 'mechatroner/rainbow_csv'
  use 'mhartington/formatter.nvim'
  use 'neovim/nvim-lspconfig'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'nvim-telescope/telescope.nvim'
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
  use 'rhysd/clever-f.vim'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-repeat'
  use 'tpope/vim-surround'
  use 'wellle/context.vim'

  -- Autocompletion related
  use 'hrsh7th/nvim-cmp'         -- Autocompletion plugin
  use 'hrsh7th/cmp-nvim-lsp'     -- LSP source for nvim-cmp
  use 'saadparwaiz1/cmp_luasnip' -- Snippets source for nvim-cmp
  use 'L3MON4D3/LuaSnip'         -- Snippets plugin
end)

-------------------- GLOBAL --------------------------------
g['mapleader'] = ','

-------------------- PLUGIN SETUP --------------------------
-- supertab
g['SuperTabDefaultCompletionType'] = '<c-n>'

-- context.vim
g['context_enabled'] = 0
map('n', '<leader>cd', ':ContextDisable<CR>')
map('n', '<leader>ce', ':ContextEnable<CR>')

-- formatter.nvim
require("formatter").setup({
  filetype = {
    javascript = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true
        }
      end
    },
    css = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true
        }
      end
    },
    scss = {
      -- prettier
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
          stdin = true
        }
      end
    },
    python = {
      -- Configuration for psf/black
      function()
        return {
          exe = "black", -- this should be available on your $PATH
          args = { '-' },
          stdin = true,
        }
      end
    },
    ruby = {
       -- rubocop
       function()
         return {
           exe = "rubocop", -- might prepend `bundle exec `
           args = { '--auto-correct', '--stdin', '%:p', '2>/dev/null', '|', "awk 'f; /^====================$/{f=1}'"},
           stdin = true,
         }
       end
    },
    rust = {
      -- Rustfmt
      function()
        return {
          exe = "rustfmt",
          args = {"--emit=stdout"},
          stdin = true
        }
      end
    },
  }
})

cmd([[
augroup TrimTrailingWhiteSpace
    autocmd!
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre * %s/\n\+\%$//e
augroup END
]])

cmd([[
augroup Format
  autocmd!
  autocmd BufWritePost * silent! FormatWrite
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
cmd 'autocmd FileType css setlocal sw=2 sts=2 ts=2 et'
cmd 'autocmd FileType scss setlocal sw=2 sts=2 ts=2 et'
cmd 'autocmd FileType lua setlocal sw=2 sts=2 ts=2 et'
cmd 'autocmd FileType go setlocal sw=4 sts=4 ts=4 noet'
cmd 'autocmd FileType gitcommit setlocal spell'

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

for ls, cfg in pairs({
  cssls = {
    capabilities = capabilities,
  },
  pylsp = {
    root_dir = lsp.util.root_pattern('.git', fn.getcwd()),
  },
  gopls = {},
  solargraph = {},
  tsserver = {},
  rust_analyzer = {},
}) do
  lsp[ls].setup(cfg)
end

-- luasnip setup
local luasnip = require 'luasnip'

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')
