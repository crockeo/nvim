local config = require('config')

local function init()
    config.set_options({
        backup = false,
        completeopt = 'menuone,noinsert',
        expandtab = true,
        hidden = true,
        nohlsearch = true,
        shiftwidth = 4,
        signcolumn = 'yes',
        smarttab = true,
        softtabstop = 0,
        wrap = false,
        number = true,
        termguicolors = true,
        updatetime = 350,
    })
end

return {
    init = init,
}
