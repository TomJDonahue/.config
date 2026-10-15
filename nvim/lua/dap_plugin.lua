do
    local dap = require("dap")

    local lldb_dap_path
    if vim.fn.has("mac") == 1 then
        lldb_dap_path = "/opt/homebrew/opt/llvm/bin/lldb-dap"
    else
        lldb_dap_path = "/usr/bin/lldb-dap"
    end

    dap.adapters.lldb = {
        type = "executable",
        command = lldb_dap_path,
    }

    dap.configurations.odin = {
        {
            type = "lldb",
            request = "launch",
            name = "Odin Debug",
            program = function()
                local cwd = vim.fn.getcwd()
                local out = cwd .. "/odinrpg"
                local co = coroutine.running()

                vim.system(
                    { "odin", "build", "src", "-debug", "-out:" .. out },
                    { text = true },
                    function(obj)
                        vim.schedule(function()
                            if obj.code ~= 0 then
                                vim.notify("Odin build failed:\n" .. (obj.stderr or ""), vim.log.levels.ERROR)
                                coroutine.resume(co)
                            else
                                coroutine.resume(co, out)
                            end
                        end)
                    end
                )

                return coroutine.yield()
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = {},
        },
    }
    require("dap-view").setup({ auto_toggle = true })
    dap_view = require("dap-view")

    vim.keymap.set("n", "<leader>dv", dap_view.toggle, { desc = "Toggle DAP View" })

    vim.keymap.set("n", "<leader>db", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dc", function() require("dap").continue() end, { desc = "Continue" })
    vim.keymap.set("n", "<leader>do", function() require("dap").step_over() end, { desc = "Step Over" })
    vim.keymap.set("n", "<leader>di", function() require("dap").step_into() end, { desc = "Step Into" })
    vim.keymap.set("n", "<leader>dO", function() require("dap").step_out() end, { desc = "Step Out" })
    vim.keymap.set("n", "<leader>dr", function() require("dap").repl.open() end, { desc = "Repl Open" })
    vim.keymap.set("n", "<leader>dt", function() require("dap").terminate() end, { desc = "Terminate" })
    vim.keymap.set("n", "<leader>dw", function() require("dapui").elements.watches.add() end, { desc = "Add Watch" })
end
