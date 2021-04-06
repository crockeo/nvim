-- TODO: feature checklist
--   * multi-pane workflow (have multiple files open at the same time)
--   * rust tooling:
--     * sometimes rls disconnects, complaining about neovim LSP misbeahving
--     * treesitter grammar for rust sometimes bugs out

vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/venv/bin/python3')

-- plugs!!
local plug = require('plug')
local plug_dir = vim.fn.expand('~/.config/nvim/plugs')
plug.start(plug_dir)
    plug.install('Shougo/denite.nvim')
    plug.install('airblade/vim-gitgutter')
    plug.install('crockeo/find-pytest.nvim')
    plug.install('crockeo/orgmode-nvim')
    plug.install('neoclide/coc.nvim')
    plug.install('nvim-lua/completion-nvim')
    plug.install('preservim/nerdtree')
    plug.install('rktjmp/lush.nvim')
    plug.install('saltstack/salt-vim')
    plug.install('tpope/vim-abolish')
    plug.install('tpope/vim-commentary')
    plug.install('tpope/vim-sensible')
    plug.install('tpope/vim-sleuth')
    plug.install('vimwiki/vimwiki')
plug.stop()

if vim.fn.isdirectory(plug_dir) == 0 then
    vim.fn.nvim_command('PlugInstall')
    vim.fn.nvim_command('quit')
end

-- install a bunch of other configs
local sub_configs = {
    'colorscheme',
    'keymaps',
    'options',
    'plug_config/denite',
}
for _, config_name in ipairs(sub_configs) do
    local config = require(config_name)
    config.init()
end

vim.g.vimwiki_folding = 'expr'

vim.api.nvim_exec([[
set clipboard+=unnamedplus
autocmd BufWritePre * %s/\s\+$//e
]], false)
