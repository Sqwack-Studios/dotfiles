vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = "menuone,noselect,noinsert"
vim.g.mapleader = " "

vim.opt.statuscolumn = "%s%{v:lnum} "
vim.opt.cursorline = true

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

require("config.lazy")

vim.cmd.colorscheme('kanagawa-wave')

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
            autotrigger = true, --popup while typing
        })

        local client = vim.lsp.get_client_by_id(args.data.client_id)

        if client then
            client.server_capabilities.semanticTokensProvider = nil
        end
    end,
})
