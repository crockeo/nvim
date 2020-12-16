-- TODO: feature checklist
--   * file support for weird files
--     * bazel BUILD files
--     * saltstack files
--     * .proto files
--     * yaml
--   * multi-pane workflow (have multiple files open at the same time)

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
    plug.install('nvim-treesitter/nvim-treesitter')
    plug.install('preservim/nerdtree')
    plug.install('Shougo/denite.nvim')
    plug.install('tpope/vim-commentary')
    plug.install('tpope/vim-sensible')
plug.stop()

-- install a bunch of other configs
local sub_configs = {
    'colorscheme',
    'keymaps',
    'lsp',
    'options',
    'plug_config/denite',
    'plug_config/treesitter',
}
for _, config_name in ipairs(sub_configs) do
    local config = require(config_name)
    config.init()
end
