return {
  -- 1. PANEL DE PROBLEMAS (Como el de VSCode)
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Ver Errores (Trouble)" },
    },
    opts = {
      modes = {
        diagnostics = {
          auto_close = true, -- Cerrar al saltar a un error
        }
      }
    },
  },

  -- 2. CONFIGURACIÓN VISUAL (El efecto "Error Lens" Nativo)
  {
    "neovim/nvim-lspconfig",
    opts = function()
      -- Definimos los iconos de error (Tipo Material/VSCode)
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Configuración global de diagnósticos
      vim.diagnostic.config({
        virtual_text = {
          -- Esto es lo que hace que el texto salga al lado del código
          source = "if_many", -- O "always" si quieres ver siempre quién lo reporta
          prefix = '●', -- Un puntito bonito antes del mensaje
          -- prefix = '←', -- O una flecha si prefieres
        },
        float = {
          source = "always",
          border = "rounded",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })
    end
  }
}