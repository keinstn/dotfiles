local api, cmd, fn, g = vim.api, vim.cmd, vim.fn, vim.g
local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  api.nvim_set_keymap(mode, lhs, rhs, options)
end

local function opt(scope, key, value)
  scopes[scope][key] = value
  if scope ~= "o" then
    scopes["o"][key] = value
  end
end

-------------------- GLOBAL --------------------------------
g.mapleader = ","

-------------------- PLUGINS -------------------------------
-- Bootstrap lazy.nvim
local ensure_lazy = function()
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)
end

ensure_lazy()

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    {
      "NeogitOrg/neogit",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
      },
      config = true,
      keys = {
        { "<leader>n", "<cmd>Neogit<cr>", desc = "Neogit" },
      },
    },
    { "L3MON4D3/LuaSnip" },
    {
      "aserowy/tmux.nvim",
      config = function()
        require("tmux").setup()

        -- TODO:
        -- Map the key to move right pane explicitly because
        -- the default key mapping does not work on MacOS
        if vim.loop.os_uname().sysname == "Darwin" then
          map("n", "C-l", "<cmd>lua require('tmux').move_right()<cr>")
        end
      end,
    },
    {
      "utilyre/barbecue.nvim",
      name = "barbecue",
      version = "*",
      dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons",
      },
      opts = {},
    },
    {
      "ervandew/supertab",
      config = function()
        vim.g.SuperTabDefaultCompletionType = "<c-n>"
      end,
    },
    {
      "folke/tokyonight.nvim",
      lazy = true,
      config = function()
        require("tokyonight").setup({ transparent = vim.g.transparent_enabled })
      end,
    },
    {
      "folke/which-key.nvim",
      event = "VeryLazy",
      keys = {
        {
          "<leader>?",
          function()
            require("which-key").show({ global = false })
          end,
          desc = "Buffer Local Keymaps (which-key)",
        },
      },
    },
    { "f-person/git-blame.nvim" },
    { "brenoprata10/nvim-highlight-colors" },
    {
      "hrsh7th/nvim-cmp",
      dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "saadparwaiz1/cmp_luasnip",
      },
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup({})
      end,
    },
    {
      "junegunn/vim-easy-align",
      lazy = false,
      config = function()
        map("n", "ga", "<Plug>(EasyAlign)")
        map("x", "ga", "<Plug>(EasyAlign)")
      end,
    },
    { "lukas-reineke/indent-blankline.nvim" },
    {
      "lewis6991/gitsigns.nvim",
      config = function()
        require("gitsigns").setup()
      end,
    },
    {
      "nvim-lualine/lualine.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("lualine").setup()
      end,
    },
    {
      "mattn/emmet-vim",
      config = function()
        vim.g.user_emmet_leader_key = "<C-Z>"
      end,
    },
    { "mechatroner/rainbow_csv" },
    { "mfussenegger/nvim-dap" },
    { "neovim/nvim-lspconfig" },
    {
      "numToStr/Comment.nvim",
      config = function()
        require("Comment").setup()
      end,
    },
    {
      "nvim-flutter/flutter-tools.nvim",
      lazy = false,
      dependencies = {
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
      },
      config = function()
        require("flutter-tools").setup({
          fvm = true,
          widget_guides = {
            enabled = true,
          },
        })
      end,
    },
    { "nvim-lua/plenary.nvim" },
    { "nvim-lua/popup.nvim" },
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      keys = {
        { "<leader>ft", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
      },
    },
    {
      "nvim-telescope/telescope.nvim",
      keys = {
        { ";", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Telescope Find Files" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Telescope Live Grep" },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Telescope Find Buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Telescope Help Tags" },
      },
    },
    {
      "nvim-treesitter/nvim-treesitter",
      build = ":TSUpdate",
    },
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      dependencies = "nvim-treesitter/nvim-treesitter",
    },
    { "segeljakt/vim-silicon" },
    {
      "stevearc/conform.nvim",
      config = function()
        require("conform").setup({
          formatters_by_ft = {
            lua = { "stylua" },
            python = { "isort", "ruff", "black" },
            rust = { "rustfmt" },
            javascript = { "prettierd", "prettier", stop_after_first = true },
          },
          format_on_save = {
            timeout_ms = 500,
            lsp_format = "fallback",
          },
        })
      end,
    },
    { "tpope/vim-repeat" },
    {
      "windwp/nvim-autopairs",
      event = "InsertEnter",
      config = true,
    },
    {
      "williamboman/mason.nvim",
      build = ":MasonUpdate",
      dependencies = {
        "williamboman/mason-lspconfig.nvim",
      },
      config = function()
        require("mason").setup()
        require("mason-lspconfig").setup()
      end,
    },
    {
      "xiyaowong/transparent.nvim",
      config = function()
        require("transparent").clear_prefix("neogit")
        require("transparent").clear_prefix("NeoTree")
      end,
    },
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})

-------------------- OPTIONS -------------------------------
local indent, width = 4, 80
cmd("colorscheme tokyonight-moon")
opt("b", "expandtab", true) -- Use spaces instead of tabs
opt("b", "formatoptions", "crqnj") -- Automatic formatting options
opt("b", "shiftwidth", indent) -- Size of an indent
opt("b", "smartindent", true) -- Insert indents automatically
opt("b", "tabstop", indent) -- Number of spaces tabs count for
opt("b", "textwidth", width) -- Maximum width of text
opt("o", "completeopt", "menuone,noinsert,noselect") -- Completion options
opt("o", "hidden", true) -- Enable background buffers
opt("o", "ignorecase", true) -- Ignore case
opt("o", "joinspaces", false) -- No double spaces with join
opt("o", "scrolloff", 4) -- Lines of context
opt("o", "shiftround", true) -- Round indent
opt("o", "sidescrolloff", 8) -- Columns of context
opt("o", "smartcase", true) -- Don't ignore case with capitals
opt("o", "splitbelow", true) -- Put new windows below current
opt("o", "splitright", true) -- Put new windows right of current
opt("o", "termguicolors", true) -- True color support
opt("o", "updatetime", 100) -- Delay before swap file is saved
opt("o", "clipboard", "unnamedplus") -- Clipboard
opt("w", "colorcolumn", tostring(width)) -- Line length marker
opt("w", "cursorline", true) -- Highlight cursor line
opt("w", "list", true) -- Show some invisible characters
opt("w", "number", true) -- Show line numbers
opt("w", "signcolumn", "yes") -- Show sign column
opt("w", "wrap", false) -- Disable line wrap

-------------------- MAPPINGS ------------------------------
map("n", "<leader>ev", ":e $MYVIMRC<CR>")
map("n", "<leader>rv", ":luafile $MYVIMRC<CR>:echo 'Reloaded vimrc!'<CR>")

map("n", "<C-t>", "<cmd>tabnew<cr>")
map("n", "<C-c>", "<cmd>tabclose<cr>")
map("n", "<S-TAB>", "<cmd>tabnext<cr>")
map("n", "<C-TAB>", "<cmd>tabprevious<cr>")

-------------------- FILETYPES -----------------------------
cmd("autocmd FileType css setlocal sw=2 sts=2 ts=2 et")
cmd("autocmd FileType dart setlocal sw=2 sts=2 ts=2 et")
cmd("autocmd FileType go setlocal sw=4 sts=4 ts=4 noet")
cmd("autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et")
cmd("autocmd FileType lua setlocal sw=2 sts=2 ts=2 et")
cmd("autocmd FileType python setlocal sw=4 sts=4 ts=4 et")
cmd("autocmd FileType scss setlocal sw=2 sts=2 ts=2 et")
cmd("autocmd FileType gitcommit setlocal spell")
cmd("autocmd FileType terraform setlocal sw=2 sts=2 ts=2")

-------------------- TREE-SITTER ---------------------------
local ts = require("nvim-treesitter.configs")
ts.setup({
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
})

-------------------- LSP -----------------------------------
local lsp = require("lspconfig")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

for ls, cfg in pairs({
  cssls = {
    capabilities = capabilities,
  },
  dartls = {},
  lua_ls = {},
  intelephense = {},
  pyright = {
    root_dir = lsp.util.root_pattern(".git", fn.getcwd()),
  },
  gopls = {},
  powershell_es = {},
  ts_ls = {},
  terraformls = {},
  rust_analyzer = {},
  ruby_lsp = {},
  zls = {},
}) do
  lsp[ls].setup(cfg)
end

-------------------- NVIM-CMP ------------------------------
-- luasnip setup
local luasnip = require("luasnip")

-- nvim-cmp setup
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end,
    ["<S-Tab>"] = function(fallback)
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
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
  },
})

map("n", "<space>,", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>")
map("n", "<space>;", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>")
map("n", "<space>a", "<cmd>lua vim.lsp.buf.code_action()<CR>")
map("n", "<space>d", "<cmd>lua vim.lsp.buf.definition()<CR>")
map("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>")
map("n", "<space>h", "<cmd>lua vim.lsp.buf.hover()<CR>")
map("n", "<space>m", "<cmd>lua vim.lsp.buf.rename()<CR>")
map("n", "<space>r", "<cmd>lua vim.lsp.buf.references()<CR>")
map("n", "<space>s", "<cmd>lua vim.lsp.buf.document_symbol()<CR>")
