return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text",
      "williamboman/mason.nvim",
      "jay-babu/mason-nvim-dap.nvim",
      "leoluz/nvim-dap-go",
    },
    keys = {
      { "<F5>",       function() require("dap").continue() end,          desc = "DAP Continue / Start" },
      { "<F10>",      function() require("dap").step_over() end,         desc = "DAP Step Over" },
      { "<F11>",      function() require("dap").step_into() end,         desc = "DAP Step Into" },
      { "<F12>",      function() require("dap").step_out() end,          desc = "DAP Step Out" },
      { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional Breakpoint" },
      { "<leader>Dc", function() require("dap").continue() end,          desc = "Continue" },
      { "<leader>Do", function() require("dap").step_over() end,         desc = "Step Over" },
      { "<leader>Di", function() require("dap").step_into() end,         desc = "Step Into" },
      { "<leader>DO", function() require("dap").step_out() end,          desc = "Step Out" },
      { "<leader>Dr", function() require("dap").repl.open() end,         desc = "Open REPL" },
      { "<leader>Dl", function() require("dap").run_last() end,          desc = "Run Last" },
      { "<leader>Dt", function() require("dap").terminate() end,         desc = "Terminate" },
      { "<leader>Du", function() require("dapui").toggle() end,          desc = "Toggle UI" },
      { "<leader>De", function() require("dapui").eval() end,            mode = { "n", "v" }, desc = "Eval Expression" },
      { "<leader>DC", function() require("dap").clear_breakpoints() end, desc = "Clear All Breakpoints" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      require("dapui").setup()
      require("nvim-dap-virtual-text").setup({
        commented = true,
      })

      vim.fn.sign_define("DapBreakpoint",          { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticSignWarn",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "", texthl = "DiagnosticSignInfo",  linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "", texthl = "DiagnosticSignWarn",  linehl = "Visual", numhl = "DiagnosticSignWarn" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "", texthl = "DiagnosticSignHint",  linehl = "", numhl = "" })

      dap.listeners.before.attach.dapui_config       = function() dapui.open() end
      dap.listeners.before.launch.dapui_config       = function() dapui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
      dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

      require("mason-nvim-dap").setup({
        ensure_installed = { "codelldb", "js-debug-adapter", "debugpy" },
        automatic_installation = true,
        handlers = {
          function(config)
            require("mason-nvim-dap").default_setup(config)
          end,
        },
      })

      require("dap-go").setup()

      -- Mason deja los ejecutables en <data>/mason/bin, pero en Windows los
      -- envuelve en .cmd/.bat. Resolver la extension evita que codelldb no
      -- arranque fuera de macOS/Linux.
      local function mason_bin(name)
        local base = vim.fn.stdpath("data") .. "/mason/bin/" .. name
        if vim.fn.executable(base) == 1 then
          return base
        end
        for _, ext in ipairs({ ".cmd", ".exe", ".bat" }) do
          if vim.fn.executable(base .. ext) == 1 then
            return base .. ext
          end
        end
        return base
      end

      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local js_debug_path = mason_path .. "/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"

      for _, adapter in ipairs({ "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }) do
        dap.adapters[adapter] = {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_debug_path, "${port}" },
          },
        }
      end

      for _, lang in ipairs({ "javascript", "typescript", "javascriptreact", "typescriptreact" }) do
        dap.configurations[lang] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file (Node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to process",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (localhost:5173)",
            url = "http://localhost:5173",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
          {
            type = "pwa-chrome",
            request = "launch",
            name = "Launch Chrome (localhost:3000)",
            url = "http://localhost:3000",
            webRoot = "${workspaceFolder}",
            sourceMaps = true,
          },
        }
      end

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = mason_bin("codelldb"),
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch (cargo target)",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
          args = {},
        },
      }
      dap.configurations.c   = dap.configurations.rust
      dap.configurations.cpp = dap.configurations.rust
    end,
  },
}
