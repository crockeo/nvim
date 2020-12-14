-- TODO: feature checklist
--   * projectile-like features:
--     * switch to git project
--     * find file in git project
--     * find string in git project (ag)
--     * NICE TO HAVE: global find and replace in project WITH previews
--   * LSP support
--     * microsoft python language server
--     * clangd
--     * gopls
--     * rls
--   * jump to defn (will probably be through LSP?)
--   * file support for weird files
--     * bazel BUILD files
--     * saltstack files
--     * .proto files
--     * yaml
--   * dired-sidebar ish thing (i know this was originally stolen from vim so this should be ez)
--   * automatic generalized formatting
--   * buffer lookup / switch
--     * aka find recently opened file and switch to it
--   * multi-pane workflow (have multiple files open at the same time)
--   * probably more!! good luck :)
--   * nvim things:
--     * make TODOs not be so gaudy
--     * don't highlight everything in the file after a search/replace

-- bootstrapping plug :)
local config_dir = '~/.config/nvim'
local plug_file = config_dir .. '/autoload/plug.vim'

if vim.fn.filereadable(vim.fn.expand(plug_file)) == 0 then
    os.execute(config_dir .. '/bootstrap_plug.sh')
    -- TODO: i think i have to execute something here to load it the first time around
end

-- plugs!!
local plug = require('plug')
plug.start(config_dir .. '/plugs')
   plug.install('neovim/nvim-lspconfig')
   plug.install('Shougo/denite.nvim')
   plug.install('tpope/vim-commentary')
   plug.install('tpope/vim-sensible')
plug.stop()

local plug_configs = {
    require('plug_config/denite'),
}
for _, plug_config in ipairs(plug_configs) do
    plug_config.init()
end

-- configuration!!! wooh!
local config = require('config')
config.set_keymaps({
    all = {
        {'<C-a>', '<Home>', {}},
        {'<C-e>', '<End>', {}},
        {'<C-g>', '<ESC>', {}},
        {'<C-x><Left>', ':tabp<CR>', {}},
        {'<C-x><Right>', ':tabn<CR>', {}},
        {'<C-x>1', '<C-w>o', {}},
    },
    c = {
        {'<C-g>', '<ESC>', {}},
    },
    i = {
        {'<C-a>', '<Home>', {}},
        {'<C-e>', '<End>', {}},
        {'<C-f>', '<ESC>', {}},
    },
    n = {
        {'<C-c>c', 'gc<Right>', {}},
        {'<C-x><C-f>', ':e ', {}},
        {';', ':b#<CR>', {}},
    },
    v = {
        {'<C-c>c', 'gc', {}},
    },
})
config.set_options({
   backup = false,
   expandtab = true,
   shiftwidth = 4,
   smarttab = true,
   softtabstop = 0,
   wrap = false,
   number = true,
})

-- setting up LSP
local lspconfig = require('lspconfig')

lspconfig.clangd.setup{}
lspconfig.gopls.setup{}
lspconfig.pyls_ms.setup{}
