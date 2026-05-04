return {
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
          auto_close = true,
        }
      }
    },
  },
}
