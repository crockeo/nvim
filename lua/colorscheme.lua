local hawaii_background = "#332a24"
local hawaii_background_light = "#40352d"
local hawaii_background_dark = "#26201b"
local hawaii_comment = "#997e6d"
local hawaii_highlight_blue = "#79eaf2"
local hawaii_highlight_green = "#aff279"
local hawaii_highlight_orange = "#ffb080"
local hawaii_highlight_purple = "#bb80ff"
local hawaii_highlight_red = "#ff4040"
local hawaii_text = "#ffffff"

local function set_color(category, config)
    local config_parts = {}
    for key, value in pairs(config) do
        config_parts[#config_parts + 1] = string.format("%s=%s", key, value)
    end

    local config_str = ""
    for i, config_part in ipairs(config_parts) do
        config_str = config_str .. config_part
        if not (i == #config_parts) then
            config_str = config_str .. " "
        end
    end

    return vim.fn.nvim_command(string.format("highlight %s %s", category, config_str))
end

local function set_stylegroup(config, categories)
    for _, category in ipairs(categories) do
        set_color(category, config)
    end
end

local function init()
    -- Builtins
    set_stylegroup(
        {guifg = hawaii_highlight_purple},
        {"Boolean", "Constant", "Float", "Number"}
    )

    -- Stringlikes
    set_stylegroup(
        {guifg = hawaii_highlight_orange},
        {"Character", "String"}
    )

    -- Control functionality
    set_stylegroup(
        {guifg = hawaii_highlight_blue, gui="NONE"},
        {"Conditional", "Exception", "Identifier", "Keyword", "Label", "Repeat", "Statement"}
    )

    -- Variable-like
    set_stylegroup(
        {guifg = hawaii_highlight_green},
        {"Function"}
    )

    -- Comment-like
    set_stylegroup(
        {guifg = hawaii_comment},
        {"Comment", "LineNr"}
    )

    -- Hidden
    set_stylegroup(
        {guifg = hawaii_background, guibg = hawaii_background},
        {"NonText", "SignColumn"}
    )

    set_color("Normal", {guifg = hawaii_text, guibg=hawaii_background})
    set_color("StatusLine", {guibg = hawaii_background_dark})
    set_color("Todo", {guifg = hawaii_highlight_red, guibg = hawaii_background, gui = "bold"})
    set_color("Visual", {guifg = hawaii_background, guibg = hawaii_highlight_orange})

    set_color("Pmenu", {guibg = hawaii_background_light})
    set_color("PmenuSel", {guifg = hawaii_background, guibg = hawaii_highlight_orange})
end

return {
    init = init,
}
