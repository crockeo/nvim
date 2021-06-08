local lush = require('lush')
local hsl = lush.hsl

return lush(function()
    local background = hsl(24, 17, 17)
    local foreground = hsl(0, 100, 100)
    local comment = hsl(24, 25, 45)
    local background_light = background.lighten(20)
    local background_dark = background.darken(10)

    local highlight_red = hsl(0, 100, 70)
    local highlight_yellow = hsl(25, 90, 70)
    local highlight_green = hsl(120, 100, 80)
    local highlight_cyan = hsl(180, 100, 80)
    local highlight_blue = hsl(240, 100, 80)
    local highlight_magenta = hsl(270, 65, 65)

    return {
        Normal { fg = foreground, bg = background },

        Visual { fg = background, bg = highlight_yellow },

        Pmenu { bg = background_light },
        PmenuSel { fg = background, bg = highlight_yellow },

        StatusLine { fg = background, bg = comment },
        StatusLineNC { fg = StatusLine.fg, bg = StatusLine.bg },

        -- Hidden: NonText, SignColumn
        NonText { fg = background, bg = background },
        SignColumn { fg = background, bg = background },

        Comment { fg = comment },
        LineNr { fg = comment },
        LspDiagnosticsDefaultError { fg = comment },
        LspDiagnosticsDefaultWarning { fg = comment },
        LspDiagnosticsDefaultHint { fg = comment },
        LspDiagnosticsDefaultInformation { fg = comment },

        Error { fg = highlight_red, bg = "NONE" },
        ErrorMsg { fg = highlight_red, bg = "NONE" },
        Todo { fg = highlight_red },
        CocErrorSign { fg = highlight_red },

        String { fg = highlight_yellow },
        Character { fg = highlight_yellow },

        Function { fg = highlight_green },

        Conditional { fg = highlight_cyan },
        Exception { fg = highlight_cyan },
        Identifier { fg = highlight_cyan },
        Keyword { fg = highlight_cyan },
        Label { fg = highlight_cyan },
        Repeat { fg = highlight_cyan },
        Statement { fg = highlight_cyan },

        Boolean { fg = highlight_magenta },
        Constant { fg = highlight_magenta },
        Float { fg = highlight_magenta },
        Number { fg = highlight_magenta },
        PreProc { fg = highlight_magenta },
        Type { fg = highlight_magenta },
        Special { fg = highlight_magenta },

        DiffAdd { fg = highlight_green },
        GitGutterAdd { fg = DiffAdd.fg },
        DiffChange { fg = highlight_yellow },
        GitGutterChange { fg = DiffChange.fg },
        DiffDelete { fg = highlight_red },
        GitGutterDelete { fg = DiffDelete.fg },
        DiffText { fg = foreground, bg = background },

        CocHintSign { fg = comment },

        -- this nonsense doesn't actually style anything
        -- unless you use my patch to do nested fold styles
        -- https://github.com/crockeo/neovim/pull/1
        Folded { fg = highlight_green },
        Folded1 { fg = highlight_green },
        Folded2 { fg = highlight_cyan },
        Folded3 { fg = highlight_yellow },
        Folded4 { fg = highlight_magenta },

        VimwikiHeader1 { fg = highlight_green },
        VimwikiHeader2 { fg = highlight_cyan },
        VimwikiHeader3 { fg = highlight_yellow },
        VimwikiHeader4 { fg = highlight_magenta },

        -- https://github.com/crockeo/orgmode-nvim
        OrgTitle { fg = highlight_green },
        SubOrgTitle { fg = highlight_cyan },
        SubSubOrgTitle { fg = highlight_yellow },
        SubSubSubOrgTitle { fg = highlight_magenta },
    }
end)
