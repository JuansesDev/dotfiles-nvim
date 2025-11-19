return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      require("mason").setup()
      local mason_registry = require("mason-registry")

      -- Auto-install critical packages
      local function ensure_packages()
        local critical = { "vue-language-server", "typescript-language-server", "jdtls" }
        for _, pkg_name in ipairs(critical) do
          if not mason_registry.is_installed(pkg_name) then
            vim.notify("📦 Installing " .. pkg_name .. "...", vim.log.levels.INFO)
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

      -- Server configurations
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      
      local servers = {
        html = {}, cssls = {}, jsonls = {}, tailwindcss = {}, pyright = {},
        
        -- Configuración básica de Java
        jdtls = {}, 
        
        vue_ls = {
          init_options = { vue = { hybridMode = true } },
        },
        
        ts_ls = {
          filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
          init_options = { plugins = {} },
        },
      }

      -- Inyección del Plugin Vue -> TS
      local vue_path = get_vue_plugin_path()
      if vue_path then
        table.insert(servers.ts_ls.init_options.plugins, {
          name = "@vue/typescript-plugin",
          location = vue_path,
          languages = { "vue" },
        })
      end

      -- 5. Activación
      require("mason-lspconfig").setup({ ensure_installed = vim.tbl_keys(servers) })

      for name, config in pairs(servers) do
        config.capabilities = capabilities
        if vim.lsp.config then
          config.name = name
          vim.lsp.config(name, config)
          vim.lsp.enable(name)
        else
          require("lspconfig")[name].setup(config)
        end
      end
    end,
  }
}