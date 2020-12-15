local config = require("config")

local function init()
    vim.fn["denite#custom#var"]("grep", "command", {"ag"})
    vim.fn["denite#custom#var"]("grep", "default_opts", {"-i", "--vimgrep"})
    vim.fn["denite#custom#var"]("grep", "recursive_opts", {})
    vim.fn["denite#custom#var"]("grep", "pattern_opt", {})
    vim.fn["denite#custom#var"]("grep", "separator", {"--"})
    vim.fn["denite#custom#var"]("grep", "final_opts", {})

    config.set_keymaps({
        all = {
            {"<C-c>b", ":Denite buffer<CR>", {}},
            {"<C-c>pa", ":Denite grep<CR>", {}},
        },
    })
end

return {
    init = init,
}
