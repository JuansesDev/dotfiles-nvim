return {
  {
    "akinsho/flutter-tools.nvim",
    lazy = false,
    ft = { "dart" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    config = function()
      require("flutter-tools").setup({
        ui = {
          border = "rounded",
          notification_style = "native",
        },
        decorations = {
          statusline = { app_version = true, device = true, project_config = true },
        },
        debugger = {
          enabled = true,
          run_via_dap = true,
          exception_breakpoints = {},
          register_configurations = function(_)
            local dap = require("dap")
            dap.configurations.dart = {
              {
                type = "dart",
                request = "launch",
                name = "Launch Flutter Program",
                dartSdkPath  = "dart",
                flutterSdkPath = "flutter",
                program = "${workspaceFolder}/lib/main.dart",
                cwd = "${workspaceFolder}",
              },
            }
          end,
        },
        flutter_lookup_cmd = nil,
        fvm = false,
        widget_guides = { enabled = true },
        closing_tags = {
          highlight = "Comment",
          prefix = "// ",
          enabled = true,
        },
        dev_log = {
          enabled = true,
          notify_errors = false,
          open_cmd = "tabedit",
        },
        dev_tools = {
          autostart = false,
          auto_open_browser = false,
        },
        outline = { auto_open = false },
        lsp = {
          on_attach = function(client, bufnr)
            local map = function(lhs, rhs, desc)
              vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
            end
            map("gd",         vim.lsp.buf.definition,  "LSP: Definition")
            map("gr",         vim.lsp.buf.references,  "LSP: References")
            map("K",          vim.lsp.buf.hover,       "LSP: Hover")
            map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code Action")
            map("<leader>rn", vim.lsp.buf.rename,      "LSP: Rename")

            if vim.lsp.document_color and vim.lsp.document_color.enable then
              pcall(vim.lsp.document_color.enable, true, bufnr, { style = "virtual" })
            end
          end,
          settings = {
            showTodos = true,
            completeFunctionCalls = true,
            renameFilesWithClasses = "prompt",
            enableSnippets = true,
            updateImportsOnRename = true,
          },
        },
      })
    end,
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>",            desc = "Flutter: Run" },
      { "<leader>FR", "<cmd>FlutterRestart<cr>",        desc = "Flutter: Hot Restart" },
      { "<leader>Fl", "<cmd>FlutterReload<cr>",         desc = "Flutter: Hot Reload" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>",           desc = "Flutter: Quit" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>",        desc = "Flutter: Devices" },
      { "<leader>Fe", "<cmd>FlutterEmulators<cr>",      desc = "Flutter: Emulators" },
      { "<leader>FD", "<cmd>FlutterDevTools<cr>",       desc = "Flutter: Open DevTools" },
      { "<leader>Fo", "<cmd>FlutterOutlineToggle<cr>",  desc = "Flutter: Toggle Outline" },
      { "<leader>Fp", "<cmd>FlutterPubGet<cr>",         desc = "Flutter: Pub Get" },
      { "<leader>Fu", "<cmd>FlutterPubUpgrade<cr>",     desc = "Flutter: Pub Upgrade" },
      { "<leader>Fc", "<cmd>FlutterLogClear<cr>",       desc = "Flutter: Clear Log" },
      { "<leader>Fs", "<cmd>FlutterSuper<cr>",          desc = "Flutter: Go to Super" },
    },
  },
}
