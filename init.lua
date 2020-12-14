-- bootstrapping plug :)
local config_dir = '~/.config/nvim'
local plug_file = config_dir .. '/autoload/plug.vim'

if vim.fn.filereadable(vim.fn.expand(plug_file)) == 0 then
    os.execute(config_dir .. '/bootstrap_plug.sh')
end

-- plugs!!
local plug = require('lua/plug')
plug.start(config_dir .. '/plugs')
   plug.install('neovim/nvim-lspconfig')
   plug.install('tpope/vim-commentary')
   plug.install('tpope/vim-sensible')
plug.stop()

-- keymaps!
vim.api.nvim_set_keymap('', '<C-a>', '<Home>', {})
vim.api.nvim_set_keymap('', '<C-e>', '<End>', {})
vim.api.nvim_set_keymap('', '<C-x><C-f>', ':e ', {})
vim.api.nvim_set_keymap('', '<C-g>', '<ESC>', {})

vim.api.nvim_set_keymap('n', '<C-c>c', 'gc<Right>', {})
vim.api.nvim_set_keymap('n', ';', ':b#<CR>', {})
vim.api.nvim_set_keymap('n', '<C-c><C-r>', ':luafile %<CR>', {})

vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', {})
vim.api.nvim_set_keymap('i', '<C-e>', '<End>', {})
vim.api.nvim_set_keymap('i', '<C-f>', '<ESC>', {})

vim.api.nvim_set_keymap('v', '<C-c>c', 'gc', {})

-- misc config
configs = {
    -- TODO: figure out
    -- backspace = 'indenteol,start',
    backup = false,
    expandtab = true,
    number = true,
    shiftwidth = 4,
    softtabstop = 4,
    tabstop = 4,
    wrap = false,
}
for option, value in pairs(configs) do
    vim.api.nvim_set_option(option, value)
end

-- setting up LSP
-- local lspconfig = require('lspconfig')

-- lspconfig.clangd.setup{}
-- lspconfig.gopls.setup{}
-- lspconfig.pyls_ms.setup{}
