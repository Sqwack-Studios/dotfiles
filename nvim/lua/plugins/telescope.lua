return {
    'nvim-telescope/telescope.nvim', version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },

    config = function()
        local builtin = require('telescope.builtin')

        vim.keymap.set('n', "<C-p>", builtin.find_files,{})
        vim.keymap.set('n', "<C-b>", builtin.buffers,{})
        vim.keymap.set('n', "<leader>fr", builtin.oldfiles,{})
        vim.keymap.set('n', "<leader>f:", builtin.command_history,{})
        vim.keymap.set('n', "<leader>f/", builtin.search_history,{})
        vim.keymap.set('n', "<leader>fg", builtin.live_grep,{})
        vim.keymap.set('n', "<leader>fq", builtin.quickfix,{})
        vim.keymap.set('n', "<leader>lr", builtin.lsp_references, { desc = "LSP References" })
        vim.keymap.set('n', "<leader>li", builtin.lsp_implementations, { desc = "LSP Implementations" })
        vim.keymap.set('n', "<leader>ls", builtin.lsp_document_symbols, { desc = "Document smymbols" })
        vim.keymap.set('n', "<leader>lS", builtin.lsp_workspace_symbols, { desc = "Workspace symbols" })
        vim.keymap.set('n', "<leader>ld", builtin.diagnostics, { desc = "Diagnostics" })
    end
} 
