return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,

    config = function()
        -- transparent = true is what actually clears the background. Setting
        -- Normal/NormalFloat by hand does not survive, because loading a
        -- colorscheme resets every highlight group.
        --
        -- transparent only covers Normal, so floats need an explicit
        -- override to match.
        require('kanagawa').setup({
            transparent = true,

            overrides = function()
                return {
                    --NormalFloat = { bg = "none" },
                    --Normal = { bg = "none"},
                }
            end,
        })
        -- The colorscheme itself is selected in init.lua.
    end
}
