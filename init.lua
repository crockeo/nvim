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
vim.g.mapleader = " "

vim.keymap.set("i", "<C-a>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Esc>")
vim.keymap.set("n", "<leader>/", ":FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "ga", ":b#<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set({"n", "v"}, "<C-a>", "^")
vim.keymap.set({"n", "v"}, "<C-e>", "<End>")

-----------------
-- Set Options --
-----------------
vim.cmd("set nohlsearch")
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes" 
vim.opt.softtabstop = 4
vim.opt.tabstop = 4
vim.opt.updatetime = 300


vim.cmd([[
set clipboard+=unnamedplus
]])

---------------------
-- Install Plugins --
---------------------
require("lazy").setup({
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
    },
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

      -- Godot
      lspconfig.gdscript.setup({
        capabilities = capabilities,
        filetypes = { "gd", "gdscript" },
      })

      -- Python
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        settings = {
          basedpyright = {
            autoImportCompletions = true,
            autoSearchPaths = true,
            analysis = {
              typeCheckingMode = "standard",
              useLibraryCodeForTypes = true,
            },
          },
        },
      })
      lspconfig.ruff.setup({ capabilities = capabilities })

      -- Rust
      lspconfig.rust_analyzer.setup({ capabilities = capabilities })

      -- Terraform
      lspconfig.terraformls.setup({ capabilities = capabilities })

      -- Typescript
      lspconfig.ts_ls.setup({
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
        -- preview_opts = "hidden",
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        additional_vim_regex_highlighting = false,
        auto_install = true,
        ensure_installed = {
          "c", 
          "gdscript",
          "go",
          "lua",
          "python",
          "terraform",
          "vim",
        },
        highlight = { enable = true },
        indent = { enable = true },
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

-------------------
-- Custom Config --
-------------------

-- Sets up format on save.
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("lsp", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client or not client.server_capabilities.documentFormattingProvider then
      return
    end

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = args.buf,
      callback = function()
        vim.lsp.buf.format {async = false, id = args.data.client_id }
      end,
    })
  end
})

-- Make hovering open typing information + diagnostic information.
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if not current_line_has_diagnostics() then
      if lsp_can_hover() then
        vim.lsp.buf.hover()
      end
      return
    end
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

function current_line_has_diagnostics()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1 
  local diagnostics = vim.diagnostic.get(0, { lnum = line })
  return #diagnostics > 0
end

function lsp_can_hover()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in pairs(clients) do
    if client.server_capabilities.hoverProvider then
      return true
    end
  end
  return false
end

