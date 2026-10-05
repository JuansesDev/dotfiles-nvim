return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",   desc = "Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
      { "<leader>/",  "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buscar en archivo actual (fuzzy)" },
    },
    opts = {
      pickers = {
        buffers = {
          mappings = {
            i = { ["<C-x>"] = function(...) return require("telescope.actions").delete_buffer(...) end },
            n = { ["dd"] = function(...) return require("telescope.actions").delete_buffer(...) end },
          },
        },
      },
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>Oil<cr>", desc = "Open parent directory" },
      { "-",         "<cmd>Oil<cr>", desc = "Open parent directory" },
    },
    opts = {
      default_file_explorer = true,
      view_options = {
        show_hidden = true,
      },
      keymaps = {
        ["q"] = "actions.close",
      },
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
        "json", "lua", "python", "yaml",
        "rust", "dart", "go", "toml",
        "markdown", "markdown_inline", "bash", "vim", "vimdoc", "regex",
      }
      require("nvim-treesitter").install(parsers)

      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "javascript", "typescript", "typescriptreact", "javascriptreact",
          "vue", "html", "css", "json", "jsonc", "lua", "python",
          "rust", "dart", "go", "toml",
          "yaml", "markdown", "sh", "bash", "vim", "help",
        },
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
        end,
      })
    end,
  }
}
