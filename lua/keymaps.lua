local config = require("config")

local function init()
    config.set_keymaps({
        all = {
            {"<C-a>", "^", {}},
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
            {"<C-c>pt", ":YankPytest<CR>", {}},
            {"<C-c>pb", "<cmd>lua require('telescope.builtin').buffers()<cr>", {}},
            {"<C-c>pf", "<cmd>lua require('telescope.builtin').find_files()<cr>", {}},
            {"<C-c>pa", "<cmd>lua require('telescope.builtin').live_grep()<cr>", {}},
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
