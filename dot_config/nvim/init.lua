-- ~/.config/nvim/init.lua - Modern Neovim Configuration
-- Neovim 0.8+ configuration with Lua

-- ============================================================================
-- General Settings
-- ============================================================================
vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

-- Basic options
local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.mouse = "a"
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true
opt.wrap = false
opt.breakindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.autoindent = true
opt.cursorline = true
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true
opt.undofile = true
opt.undodir = vim.fn.expand("~/.local/share/nvim/undo")
opt.backup = false
opt.writebackup = false
opt.swapfile = false
opt.updatetime = 300
opt.timeoutlen = 400
opt.completeopt = "menuone,noinsert,noselect"
opt.showmode = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.pumheight = 10
opt.laststatus = 3
opt.cmdheight = 1

-- Create undo directory if it doesn't exist
local undodir = vim.fn.expand("~/.local/share/nvim/undo")
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end

-- ============================================================================
-- Bootstrap lazy.nvim Plugin Manager
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugin Configuration
-- ============================================================================
require("lazy").setup({
  -- Colorschemes
  {
    "sainnhe/gruvbox-material",
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = "medium"
      vim.g.gruvbox_material_better_performance = 1
      vim.cmd("colorscheme gruvbox-material")
    end,
  },

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "gruvbox-material",
          icons_enabled = true,
          component_separators = "|",
          section_separators = "",
        },
      })
    end,
  },

  -- File explorer
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 30 },
        renderer = {
          group_empty = true,
          icons = { show = { git = true } },
        },
        filters = { dotfiles = false },
      })
    end,
  },

  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = "move_selection_next",
              ["<C-k>"] = "move_selection_previous",
            },
          },
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua", "vim", "vimdoc", "python", "javascript", "typescript",
          "go", "rust", "bash", "json", "yaml", "markdown", "html", "css"
        },
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = { enable = true },
      })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls", "pyright", "tsserver", "gopls", "rust_analyzer", "bashls"
        },
      })

      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- LSP servers
      lspconfig.lua_ls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({ capabilities = capabilities })
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })
      lspconfig.bashls.setup({ capabilities = capabilities })
    end,
  },

  -- Autocompletion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },

  -- Git integration
  { "tpope/vim-fugitive" },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add = { text = "+" },
          change = { text = "~" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
        },
      })
    end,
  },

  -- Code editing helpers
  { "tpope/vim-surround" },
  { "tpope/vim-commentary" },
  { "tpope/vim-repeat" },
  { "windwp/nvim-autopairs", config = true },

  -- Indentation guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- Which-key (displays available keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Better escape
  {
    "max397574/better-escape.nvim",
    config = function()
      require("better_escape").setup({
        mapping = { "jk", "jj" },
        timeout = 200,
      })
    end,
  },

  -- Comments
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  },

  -- Formatting
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "black", "isort" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          go = { "gofmt" },
          rust = { "rustfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },
})

-- ============================================================================
-- Key Mappings
-- ============================================================================
local keymap = vim.keymap.set

-- Better escape
keymap("i", "jk", "<ESC>", { silent = true })

-- Clear search highlighting
keymap("n", "<leader><space>", ":nohlsearch<CR>", { silent = true })

-- Save and quit
keymap("n", "<leader>w", ":w<CR>", { silent = true })
keymap("n", "<leader>W", ":wq<CR>", { silent = true })
keymap("n", "<leader>q", ":q<CR>", { silent = true })
keymap("n", "<leader>Q", ":qa!<CR>", { silent = true })

-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", { silent = true })
keymap("n", "<C-j>", "<C-w>j", { silent = true })
keymap("n", "<C-k>", "<C-w>k", { silent = true })
keymap("n", "<C-l>", "<C-w>l", { silent = true })

-- Resize windows
keymap("n", "<M-j>", ":resize -2<CR>", { silent = true })
keymap("n", "<M-k>", ":resize +2<CR>", { silent = true })
keymap("n", "<M-h>", ":vertical resize -2<CR>", { silent = true })
keymap("n", "<M-l>", ":vertical resize +2<CR>", { silent = true })

-- Buffer navigation
keymap("n", "<leader>bn", ":bnext<CR>", { silent = true })
keymap("n", "<leader>bp", ":bprevious<CR>", { silent = true })
keymap("n", "<leader>bd", ":bdelete<CR>", { silent = true })

-- Move lines
keymap("v", "J", ":m '>+1<CR>gv=gv", { silent = true })
keymap("v", "K", ":m '<-2<CR>gv=gv", { silent = true })

-- Better indenting
keymap("v", "<", "<gv", { silent = true })
keymap("v", ">", ">gv", { silent = true })

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { silent = true })
keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", { silent = true })

-- Telescope
local builtin = require("telescope.builtin")
keymap("n", "<leader>ff", builtin.find_files, {})
keymap("n", "<leader>fg", builtin.live_grep, {})
keymap("n", "<leader>fb", builtin.buffers, {})
keymap("n", "<leader>fh", builtin.help_tags, {})
keymap("n", "<leader>fr", builtin.oldfiles, {})

-- LSP
keymap("n", "gd", vim.lsp.buf.definition, {})
keymap("n", "gD", vim.lsp.buf.declaration, {})
keymap("n", "gr", vim.lsp.buf.references, {})
keymap("n", "gi", vim.lsp.buf.implementation, {})
keymap("n", "K", vim.lsp.buf.hover, {})
keymap("n", "<leader>rn", vim.lsp.buf.rename, {})
keymap("n", "<leader>ca", vim.lsp.buf.code_action, {})
keymap("n", "<leader>f", function()
  require("conform").format({ async = true, lsp_fallback = true })
end, {})

-- Git
keymap("n", "<leader>gs", ":Git status<CR>", { silent = true })
keymap("n", "<leader>gc", ":Git commit<CR>", { silent = true })
keymap("n", "<leader>gp", ":Git push<CR>", { silent = true })

-- ============================================================================
-- Autocommands
-- ============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Remember cursor position
autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line("'\"") > 1 and vim.fn.line("'\"") <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Highlight on yank
autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 300 })
  end,
})

-- Remove trailing whitespace on save
autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

-- File type specific settings
autocmd("FileType", {
  pattern = { "javascript", "typescript", "json", "html", "css", "yaml", "yml" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
  end,
})

autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.opt_local.expandtab = false
  end,
})

autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
