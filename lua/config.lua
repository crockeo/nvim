local function set_keymaps_impl(set_keymap_fn, keymaps)
    for mode, keybinds in pairs(keymaps) do
        if mode == 'all' then
            mode = ''
        end

        for _, keybind in ipairs(keybinds) do
            set_keymap_fn(mode, keybind[1], keybind[2], keybind[3])
        end
    end
end

local function set_options_impl(set_option_fn, options)
    for option, value in pairs(options) do
        set_option_fn(option, value)
    end
end

local function set_keymaps(keymaps)
    set_keymaps_impl(vim.api.nvim_set_keymap, keymaps)
end

local function buf_set_keymaps(bufnr, keymaps)
    local function partial(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
    end
    set_keymaps_impl(partial, keymaps)
end

local function set_options(options)
    set_options_impl(vim.api.nvim_set_option, options)
end

local function buf_set_options(bufnr, options)
    local function partial(...)
        vim.api.nvim_buf_set_option(bufnr, ...)
    end
    set_options_impl(partial, options)
end

return {
    set_keymaps = set_keymaps,
    buf_set_keymaps = buf_set_keymaps,
    set_options = set_options,
    buf_set_options = buf_set_options,
}
