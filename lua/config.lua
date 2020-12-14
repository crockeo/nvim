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
    for mode, keybinds in pairs(keymaps) do
        if mode == 'all' then
            mode = ''
        end

        for _, keybind in ipairs(keybinds) do
	    vim.api.nvim_set_keymap(mode, keybind[1], keybind[2], keybind[3])
        end
    end
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
