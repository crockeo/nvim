local completion = require('completion')
local lspconfig = require('lspconfig')

local function on_attach(config)
    local function _on_attach()
        completion.on_attach()
        if config.hover then
            vim.api.nvim_exec([[
            function! LspHover()
                lua vim.lsp.buf.hover()
            endfunction

            autocmd CursorHold * call LspHover()
            autocmd CursorHoldI * call LspHover()
            ]],
            false)
        end
    end
    return _on_attach
end

local function init()
    lspconfig.clangd.setup{on_attach = on_attach({hover = true})}
    lspconfig.gopls.setup{}
    lspconfig.pyls_ms.setup{on_attach = on_attach({hover = true})}
    lspconfig.rust_analyzer.setup{on_attach = on_attach({hover = true})}
    lspconfig.sumneko_lua.setup{on_attach = on_attach({})}
end

return {
    init = init,
}
