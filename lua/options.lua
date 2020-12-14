local config = require('config')

local function init()
    config.set_options({
        backup = false,
        completeopt = 'menuone,noinsert,noselect',
        expandtab = true,
        shiftwidth = 4,
        smarttab = true,
        softtabstop = 0,
        wrap = false,
        number = true,
    })
end

return {
    init = init,
}
