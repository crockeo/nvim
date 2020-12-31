-- TODO: feature checklist
--   * multi-pane workflow (have multiple files open at the same time)
--   * rust tooling:
--     * sometimes rls disconnects, complaining about neovim LSP misbeahving
--     * treesitter grammar for rust sometimes bugs out
--   * figure out how to make this config reproducible:
--     * identify TRANSITIVE dependencies
--     * ensure we can either set them up locally or download them online
--     * test this with a dockerfile?

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
    plug.install('nvim-lua/completion-nvim')
    plug.install('preservim/nerdtree')
    plug.install('Shougo/denite.nvim')
    plug.install('tpope/vim-commentary')
    plug.install('tpope/vim-sensible')
    plug.install('tpope/vim-sleuth')
plug.stop()

-- install a bunch of other configs
local sub_configs = {
    'colorscheme',
    'keymaps',
    'lsp',
    'options',
    'plug_config/denite',
}
for _, config_name in ipairs(sub_configs) do
    local config = require(config_name)
    config.init()
end

vim.api.nvim_exec([[
set clipboard+=unnamedplus
]], false)
