-- TODOs:
-- * Make it so [g, ]g, and the other `[]` commands in helix work.
--   Especially:
--   - Git diff (mentioned above)
--   - Diagnostics `[]d`

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
  local filename = vim.fn.expand("%:.")
  vim.fn.setreg("+", filename)
end

local function copy_python_module()
  local filename = vim.fn.expand("%:.")
  local module = filename:gsub("%.py$", "")
  module = module:gsub("/", ".")
  module = module:gsub("%.__init__$", "")
  vim.fn.setreg("+", module)
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
      close_events = {"CursorMoved", "BufLeave", "WinLeave"},
      focus = false,
      focusable = false,
    })
  end
end

local function lsp_references()
  require("fzf-lua").lsp_references()
end

local function open(argument)
  os.execute(string.format("open %s", argument))
end

function open_pr_url()
  local git = require("neogit.lib.git")
  local origin_url = git.remote.get_url("origin")[1]
  local branch_name = git.branch.current()

  origin_url = string.gsub(origin_url, ":", "/", 1)
  origin_url = string.gsub(origin_url, "git@", "https://")
  local compare_url = string.format("%s/compare/%s?expand=1", origin_url, branch_name)
  open(compare_url)
end

-----------------
-- Set Keymaps --
-----------------
vim.g.mapleader = " "

vim.keymap.set("i", "<C-a>", "<Esc>^i")
vim.keymap.set("i", "<C-e>", "<End>")
vim.keymap.set("i", "<C-f>", "<Esc>")
vim.keymap.set("n", "<leader>'", ":FzfLua resume<CR>")
vim.keymap.set("n", "<leader>/", ":FzfLua live_grep<CR>")
vim.keymap.set("n", "<leader>b", ":FzfLua buffers<CR>")
vim.keymap.set("n", "<leader>c", vim.lsp.buf.code_action)
vim.keymap.set("n", "<leader>f", ":FzfLua files<CR>")
vim.keymap.set("n", "<leader>g", ":Neogit<CR>")
vim.keymap.set("n", "<leader>k", lsp_hover)
vim.keymap.set("n", "<leader>of", copy_filename)
vim.keymap.set("n", "<leader>om", copy_python_module)
vim.keymap.set("n", "<leader>oo", ":Oil %:h<CR>")
vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename)
vim.keymap.set("n", "ga", ":b#<CR>")
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "gr", lsp_references, { nowait = true })
vim.keymap.set({ "n", "v" }, "<C-a>", "^")
vim.keymap.set({ "n", "v" }, "<C-e>", "<End>")
vim.keymap.set({ "n", "v" }, "<leader>og", "<cmd>GitLink<CR>")

-----------------
-- Set Options --
-----------------
vim.cmd("set nohlsearch")
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.ignorecase = true
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.scrolloff = 12
vim.opt.shiftwidth = 4
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
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
    "andrewferrier/wrapping.nvim",
    config = function()
      require("wrapping").setup({
        softener = {
          markdown = true,
        }
      })
    end,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato",
      })
      vim.cmd.colorscheme("catppuccin")
    end,
    priority = 1000,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      -- library = {
      --   -- See the configuration section for more details
      --   -- Load luvit types when the `vim.uv` word is found
      --   { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      -- },
    },
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
    config = function()
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
    config = function()
      local neogit = require("neogit")
      neogit.setup({
        mappings = {
          status = {
            ["h"] = open_pr_url,
          }
        }
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Godot
      vim.lsp.config("gdscript", {
        capabilities = capabilities,
        filetypes = { "gd", "gdscript" },
      })
      vim.lsp.enable("gdscript")

      -- Golang
      vim.lsp.config("gopls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("gopls")

      -- Lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })
      vim.lsp.enable("lua_ls")

      -- Python
      vim.lsp.config("pyright", { capabilities = capabilities })
      vim.lsp.enable("pyright")

      -- vim.lsp.config("ty", { capabilities = capabilities })
      -- vim.lsp.enable("ty")

      vim.lsp.config("ruff", { capabilities = capabilities })
      vim.lsp.enable("ruff")

      -- Rust
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })
      vim.lsp.enable("rust_analyzer")

      -- Terraform
      vim.lsp.config("terraformls", { capabilities = capabilities })
      vim.lsp.enable("terraformls")

      -- Typescript
      local ts_config = {
        capabilities = capabilities,
        filetypes = {
          "javascript",
          "javascriptreact",
          "javascript.jsx",
          "typescript",
          "typescriptreact",
          "typescript.tsx",
        },
      }
      vim.lsp.config("biome", ts_config)
      vim.lsp.enable("biome")

      vim.lsp.config("ts_ls", ts_config)
      vim.lsp.enable("ts_ls")

      -- Zig
      vim.lsp.config("zls", { capabilities = capabilities })
      vim.lsp.enable("zls")
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
    "shortcuts/no-neck-pain.nvim",
    config = function()
      require("no-neck-pain").setup({
        width = 100,
      })
      vim.keymap.set("n", "<leader>l", ":NoNeckPain<CR>", { desc = "Toggle No Neck Pain" })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "markdown",
        callback = function()
          vim.cmd("NoNeckPain")
        end,
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
        grep = {
          cmd = "rg --column --line-number --no-heading --color=always --smart-case --hidden --glob '!.git/' --",
        },
        keymap = {
          builtin = {
            ["<Esc>"] = "hide",
          },
        },
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.openscad = {
        install_info = {
          url = "https://github.com/bollian/tree-sitter-openscad",
          files = { "src/parser.c" },
          branch = "master",
          generate_requires_npm = false,
          requires_generate_from_grammar = false,
        }
      }
      vim.filetype.add({
        extension = {
          scad = "openscad",
        },
      })

      require("nvim-treesitter.configs").setup({
        additional_vim_regex_highlighting = false,
        auto_install = true,
        ensure_installed = {
          "c",
          "gdscript",
          "go",
          "lua",
          "openscad",
          "python",
          "terraform",
          "vim",
        },
        highlight = { enable = true },
        indent = { enable = true },
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["ac"] = "@class.outer",
              ["af"] = "@function.outer",
              ["ic"] = "@class.inner",
              ["if"] = "@function.inner",
            },
          },
        },
      })
    end,
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "InsertEnter",
    opts = {
      bind = true,
      handler_opts = {
        border = "rounded"
      }
    },
  },
  {
    "stevearc/conform.nvim",
    config = function()
      local web_formatters = { "biome", "biome-check", "biome-organize-imports" };
      require("conform").setup({
        formatters_by_ft = {
          css = web_formatters,
          javascript = web_formatters,
          javascriptreact = web_formatters,
          json = web_formatters,
          python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
          rust = { "rustfmt" },
          terraform = { "terraform_fmt" },
          typescript = web_formatters,
          typescriptreact = web_formatters,
          zig = { "zigfmt" },
        },
        format_on_save = {
          timeout_ms = 500,
        },
      })
    end,
  },
  { "stevearc/dressing.nvim" },
  {
    "stevearc/oil.nvim",
    config = function()
      require("oil").setup()
    end,
  },
  { "tpope/vim-sleuth" },
  -- NOTE: Uncomment if in an environment where I can pay for AI :)
  -- {
  --   "yetone/avante.nvim",
  --   dependencies = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-treesitter/nvim-treesitter",
  --     "stevearc/dressing.nvim",
  --     -- Optional
  --     "ibhagwan/fzf-lua",
  --   },
  --   event = "VeryLazy",
  --   opts = {
  --     provider = "claude",
  --     providers = {
  --       claude = {
  --         endpoint = "https://api.anthropic.com",
  --         extra_request_body = {
  --           max_tokens = 4096,
  --           temperature = 0,
  --         },
  --         model = "claude-sonnet-4-20250514",
  --       },
  --     },
  --   },
  --   version = false,
  -- },
})

-------------------
-- Custom Config --
-------------------

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
