local hawaii_background = "#332a24"
local hawaii_background_light = "#594a3e"
local hawaii_background_dark = "#26201b"
local hawaii_comment = "#997e6d"
local hawaii_highlight_blue = "#79eaf2"
local hawaii_highlight_green = "#aff279"
local hawaii_highlight_orange = "#ffb080"
local hawaii_highlight_purple = "#bb80ff"
local hawaii_highlight_red = "#ff4040"
local hawaii_text = "#ffffff"

-- TODO:
--   * #include directives (purple bold)
--   * const
--   * headers in markdown
--   * std in use std::fs::... in Rust
--   * println! in rust too
--   * on-hover has a bunch of red for python

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
        {"Boolean", "Constant", "Float", "Number", "Type", "Special"}
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
    set_color("Pmenu", {guibg = hawaii_background_light})
    set_color("PmenuSel", {guifg = hawaii_background, guibg = hawaii_highlight_orange})
    set_color("StatusLine", {guifg = hawaii_background_dark, guibg = hawaii_comment})
    set_color("StatusLineNC", {guifg = hawaii_background_dark, guibg = hawaii_comment})
    set_color("Structure", {guifg = hawaii_text, gui = "NONE"})
    set_color("Todo", {guifg = hawaii_highlight_red, guibg = hawaii_background, gui = "bold"})
    set_color("Visual", {guifg = hawaii_background, guibg = hawaii_highlight_orange})

    -- TODO: confirmed need this
    -- :hi Cursor guibg=khaki guifg=slategrey
    -- :hi VertSplit guibg=#c2bfa5 guifg=grey40 gui=none cterm=reverse
    -- :hi Folded guibg=black guifg=grey40 ctermfg=grey ctermbg=darkgrey
    -- :hi FoldColumn guibg=black guifg=grey20 ctermfg=4 ctermbg=7
    -- :hi IncSearch guifg=green guibg=black cterm=none ctermfg=yellow ctermbg=green
    -- :hi ModeMsg guifg=goldenrod cterm=none ctermfg=brown
    -- :hi MoreMsg guifg=SeaGreen ctermfg=darkgreen
    -- :hi Question guifg=springgreen ctermfg=green
    -- :hi Search guibg=peru guifg=wheat cterm=none ctermfg=grey ctermbg=blue
    -- :hi SpecialKey guifg=yellowgreen ctermfg=darkgreen
    -- :hi Title guifg=gold gui=bold cterm=bold ctermfg=yellow
    -- :hi WarningMsg guifg=salmon ctermfg=1
    -- :hi Special guifg=darkkhaki ctermfg=brown
    --
    -- TODO: don't know if i need this
    -- :hi Include guifg=red ctermfg=red
    -- :hi PreProc guifg=red guibg=white ctermfg=red
    -- :hi Operator guifg=Red ctermfg=Red
    -- :hi Define guifg=gold gui=bold ctermfg=yellow
    -- :hi Type guifg=CornflowerBlue ctermfg=2
    -- :hi Function guifg=navajowhite ctermfg=brown
    -- :hi Structure guifg=green ctermfg=green
    -- :hi LineNr guifg=grey50 ctermfg=3
    -- :hi Ignore guifg=grey40 cterm=bold ctermfg=7
    -- :hi Todo guifg=orangered guibg=yellow2
    -- :hi Directory ctermfg=darkcyan
    -- :hi ErrorMsg cterm=bold guifg=White guibg=Red cterm=bold ctermfg=7 ctermbg=1
    -- :hi VisualNOS cterm=bold,underline
    -- :hi WildMenu ctermfg=0 ctermbg=3
    -- :hi DiffAdd ctermbg=4
    -- :hi DiffChange ctermbg=5
    -- :hi DiffDelete cterm=bold ctermfg=4 ctermbg=6
    -- :hi DiffText cterm=bold ctermbg=1
    -- :hi Underlined cterm=underline ctermfg=5
    -- :hi Error guifg=White guibg=Red cterm=bold ctermfg=7 ctermbg=1
    -- :hi SpellErrors guifg=White guibg=Red cterm=bold ctermfg=7 ctermbg=1
end

return {
    init = init,
}
