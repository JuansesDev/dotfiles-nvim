return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      local parsers = {
        "javascript", "typescript", "tsx", "vue", "html", "css",
        "json", "lua", "python", "java", "yaml",
        "markdown", "markdown_inline", "bash", "vim", "vimdoc", "regex",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript", "typescript", "typescriptreact", "javascriptreact",
          "vue", "html", "css", "json", "jsonc", "lua", "python", "java",
          "yaml", "markdown", "sh", "bash", "vim", "help",
        },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  }
}
