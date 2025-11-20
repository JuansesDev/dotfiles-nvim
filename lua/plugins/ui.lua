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
    dependencies = { "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Explorer" },
    },
    config = function(_, opts)
      -- Define custom highlights for git and diagnostics
      -- These colors are inspired by the onedark theme palette for consistency
      vim.api.nvim_set_hl(0, "NeoTreeGitUntracked", { fg = "#98C379" }) -- Green
      vim.api.nvim_set_hl(0, "NeoTreeGitModified", { fg = "#61AFEF" })  -- Blue
      vim.api.nvim_set_hl(0, "NeoTreeDiagnosticWarn", { fg = "#E5C07B" }) -- Yellow

      require("neo-tree").setup(opts)
      vim.cmd("Neotree show")
    end,
    opts = {
      close_if_last_window = true,
      filesystem = {
        filtered_items = { visible = true, hide_dotfiles = false },
        
        components = {
          icon = function(config, node, state)
            if node.type == 'file' then
              local success, web_devicons = pcall(require, 'nvim-web-devicons')
              if success then
                local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                return {
                  text = devicon or config.default,
                  highlight = hl or config.highlight
                }
              end
            end
            
            -- Custom colored folder icons
            if node.type == 'directory' then
              local folder_name = node.name:lower()
              
              local special_folders = {
                -- Base
                ["src"]          = { icon = "", hl = "Directory" },
                ["dist"]         = { icon = "", hl = "NonText" },
                ["build"]        = { icon = "", hl = "NonText" },
                ["bin"]          = { icon = "", hl = "Operator" },
                ["public"]       = { icon = "", hl = "GitSignsChange" },
                ["app"]          = { icon = "", hl = "Type" },
                ["core"]         = { icon = "", hl = "Special" },
                ["server"]       = { icon = "", hl = "Function" },
                ["client"]       = { icon = "", hl = "Constant" },
                ["node_modules"] = { icon = "", hl = "Comment" },
                [".git"]         = { icon = "", hl = "Comment" },
                [".vscode"]      = { icon = "", hl = "Identifier" },

                -- Components & UI
                ["components"] = { icon = "󰆧", hl = "Type" },
                ["pages"]      = { icon = "", hl = "Special" },
                ["views"]      = { icon = "", hl = "Special" },
                ["layouts"]    = { icon = "󰙵", hl = "Identifier" },
                ["templates"]  = { icon = "󰦱", hl = "String" },
                ["widgets"]    = { icon = "󰅨", hl = "Type" },
                ["containers"] = { icon = "containers", hl = "Type" },
                ["fragments"]  = { icon = "󰆧", hl = "Type" },
                ["modals"]     = { icon = "", hl = "Special" },
                ["sections"]   = { icon = "󰄱", hl = "Identifier" },

                -- Business Logic
                ["api"]          = { icon = "", hl = "Function" },
                ["services"]     = { icon = "󰒋", hl = "Function" },
                ["controllers"]  = { icon = "", hl = "Function" },
                ["models"]       = { icon = "", hl = "String" },
                ["entities"]     = { icon = "󰌗", hl = "String" },
                ["dto"]          = { icon = "", hl = "String" },
                ["repositories"] = { icon = "", hl = "Constant" },
                ["resolvers"]    = { icon = "󰌟", hl = "Function" },
                ["routes"]       = { icon = "󰄉", hl = "Constant" },
                ["router"]       = { icon = "󰄉", hl = "Constant" },
                ["middleware"]   = { icon = "󰡶", hl = "PreProc" },
                ["handlers"]     = { icon = "", hl = "Function" },
                ["stores"]       = { icon = "", hl = "String" },
                ["state"]        = { icon = "", hl = "String" },
                ["actions"]      = { icon = "󰐥", hl = "Function" },
                ["reducers"]     = { icon = "", hl = "Function" },
                ["hooks"]        = { icon = "", hl = "Type" },
                ["composables"]  = { icon = "", hl = "Type" },

                -- Assets & Resources
                ["assets"]     = { icon = "", hl = "Number" },
                ["images"]     = { icon = "", hl = "Number" },
                ["img"]        = { icon = "", hl = "Number" },
                ["icons"]      = { icon = "icons", hl = "Number" },
                ["fonts"]      = { icon = "", hl = "Number" },
                ["styles"]     = { icon = "", hl = "PreProc" },
                ["css"]        = { icon = "", hl = "PreProc" },
                ["scss"]       = { icon = "", hl = "PreProc" },
                ["sass"]       = { icon = "", hl = "PreProc" },
                ["media"]      = { icon = "", hl = "Number" },
                ["static"]     = { icon = "staticfiles", hl = "Number" },
                ["resources"]  = { icon = "resources", hl = "Number" },

                -- Utilities & Helpers
                ["utils"]      = { icon = "", hl = "Operator" },
                ["helpers"]    = { icon = "helpers", hl = "Operator" },
                ["lib"]        = { icon = "", hl = "Operator" },
                ["common"]     = { icon = "", hl = "Operator" },
                ["shared"]     = { icon = "", hl = "Operator" },
                ["constants"]  = { icon = "constants", hl = "Constant" },
                ["directives"] = { icon = "directives", hl = "PreProc" },
                ["plugins"]    = { icon = "plugins", hl = "PreProc" },
                ["boot"]       = { icon = "", hl = "PreProc" },
                ["scripts"]    = { icon = "", hl = "PreProc" },

                -- Config & Environment
                ["config"]       = { icon = "", hl = "PreProc" },
                ["env"]          = { icon = "", hl = "PreProc" },
                ["environments"] = { icon = "", hl = "PreProc" },
                ["settings"]     = { icon = "", hl = "PreProc" },
                ["setup"]        = { icon = "", hl = "PreProc" },
                ["meta"]         = { icon = "", hl = "Comment" },

                -- Database
                ["db"]         = { icon = "", hl = "String" },
                ["database"]   = { icon = "", hl = "String" },
                ["migrations"] = { icon = "", hl = "String" },
                ["seeds"]      = { icon = "󰽐", hl = "String" },
                ["seeders"]    = { icon = "󰽐", hl = "String" },
                ["schemas"]    = { icon = "", hl = "String" },
                ["queries"]    = { icon = "", hl = "String" },

                -- Testing & Quality
                ["tests"]      = { icon = "", hl = "String" },
                ["__tests__"]  = { icon = "", hl = "String" },
                ["spec"]       = { icon = "", hl = "String" },
                ["e2e"]        = { icon = "", hl = "String" },
                ["mocks"]      = { icon = "mocks", hl = "Comment" },
                ["fixtures"]   = { icon = "fixtures", hl = "Comment" },
                ["coverage"]   = { icon = "", hl = "Identifier" },
                ["benchmarks"] = { icon = "󰄕", hl = "Identifier" },

                -- i18n & Types
                ["locales"]      = { icon = "󰗊", hl = "Constant" },
                ["i18n"]         = { icon = "󰗊", hl = "Constant" },
                ["translations"] = { icon = "󰗊", hl = "Constant" },
                ["lang"]         = { icon = "󰗊", hl = "Constant" },
                ["types"]        = { icon = "", hl = "Type" },
                ["interfaces"]   = { icon = "", hl = "Type" },
                ["enums"]        = { icon = "", hl = "Type" },

                -- DevOps & Others
                ["docker"]       = { icon = "", hl = "Identifier" },
                ["k8s"]          = { icon = "kubernetes", hl = "Identifier" },
                ["kubernetes"]   = { icon = "kubernetes", hl = "Identifier" },
                ["ci"]           = { icon = "", hl = "PreProc" },
                ["workflows"]    = { icon = "", hl = "PreProc" },
                ["docs"]         = { icon = "", hl = "Comment" },
                ["examples"]     = { icon = "examples", hl = "Comment" },
                ["vendor"]       = { icon = "", hl = "Comment" },
                ["packages"]     = { icon = "", hl = "NonText" },
                ["cache"]        = { icon = "", hl = "Comment" },
                ["temp"]         = { icon = "temp", hl = "Comment" },
                ["tmp"]          = { icon = "temp", hl = "Comment" },
              }
              
              local data = special_folders[folder_name]
              if data then
                return { text = data.icon, highlight = data.hl }
              end
              
              -- Return default folder icon if not special
              if node.expanded then
                return { text = "", highlight = "NeoTreeDirectoryIcon" }
              else
                return { text = "", highlight = "NeoTreeDirectoryIcon" }
              end
            end
            
            return { text = config.default, highlight = config.highlight }
          end
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
        diagnostics = {
          symbols = {
            warn = " ",
          },
          highlights = {
            warn = "NeoTreeDiagnosticWarn",
          },
        },
        git_status = {
          symbols = {
            untracked = "U",
            modified = "",
          },
          highlights = {
            untracked = "NeoTreeGitUntracked",
            modified = "NeoTreeGitModified",
          },
        },
      }
    },
  }
}