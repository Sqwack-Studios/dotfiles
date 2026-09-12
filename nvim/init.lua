vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.softtabstop = 4
vim.o.shiftwidth = 4
vim.o.completeopt = "menuone,noselect,noinsert"
vim.g.mapleader = " "

vim.opt.statuscolumn = "%s%{v:lnum} "
vim.opt.cursorline = true

require("config.lazy")

-- clangd is deliberately NOT started automatically: it indexes aggressively
-- and can be memory-hungry. Run :Clangd in a C/C++ buffer to attach it for
-- this session. The server config itself lives in lsp/clangd.lua.
vim.api.nvim_create_user_command("Clangd", function()
    vim.lsp.enable("clangd")
    -- enable() only hooks buffers opened after it runs, so re-fire FileType
    -- to attach the buffer you are sitting in right now.
    vim.cmd("doautocmd FileType")
end, { desc = "Start clangd for this session" })

vim.cmd.colorscheme('kanagawa-dragon')

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
