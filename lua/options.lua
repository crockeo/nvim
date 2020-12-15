local config = require('config')

local function init()
    config.set_options({
        backup = false,
        -- TODO: move this into a plugin-specific configuration file!!
        completeopt = 'menuone,noinsert,noselect',
        expandtab = true,
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