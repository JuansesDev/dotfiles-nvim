return {
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "darker" })
      require("onedark").load()
    end,
  },

  { "nvim-tree/nvim-web-devicons", opts = { default = true, color_icons = true } },
  { "MunifTanjim/nui.nvim" },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle Explorer" },
    },

    config = function(_, opts)
      local hl = vim.api.nvim_set_hl
      hl(0, "NeoTreeGitUntracked", { fg = "#98C379" })
      hl(0, "NeoTreeGitModified", { fg = "#61AFEF" })
      hl(0, "NeoTreeDiagnosticWarn", { fg = "#E5C07B" })

      require("neo-tree").setup(opts)
    end,

    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,

      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = ">",
          expander_expanded = "v",
        },
        icon = {
          folder_closed = "\xEF\x81\xBB",
          folder_open   = "\xEF\x81\xBC",
          folder_empty  = "\xEF\x84\x94",
          default       = "\xEF\x85\x9B",
          provider = function(icon, node, state)
            if node.type == "directory" then
              local ok, icons = pcall(require, "utils.icons")
              if ok then
                local custom, hl = icons.get_folder_icon(node.name)
                if custom and custom ~= "" then
                  icon.text = custom
                  icon.highlight = hl or "NeoTreeDirectoryIcon"
                end
              end
            elseif node.type == "file" or node.type == "terminal" then
              local ok, web_devicons = pcall(require, "nvim-web-devicons")
              if ok then
                local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                if devicon then
                  icon.text = devicon
                  icon.highlight = hl or icon.highlight
                end
              end
            end
            return icon
          end,
        },
        git_status = {
          symbols = { untracked = "U", modified = "", deleted = "✖", renamed = "󰑕" },
        },
      },

      filesystem = {
        bind_to_cwd = false,
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true,
        filtered_items = { visible = true, hide_dotfiles = false },
      },
    },
  }
}
