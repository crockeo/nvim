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

-- configuration!!! wooh!
local config = require('config')
-- TODO: make this work inside of set_keymaps
config.set_keymaps({
    all = {
        {'<C-a>', '<Home>', {}},
        {'<C-e>', '<End>', {}},
        {'<C-g>', '<ESC>', {}}, -- listen i miss emacs, ok?
    },
    c = {
        {'<C-g>', '<ESC>', {}}, -- ...i really miss emacs
    },
    i = {
        {'<C-a>', '<Home>', {}},
        {'<C-e>', '<End>', {}},
        {'<C-f>', '<ESC>', {}},
    },
    n = {
        {'<C-c>c', 'gc<Right>', {}},
	{'<C-x><C-f>', ':e ', {}}, -- oh dear god why won't she (emacs) take me back
        {';', ':b#<CR>', {}},
    },
    v = {
        {'<C-c>c', 'gc', {}},
    },
})
config.set_options({
    -- TODO: figure out why it doesn't like backspace
    -- backspace = 'indenteol,start',
    backup = false,
    expandtab = true,
    number = true,
    shiftwidth = 4,
    softtabstop = 4,
    tabstop = 4,
    wrap = false,
})

-- setting up LSP
-- local lspconfig = require('lspconfig')

-- lspconfig.clangd.setup{}
-- lspconfig.gopls.setup{}
-- lspconfig.pyls_ms.setup{}
