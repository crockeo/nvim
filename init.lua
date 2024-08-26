local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------
-- Set Keymaps --
-----------------
vim.keymap.set("i", "<C-a>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Esc>")
vim.keymap.set("n", "<Space>/", ":FzfLua live_grep<CR>")
vim.keymap.set("n", "<Space>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<Space>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<Space>k", vim.lsp.buf.signature_help)
vim.keymap.set("n", "ga", ":b#<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set({"n", "v"}, "<C-a>", "^")
vim.keymap.set({"n", "v"}, "<C-e>", "<End>")

-----------------
-- Set Options --
-----------------
vim.cmd("set nohlsearch")
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.signcolumn = "yes" 


vim.cmd([[
set clipboard+=unnamedplus
]])

---------------------
-- Install Plugins --
---------------------
require("lazy").setup({
  {
    "github/copilot.vim",
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
    },
    config = function()
      local cmp = require("cmp");
      cmp.setup({
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm(),
          ["<Up>"] = cmp.mapping.select_prev_item(),
          ["<Down>"] = cmp.mapping.select_next_item(),
        },
        sources = {
          { name = "copilot" },
          { name = "nvim_lsp" },
        },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function ()
      require("gitsigns").setup()
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {"hrsh7th/cmp-nvim-lsp"},
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      lspconfig.gdscript.setup({
        capabilities = capabilities,
        filetypes = { "gd", "gdscript" },
      })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.tsserver.setup({
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      })
    end,
    init = function()
      vim.g.coq_settings = {
        auto_start = "shut-up",
      }
    end,
  },
  {
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup({
        toggler = {
          line = "<C-c>"
        },
        opleader = {
          line = "<C-c>",
        }
      })
    end,
  },
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({
        preview_opts = "hidden",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter").setup({
        auto_install = true,
        ensure_installed = {
          "c", 
          "gdscript",
          "go",
          "lua",
          "python",
          "vim",
        },
        highlight = { enable = true },
      })
    end,
  },
  {
    "tanvirtin/monokai.nvim",
    config = function()
      local monokai = require("monokai")
      monokai.setup({ palette = monokai.pro })
    end,
  },
  {"tpope/vim-sleuth"},
})
