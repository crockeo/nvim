vim.g.python3_host_prog = vim.fn.expand('~/.config/nvim/venv/bin/python3')

-- plugs!!
local plug = require('plug')
local plug_dir = vim.fn.expand('~/.config/nvim/plugs')
plug
    .start(plug_dir)
    .install('airblade/vim-gitgutter')
    .install('crockeo/find-pytest.nvim')
    .install('neovim/nvim-lspconfig')
    .install('nvim-lua/completion-nvim')
    .install('nvim-lua/plenary.nvim')
    .install('nvim-telescope/telescope.nvim')
    .install('preservim/nerdtree')
    .install('rktjmp/lush.nvim')
    .install('saltstack/salt-vim')
    .install('tpope/vim-abolish')
    .install('tpope/vim-commentary')
    .install('tpope/vim-sensible')
    .install('tpope/vim-sleuth')
    .stop()

-- install a bunch of other configs
local sub_configs = {
    'colorscheme',
    'keymaps',
    'lsp',
    'options',
}
for _, config_name in ipairs(sub_configs) do
    local config = require(config_name)
    config.init()
end

vim.api.nvim_exec([[
set clipboard+=unnamedplus
autocmd BufWritePre * %s/\s\+$//e
]], false)

vim.api.nvim_exec([[
set wildcharm=<C-Z>
cnoremap <expr> <up> getcmdline()[:1] is 'e ' && wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> getcmdline()[:1] is 'e ' && wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> getcmdline()[:1] is 'e ' && wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> getcmdline()[:1] is 'e ' && wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
]], false)
