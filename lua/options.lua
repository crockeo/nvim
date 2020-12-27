local config = require('config')

local function init()
    config.set_options({
        backup = false,
        completeopt = 'menuone,noinsert',
        expandtab = true,
        hidden = true,
        nohlsearch = true,
        shiftwidth = 4,
        smarttab = true,
        softtabstop = 0,
        wrap = false,
        number = true,
        termguicolors = true,
    })
end

return {
    init = init,
}
