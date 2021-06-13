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
    plug.install('Shougo/denite.nvim', 'fb8174a07c3a19091bfdbfc9439a15466d1649fa')
    plug.install('airblade/vim-gitgutter', 'f4bdaa4e9cf07f62ce1161a3d0ff70c8aad25bc5')
    plug.install('crockeo/find-pytest.nvim', 'e0cbba8fe6bced8e47499a5701daa5198c940d72')
    plug.install('crockeo/orgmode-nvim', '3f02d64981523f42b7c69b7feac17d73c9544363')
    plug.install('neoclide/coc.nvim', '17494990ab110b70aec3d7c97707448c6d3e72c9')
    plug.install('nvim-lua/completion-nvim', '8bca7aca91c947031a8f14b038459e35e1755d90')
    plug.install('nvim-treesitter/nvim-treesitter', '5634b175c42a3765405060e7407330d354c69369')
    plug.install('preservim/nerdtree', '81f3eaba295b3fceb2d032db57e5eae99ae480f8')
    plug.install('rktjmp/lush.nvim', '19b7cf9217abfc50c5ae9048d1cedd15e0349131')
    plug.install('saltstack/salt-vim', '6ca9e3500cc39dd417b411435d58a1b720b331cc')
    plug.install('tools-life/taskwiki', '48e24b03c079be43e296981b2ed0a464bbb710d2')
    plug.install('tpope/vim-abolish', '3f0c8faadf0c5b68bcf40785c1c42e3731bfa522')
    plug.install('tpope/vim-commentary', '349340debb34f6302931f0eb7139b2c11dfdf427')
    plug.install('tpope/vim-sensible', '2d9f34c09f548ed4df213389caa2882bfe56db58')
    plug.install('tpope/vim-sleuth', '38bd4010110614822cde523ebc5724963312ab63')
    plug.install('vimwiki/vimwiki', '619f04f89861c58e5a6415a4f83847752928252d')
plug.stop()

if vim.fn.isdirectory(plug_dir) == 0 then
    vim.api.nvim_command('PlugInstall')
    vim.api.nvim_command('quit')
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

vim.api.nvim_exec([[
set wildcharm=<C-Z>
cnoremap <expr> <up> getcmdline()[:1] is 'e ' && wildmenumode() ? "\<left>" : "\<up>"
cnoremap <expr> <down> getcmdline()[:1] is 'e ' && wildmenumode() ? "\<right>" : "\<down>"
cnoremap <expr> <left> getcmdline()[:1] is 'e ' && wildmenumode() ? "\<up>" : "\<left>"
cnoremap <expr> <right> getcmdline()[:1] is 'e ' && wildmenumode() ? " \<bs>\<C-Z>" : "\<right>"
]], false)
