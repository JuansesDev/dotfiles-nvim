return {
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUpdate", "MasonLog" },
    opts = {},
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.HINT]  = " ",
            [vim.diagnostic.severity.INFO]  = " ",
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
          },
          numhl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN]  = "DiagnosticSignWarn",
            [vim.diagnostic.severity.HINT]  = "DiagnosticSignHint",
            [vim.diagnostic.severity.INFO]  = "DiagnosticSignInfo",
          },
        },
        virtual_text = false,
        virtual_lines = {
          current_line = true,
          format = function(diagnostic)
            local source = diagnostic.source and ("[" .. diagnostic.source .. "] ") or ""
            local msg = source .. diagnostic.message
            local width = math.max(60, math.floor(vim.api.nvim_win_get_width(0) * 0.8))
            local lines = {}
            for line in msg:gmatch("[^\n]+") do
              while #line > width do
                local cut = line:sub(1, width)
                local space = cut:find("%s[^%s]*$") or width
                table.insert(lines, line:sub(1, space - 1))
                line = line:sub(space + 1)
              end
              table.insert(lines, line)
            end
            return table.concat(lines, "\n")
          end,
        },
        float = {
          source = "always",
          border = "rounded",
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      require("mason").setup()
      local mason_registry = require("mason-registry")

      local function ensure_packages()
        local critical = { "vue-language-server", "typescript-language-server", "jdtls" }
        for _, pkg_name in ipairs(critical) do
          if not mason_registry.is_installed(pkg_name) then
            vim.notify("Installing " .. pkg_name .. "...", vim.log.levels.INFO)
            pcall(function() mason_registry.get_package(pkg_name):install() end)
          end
        end
      end
      mason_registry.refresh(function() vim.schedule(ensure_packages) end)

      local function get_vue_plugin_path()
        local mason_path = vim.fn.stdpath("data") .. "/mason/packages/vue-language-server"
        local plugin_path = mason_path .. "/node_modules/@vue/language-server"
        if (vim.uv or vim.loop).fs_stat(plugin_path) then return plugin_path end
        return nil
      end

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      local servers = {
        html = {
          filetypes = { "html", "vue", "templ" },
          init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = { css = true, javascript = true },
            provideFormatter = true,
          },
        },
        cssls = {
          filetypes = { "css", "scss", "less", "vue" },
        },
        jsonls = {},
        tailwindcss = {},
        pyright = {},
        jdtls = {},
        vue_ls = {},
        ts_ls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          init_options = { plugins = {} },
        },
      }

      local vue_path = get_vue_plugin_path()
      if vue_path then
        table.insert(servers.ts_ls.init_options.plugins, {
          name = "@vue/typescript-plugin",
          location = vue_path,
          languages = { "vue" },
        })
      end

      vim.lsp.config("*", { capabilities = capabilities })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(servers),
      })
    end,
  }
}
