local lspconfig = require('lspconfig')

local function init()
    lspconfig.clangd.setup{}
    lspconfig.gopls.setup{}
    lspconfig.pyls_ms.setup{}
    lspconfig.sumneko_lua.setup{
        on_attach = require('completion').on_attach,
    }
end

return {
    init = init,
}
