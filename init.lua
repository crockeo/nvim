-- TODOs:
-- * Open the type of a function's arguments when I'm typing inside of the parens for a function call.
--
-- * Better references pane (when doing `gr`)

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

----------------------
-- Custom Functions --
----------------------
local function copy_filename()
  local filename = vim.fn.expand("%")
  vim.fn.setreg("+", filename)
end

local function lsp_can_hover()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  for _, client in pairs(clients) do
    if client.server_capabilities.hoverProvider then
      return true
    end
  end
  return false
end

local function lsp_hover()
  if lsp_can_hover() then
    vim.lsp.buf.hover({
      border = "rounded",
      focusable = false,
    })
  end
end

-----------------
-- Set Keymaps --
-----------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-a>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Esc>")
vim.keymap.set("n", "<leader>/", ":FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>g", ":Neogit<CR>")
vim.keymap.set("n", "<leader>k", lsp_hover)
vim.keymap.set("n", "<leader>of", copy_filename)
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "ga", ":b#<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", vim.lsp.buf.references)
vim.keymap.set({"n", "v"}, "<C-a>", "^")
vim.keymap.set({"n", "v"}, "<C-e>", "<End>")
vim.keymap.set({"n", "v"}, "<leader>og", "<cmd>GitLink<CR>")

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
vim.opt.wrap = false


vim.cmd([[
set clipboard+=unnamedplus
]])

---------------------
-- Install Plugins --
---------------------
require("lazy").setup({
  {
    "catppuccin/nvim", name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
    priority = 1000,
  },
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
          ["<Down>"] = cmp.mapping.select_next_item(),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
          ["<Up>"] = cmp.mapping.select_prev_item(),
        },
        sources = {
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
    "linrongbin16/gitlinker.nvim",
    config = function()
      require("gitlinker").setup()
    end,
  },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "ibhagwan/fzf-lua",
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
    },
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

      -- Golang
      lspconfig.gopls.setup({
        capabilities = capabilities,
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
        winopts = {
          height = 0.85,
          width = 0.88,
          row = 0.35,
          col = 0.50,
          border = "rounded",
        },
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
  {"tpope/vim-sleuth"},
  {
    "yetone/avante.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      -- Optional
      "ibhagwan/fzf-lua",
    },
    event = "VeryLazy",
    opts = {
      provider = "claude",
      providers = {
        claude = {
          endpoint = "https://api.anthropic.com",
          extra_request_body = {
            max_tokens = 4096,
            temperature = 0,
          },
          model = "claude-sonnet-4-20250514",
        },
      },
    },
    version = false,
  },
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
local function current_line_has_diagnostics()
  local line = vim.api.nvim_win_get_cursor(0)[1] - 1 
  local diagnostics = vim.diagnostic.get(0, { lnum = line })
  return #diagnostics > 0
end

local function hover_window_exists()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(buf)
    if buf_name:match("^%[LSP%]") or vim.api.nvim_buf_get_option(buf, 'buftype') == 'nofile' then
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= '' then -- It's a floating window
        return true
      end
    end
  end
  return false
end

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    if hover_window_exists() then
      return
    end
    if not current_line_has_diagnostics() then
      lsp_hover()
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

