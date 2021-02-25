local config = require("config")

local function init()
    config.set_keymaps({
        all = {
            {"<C-a>", "^", {}},
            {"<C-c>jb", "<cmd> lua require('jump').jump_from_definition()<CR>", {}},
            {"<C-c>jg", "<cmd> lua require('jump').jump_to_definition()<CR>", {}},
            {"<C-c>jr", "<Plug>(coc-references)", {}},
            {"<C-e>", "<End>", {}},
            {"<C-g>", "<ESC>", {}},
            {"<C-x>1", "<C-w>o", {}},
        },
        c = {
            {"<C-g>", "<C-c>", {}},
        },
        i = {
            {"<C-a>", "<ESC>^i", {}},
            {"<C-e>", "<End>", {}},
            {"<C-f>", "<ESC>", {}},
            {"<C-Space>", "<Plug>(completion_trigger)", {silent = true}},
        },
        n = {
            {"<C-c>c", "gc<Right>", {}},
            {"<C-c>d", ":NERDTreeToggle<CR>", {}},
            {"<C-c>k", ":bw<CR>", {}},
            {"<C-c>s", "<Plug>(coc-format)", {}},
            {"<C-x><C-f>", ":e ", {}},
            {"<C-x>o", "<C-w>w", {}},
            {";", ":b#<CR>", {}},
        },
        v = {
            {"<C-c>c", "gc", {}},
        },
    })
end

return {
    init = init,
}
