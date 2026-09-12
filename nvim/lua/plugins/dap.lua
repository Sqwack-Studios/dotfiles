return {
    {
        "mfussenegger/nvim-dap",

        config = function()

            local dap = require('dap')
            local map = vim.keymap.set
            local dap_utils = require('dap.utils')
            
            --Execution shortcuts
            map("n", "<F5>", dap.continue, { desc = "DAP Continue"})
            map("n", "<F6>", dap.pause, { desc = "DAP Pause"})
            map("n", "<S-F5>", dap.terminate, { desc = "DAP Terminate"})
            map("n", "<F9>", dap.restart, { desc = "DAP Restart"})

            --Debugging stepping
            map("n", "<F10>", dap.step_over, { desc = "DAP Step Over"})
            map("n", "<F11>", dap.step_into, { desc = "DAP Step Into"})
            map("n", "<F12>", dap.step_out, { desc = "DAP Step Out"})
            
            --Breakpoint
            map("n", "<leader>b", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
            map("n", "<leader>B", 
                function()
                    dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
                end, { desc = "DAP Conditional Breakpoint" })

            dap.configurations.cpp = {
                {
                    name = "Attach with LLDB",
                    type = "lldb",
                    request = "attach",
                    pid = dap_utils.pick_process,
                    cwd = "${workspaceFolder}"
                },
                {
                    name = "Launch with LLDB",
                    type = "lldb",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                },
                {
                    name = "Attach with MSVC Debugger",
                    type = "cppvsdbg",
                    request = "attach",
                    pid = dap_utils.pick_process,
                    cwd = "${workspaceFolder}"
                },
                {
                    name = "Launch with MSVC Debugger",
                    type = "cppvsdbg",
                    request = "launch",
                    program = function()
                        return vim.fn.input("Executable: ", vim.fn.getcwd() .. "/", "file")
                    end,
                }

            }

            dap.adapters.lldb = {
                type = "executable",
                command = "lldb_dap",
                name = "lldb",
            }



            dap.configurations.c = dap.configurations.cpp
        end,

    },
}
