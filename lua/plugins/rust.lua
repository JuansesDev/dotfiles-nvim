return {
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    lazy = false,
    ft = { "rust" },
    init = function()
      vim.g.rustaceanvim = function()
        -- Los nombres de archivo de codelldb cambian segun el sistema:
        --   macOS   -> adapter/codelldb        + lldb/lib/liblldb.dylib
        --   Linux   -> adapter/codelldb        + lldb/lib/liblldb.so
        --   Windows -> adapter/codelldb.exe    + lldb/lib/liblldb.dll
        -- Tener ".dylib" fijo dejaba el debugger de Rust muerto fuera de macOS.
        local mason_codelldb = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension"
        local lib_ext = ({ OSX = "dylib", Windows = "dll" })[jit.os] or "so"
        local exe_ext = jit.os == "Windows" and ".exe" or ""
        local codelldb_path = mason_codelldb .. "/adapter/codelldb" .. exe_ext
        local liblldb_path  = mason_codelldb .. "/lldb/lib/liblldb." .. lib_ext

        local dap_cfg = {}
        if vim.fn.executable(codelldb_path) == 1 and vim.fn.filereadable(liblldb_path) == 1 then
          local rt = require("rustaceanvim.config")
          dap_cfg = { adapter = rt.get_codelldb_adapter(codelldb_path, liblldb_path) }
        end

        return {
          tools = {
            float_win_config = { border = "rounded" },
          },
          server = {
            on_attach = function(_, bufnr)
              local map = function(lhs, rhs, desc)
                vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
              end
              map("<leader>Ra", function() vim.cmd.RustLsp("codeAction") end,             "Rust: Code Actions")
              map("<leader>Rr", function() vim.cmd.RustLsp("runnables") end,              "Rust: Runnables")
              map("<leader>Rd", function() vim.cmd.RustLsp("debuggables") end,            "Rust: Debuggables")
              map("<leader>Re", function() vim.cmd.RustLsp("expandMacro") end,            "Rust: Expand Macro")
              map("<leader>Rh", function() vim.cmd.RustLsp({ "hover", "actions" }) end,   "Rust: Hover Actions")
              map("<leader>Rp", function() vim.cmd.RustLsp("parentModule") end,           "Rust: Parent Module")
              map("<leader>Rc", function() vim.cmd.RustLsp("openCargo") end,              "Rust: Open Cargo.toml")
              map("<leader>RR", function() vim.cmd.RustLsp("reloadWorkspace") end,        "Rust: Reload Workspace")
              map("K",          function() vim.cmd.RustLsp({ "hover", "actions" }) end,   "Rust: Hover")
            end,
            default_settings = {
              ["rust-analyzer"] = {
                cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
                checkOnSave = true,
                check = { command = "clippy", extraArgs = { "--no-deps" } },
                procMacro = { enable = true },
                inlayHints = {
                  bindingModeHints       = { enable = false },
                  chainingHints          = { enable = true },
                  closingBraceHints      = { enable = true, minLines = 25 },
                  closureReturnTypeHints = { enable = "never" },
                  lifetimeElisionHints   = { enable = "never", useParameterNames = false },
                  maxLength              = 25,
                  parameterHints         = { enable = true },
                  reborrowHints          = { enable = "never" },
                  renderColons           = true,
                  typeHints              = { enable = true, hideClosureInitialization = false, hideNamedConstructor = false },
                },
              },
            },
          },
          dap = dap_cfg,
        }
      end
    end,
  },

  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    opts = {
      completion = {
        cmp = { enabled = true },
      },
    },
  },
}
