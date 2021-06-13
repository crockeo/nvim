local io = require("io")

-- TODO: address concerns sometime:
--   * lots of direct execution of shell commands (cd, git rev-parse, pwd)
--   * path stuff isn't super clear, find better way to locate config directory

function string:split(sep)
   local sep, fields = sep or ":", {}
   local pattern = string.format("([^%s]+)", sep)
   self:gsub(pattern, function(c) fields[#fields+1] = c end)
   return fields
end

local function execute(command)
    local handle = io.popen(command)
    local result = handle:read("*all")
    handle:close()
    return result
end

local function load_locks(lock_path)
    local lock_file = assert(io.open(lock_path, "a+"))
    lock_file:seek("set", 0)
    local lock_contents = lock_file:read("*all")

    local locks = {}
    for _, line in ipairs(lock_contents:split("\n")) do
        local path_and_sha = line:split("=")
        locks[path_and_sha[1]] = path_and_sha[2]
    end

    return locks
end

local function save_locks(plug_directory, lock_path, needs_lock)
    -- we need to install plugins before we save them
    -- so that we can be sure they exist on disk
    vim.api.nvim_command('PlugInstall')
    vim.api.nvim_command('quit')

    local lock_file = assert(io.open(lock_path, "a"))
    local pwd = execute("pwd")
    local sha
    for plug in pairs(needs_lock) do
        local author_and_repo = plug:split("/")
        local path = plug_directory .. "/" .. author_and_repo[2]

        sha = execute("cd " .. path .. " && git rev-parse HEAD")
        lock_file:write(plug .. "=" .. sha)
    end
end

local function start(plug_directory)
    local obj = {}

    local lock_path = plug_directory .. "/../plug.lock"
    local locks = load_locks(lock_path)
    local needs_lock = {}

    obj.install = function(path)
        if locks[path] ~= nil then
            vim.fn["plug#"](path, { tag = locks[path] })
        else
            needs_lock[path] = true
            vim.fn["plug#"](path)
        end
        return obj
    end
    obj.stop = function()
        vim.fn["plug#end"]()

        -- we use iteration to detect if len(needs_lock) > 0
        -- because that doesn't actually exist in lua lmao
        for _ in pairs(needs_lock) do
            save_locks(plug_directory, lock_path, needs_lock)
            break
        end
    end

    vim.fn["plug#begin"](plug_directory)
    return obj
end

return {
    start = start,
}
