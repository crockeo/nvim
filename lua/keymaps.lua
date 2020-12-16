local config = require('config')

local function init()
    config.set_keymaps({
        all = {
            {'<C-a>', '<Home>', {}},
            {'<C-c>jg', '<cmd>lua vim.lsp.buf.definition()<CR>', {}},
            {'<C-c>jb', '<C-o>', {}},
            {'<C-e>', '<End>', {}},
            {'<C-g>', '<ESC>', {}},
            {'<C-x><Left>', ':tabp<CR>', {}},
            {'<C-x><Right>', ':tabn<CR>', {}},
            {'<C-x>1', '<C-w>o', {}},
        },
        c = {
            {'<C-g>', '<C-c>', {}},
        },
        i = {
            {'<C-a>', '<Home>', {}},
            {'<C-e>', '<End>', {}},
            {'<C-f>', '<ESC>', {}},
        },
        n = {
            {'<C-c>c', 'gc<Right>', {}},
            {'<C-c>d', ':NERDTreeToggle<CR>', {}},
            {'<C-c>s', '<cmd>lua vim.lsp.buf.formatting()<CR>', {}},
            {'<C-x><C-f>', ':e ', {}},
            {'<C-x>o', '<C-w>w', {}},
            {';', ':b#<CR>', {}},
        },
        v = {
            {'<C-c>c', 'gc', {}},
        },
    })
end

return {
    init = init,
}
