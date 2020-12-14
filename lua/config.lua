-- set_keymaps sets a bunch of keymaps w/ nvim_set_keymap using the syntax:
--
-- set_keymaps({
--     -- all modes
--     all = {
--          {'<C-c>c', 'gc<Right>', {}},
--     },
--     -- specific mode (e.g. i, n, v, etc.)
--     -- this one happens to be visual mode
--     v = {
--          {'<C-c>c', 'gc', {}},
--     },
-- })
--
-- Which translates into one keybind for everything, and another keybind for
-- visual mode that both comment stuff out with vim-commentary.
local function set_keymaps(keymaps)
    -- TODO: migrate setting keymaps to the keymaps provided; should be equivalent just defined in main file
    vim.api.nvim_set_keymap('', '<C-a>', '<Home>', {})
    vim.api.nvim_set_keymap('', '<C-e>', '<End>', {})
    vim.api.nvim_set_keymap('', '<C-x><C-f>', ':e ', {})
    vim.api.nvim_set_keymap('', '<C-g>', '<ESC>', {})

    vim.api.nvim_set_keymap('n', '<C-c>c', 'gc<Right>', {})
    vim.api.nvim_set_keymap('n', ';', ':b#<CR>', {})

    vim.api.nvim_set_keymap('i', '<C-a>', '<Home>', {})
    vim.api.nvim_set_keymap('i', '<C-e>', '<End>', {})
    vim.api.nvim_set_keymap('i', '<C-f>', '<ESC>', {})

    vim.api.nvim_set_keymap('v', '<C-c>c', 'gc', {})

    vim.api.nvim_set_keymap('c', '<C-g>', '<ESC>', {})
end

-- set_options sets a bunch of options w/ nvim_set_option using the syntax
-- 
-- set_options({
--     option_name = "option value or whatever",
-- })
local function set_options(options)
    for option, value in pairs(options) do
        vim.api.nvim_set_option(option, value)
    end
end

return {
    set_keymaps = set_keymaps,
    set_options = set_options,
}
