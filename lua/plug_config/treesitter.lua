local function init()
    -- TODO: re-enable when it's not super broken
    require("nvim-treesitter.configs").setup {
        ensure_installed = "maintained",
        highlight = { enable = true },
    }
end

return {
    init = init,
}
