-- 'start' starts a plug block, a la 'call plug#begin(...)'
local function start(path)
    vim.fn["plug#begin"](path)
end

-- 'end' stops a plug block, a la 'call plug#end(...)'
local function stop()
    vim.fn["plug#end"]()
end

-- 'install' installs a plugin from vim-plug, a la 'Plug "..."'
local function install(path)
    vim.fn["plug#"](path)
end

return {
    start = start,
    stop = stop,
    install = install,
}
