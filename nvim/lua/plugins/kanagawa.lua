return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    priority = 1000,

    config = function()

        require('kanagawa').setup()
        vim.cmd.colorscheme('kanagawa')
        end
}
