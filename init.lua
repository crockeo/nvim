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
   plug.install('nvim-lua/completion-nvim')
   plug.install('Shougo/denite.nvim')
   plug.install('tpope/vim-commentary')
   plug.install('tpope/vim-sensible')
plug.stop()

-- install a bunch of other configs
local sub_configs = {
    require('colorscheme'),
    require('keymaps'),
    require('lsp'),
    require('options'),
    require('plug_config/denite'),
}
for _, sub_config in ipairs(sub_configs) do
    sub_config.init()
end
