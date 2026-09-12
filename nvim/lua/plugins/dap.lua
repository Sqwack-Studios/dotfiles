-- lldb-dap is not reliably on PATH. MSYS2 CLANG64 and most Linux packages put
-- it there, but on macOS Xcode ships it outside PATH and only xcrun knows the
-- location. That lookup costs ~200ms, so it runs on the first debug session
-- rather than at every nvim startup, and the answer is remembered.
local lldb_dap_path

local function find_lldb_dap()
    if lldb_dap_path then
        return lldb_dap_path
    end

    if vim.fn.executable("lldb-dap") == 1 then
        lldb_dap_path = "lldb-dap"
    elseif vim.fn.has("mac") == 1 then
        local found = vim.fn.trim(vim.fn.system({ "xcrun", "-f", "lldb-dap" }))
        if vim.v.shell_error == 0 and found ~= "" then
            lldb_dap_path = found
        end
    end

    -- Fall back to the bare name so nvim-dap reports a clear failure when a
    -- session starts, instead of nvim warning on every launch.
    lldb_dap_path = lldb_dap_path or "lldb-dap"

    return lldb_dap_path
end

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
            }

            dap.adapters.lldb = function(callback, _)
                callback({
                    type = "executable",
                    command = find_lldb_dap(),
                    name = "lldb",
                })
            end



            dap.configurations.c = dap.configurations.cpp
        end,

    },
}
