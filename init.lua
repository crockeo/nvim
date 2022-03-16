local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = vim.fn.system({
        "git",
        "clone",
        "--depth=1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    })
end

require("packer").startup(function (use)
    use "wbthomason/packer.nvim"

    -- UI/UX
    use {
        "jnurmine/Zenburn",
        config = function()
            vim.api.nvim_command(":colorscheme zenburn")
        end,
    }
    use {
        "kyazdani42/nvim-web-devicons",
        run = function()
            require("nvim-web-devicons").get_icons()
        end,
        config = function()
            require("nvim-web-devicons").setup()
        end,
    }
    use {
        "nvim-lualine/lualine.nvim",
        after = "nvim-web-devicons",
        config = function()
            require("lualine").setup()
        end,
    }
    use {
        "nvim-telescope/telescope.nvim",
        config = function()
            require("telescope").load_extension("project")
            require("telescope").setup{
                extensions = {
                    project = {
                        base_dirs = {
                            "~/src",
                            "~/src/personal",
                            "~/src/tmp",
                        },
                    },
                },
            }
        end,
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-project.nvim"},
        },
    }
    use {
        "TimUntersberger/neogit",
        config = function()
            require("neogit").setup{
                integrations = {
                    diffview = true,
                },
            }
        end,
        requires = {
            {"nvim-lua/plenary.nvim"},
            {"sindrets/diffview.nvim"},
        },
    }

    -- Editing
    use "nvim-treesitter/nvim-treesitter"
    use {
        "neovim/nvim-lspconfig",
        config = function()
            local lspconfig = require("lspconfig")
            lspconfig.pyright.setup{}
        end,
    }
    use {
        "hrsh7th/nvim-cmp",
        after = "nvim-lspconfig",
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                expand = function(args)
                    require("snippy").expand_snippet(args.body)
                end,
                mapping = {
                    ["<C-g>"] = cmp.mapping.abort(),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i" }),
                    ["<CR>"] = cmp.mapping.confirm({ select = true })
                },
                sources = cmp.config.sources(
                    {
                        { name = "nvim_lsp" },
                    },
                    {
                        { name = "buffer" },
                    }
                )
            }
        end,
        requires = {
            {"dcampos/cmp-snippy"},
            {"dcampos/nvim-snippy"},
            {"hrsh7th/cmp-nvim-lsp"},
        },
    }
    use "tpope/vim-sleuth"

    if packer_bootstrap then
        require("packer").sync()
    end
end)

-- for whatever reason this doesn't work
-- when set from inside of lua,
-- so we just have some vimscript :(
vim.api.nvim_command("set clipboard+=unnamedplus")

vim.g.encoding = "UTF-8"
vim.g.guifont = "FiraCode Nerd Font:h14"
vim.g.hlsearch = false
-- vim.g.clipboard = "unnamedplus"
vim.wo.number = true
vim.wo.signcolumn = "yes"

-- non-standard options for
-- https://github.com/neovide/neovide
vim.g.neovide_cursor_animation_length = 0

vim.api.nvim_set_keymap("", "<C-g>", "<ESC>", {})

vim.api.nvim_set_keymap("n", "<C-c>pf", "<cmd>lua require('telescope.builtin').git_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>pa", "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>pp", "<cmd>lua require('telescope').extensions.project.project{}<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-x>g", ":Neogit<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("", "<C-a>", "^", {})
vim.api.nvim_set_keymap("", "<C-e>", "<END>", {})

vim.api.nvim_set_keymap("i", "<C-f>", "<ESC>", {})
vim.api.nvim_set_keymap("i", "<C-a>", "<ESC>^i", {})
vim.api.nvim_set_keymap("i", "<C-e>", "<END>", {})

vim.api.nvim_set_keymap("c", "<up>", "<expr> getcmdline()[:1] is 'e ' && wildmenumode() ? \"\\<left>\" : \"\\<up>\"", { noremap = true })
vim.api.nvim_set_keymap("c", "<down>", "<expr> getcmdline()[:1] is 'e ' && wildmenumode() ? \"\\<right>\" : \"\\<down>\"", { noremap = true })
vim.api.nvim_set_keymap("c", "<left>", "<expr> getcmdline()[:1] is 'e ' && wildmenumode() ? \"\\<up>\" : \"\\<left>\"", { noremap = true })
vim.api.nvim_set_keymap("c", "<right>", "<expr> getcmdline()[:1] is 'e ' && wildmenumode() ? \"\\<bs><C-z>\" : \"\\<right>\"", { noremap = true })
