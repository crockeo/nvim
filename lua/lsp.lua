local config = require("config")
local nvim_lsp = require("lspconfig")

local servers = {
    "gopls",
    "pyright",
    "rust_analyzer",
}

local function on_attach(client, bufnr)
    config.buf_set_options(bufnr, {
        omnifunc = "v:lua.vim.lsp.omnifunc"
    })

    config.buf_set_keymaps(bufnr, {
        n = {
            {"<C-c>jb", "<cmd> lua require('jump').jump_back()<CR>", {}},
            {"<C-c>jg", "<cmd> lua require('jump').jump_def()<CR>", {}},
            {"<C-c>ji", "<cmd> lua require('jump').jump_impl()<CR>", {}},
            {"<C-c>jr", "<cmd> lua require('jump').jump_ref()<CR>", {}},
        }
    })
end

local function init()
    for _, server in ipairs(servers) do
        nvim_lsp[server].setup {
            on_attach = on_attach,
            flags = {
                debounce_text_changes = 150
            }
        }
    end
end

return {
    init = init,
}
