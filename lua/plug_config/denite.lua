local config = require("config")

local function ft_settings()
    -- TODO: migrate config from ftplugin/denite.vim over to here +
    -- ft_settings_filter to make sure everything stays in lua
end

local function ft_settings_filter()
    ft_settings()
end

local function init()
    vim.fn["denite#custom#var"]("grep", "command", {"ag"})
    vim.fn["denite#custom#var"]("grep", "default_opts", {"-i", "--vimgrep"})
    vim.fn["denite#custom#var"]("grep", "recursive_opts", {})
    vim.fn["denite#custom#var"]("grep", "pattern_opt", {})
    vim.fn["denite#custom#var"]("grep", "separator", {"--"})
    vim.fn["denite#custom#var"]("grep", "final_opts", {})

    vim.fn["denite#custom#var"]('file/rec', 'command', {'ag', '--follow', '--nocolor', '--nogroup', '-g', ''})

    config.set_keymaps({
        all = {
            {"<C-c>bf", ":Denite buffer<CR>", {}},
            {"<C-c>pa", ":DeniteProjectDir grep<CR>", {}},
            {"<C-c>pf", ":DeniteProjectDir file/rec<CR>", {}},
        },
    })

    local options = {
        highlight_matched_char = "QuickFixLine",
        highlight_matched_range = "Visual",
        prompt = "> ",
        start_filter = 1,
        winrow = 1,
        vertical_preview = 1,
    }
    for key, value in pairs(options) do
        vim.fn["denite#custom#option"]("default", key, value)
    end

    -- vim.api.nvim_exec([[
-- autocmd FileType denite lua require('plug_config/denite').ft_settings()
-- autocmd FileType denite-filter lua require('plug_config/denite').ft_settings_filter()
    -- ]], false)
end

return {
    ft_settings = ft_settings,
    ft_settings_filter = ft_settings_filter,
    init = init,
}
