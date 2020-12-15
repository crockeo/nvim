local config = require("config")

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
end

return {
    init = init,
}
