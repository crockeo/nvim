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
    use "tpope/vim-sleuth"

    if packer_bootstrap then
        require("packer").sync()
    end
end)

vim.g.encoding = "UTF-8"
vim.g.guifont = "FiraCode Nerd Font:h14"
vim.g.hlsearch = false
vim.g.clipboard = "unnamedplus"
vim.wo.number = true
vim.wo.signcolumn = "yes"

-- non-standard options for
-- https://github.com/neovide/neovide
vim.g.neovide_cursor_animation_length = 0

vim.api.nvim_set_keymap("n", "<C-c>pf", "<cmd>lua require('telescope.builtin').git_files()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>pa", "<cmd>lua require('telescope.builtin').live_grep()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-c>pp", "<cmd>lua require('telescope').extensions.project.project{}<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-x>g", ":Neogit<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<C-f>", "<ESC>", {})
vim.api.nvim_set_keymap("i", "<C-a>", "<ESC>^i", {})
vim.api.nvim_set_keymap("i", "<C-e>", "<END>", {})
