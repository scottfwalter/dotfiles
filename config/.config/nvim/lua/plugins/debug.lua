return {
  "mfussenegger/nvim-dap",
  dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Node.js Adapter
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = { os.getenv("HOME") .. "/.local/share/nvim/dap_adapters/vscode-node-debug2/out/src/nodeDebug.js" },
    }

    -- Configurations for Node.js
    dap.configurations.javascript = {
      {
        name = "Launch Node",
        type = "node2",
        request = "launch",
        program = "${file}",
        cwd = vim.fn.getcwd(),
        sourceMaps = true,
        protocol = "inspector",
        console = "integratedTerminal",
      },
      {
        name = "Attach to Node",
        type = "node2",
        request = "attach",
        processId = require("dap.utils").pick_process,
      },
    }

    -- Configurations for Chrome Debugging
    dap.adapters.chrome = {
      type = "executable",
      command = "chrome-debug-adapter",
    }

    dap.configurations.javascriptreact = { -- For React / Frontend
      {
        name = "Attach to Chrome",
        type = "chrome",
        request = "attach",
        program = "${file}",
        port = 9222,
        webRoot = "${workspaceFolder}",
      },
    }

    -- UI Setup
    dapui.setup()
    vim.keymap.set("n", "<F5>", dap.continue)
    vim.keymap.set("n", "<F10>", dap.step_over)
    vim.keymap.set("n", "<F11>", dap.step_into)
    vim.keymap.set("n", "<F12>", dap.step_out)
    vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
    vim.keymap.set("n", "<Leader>dr", dap.repl.open)
  end,
}

