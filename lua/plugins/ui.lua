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
                ["components"] = { icon = "󰆧", hl = "Type" },      -- Amarillo/Naranja
                ["stores"]     = { icon = "", hl = "String" },    -- Verde
                ["services"]   = { icon = "󰒋", hl = "Function" },  -- Azul
                ["routes"]     = { icon = "󰄉", hl = "Constant" },  -- Cyan
                ["router"]     = { icon = "󰄉", hl = "Constant" },  -- Cyan
                ["pages"]      = { icon = "", hl = "Special" },   -- Violeta
                ["views"]      = { icon = "", hl = "Special" },
                ["assets"]     = { icon = "", hl = "Number" },    -- Naranja oscuro
                ["public"]     = { icon = "", hl = "GitSignsChange" }, -- Azul Verdoso
                ["dist"]       = { icon = "", hl = "NonText" },   -- Gris tenue
                ["node_modules"] = { icon = "", hl = "Comment" }, -- Gris oscuro
                [".git"]       = { icon = "", hl = "Comment" },
                [".vscode"]    = { icon = "", hl = "Identifier" },-- Rojo/Azul
                ["utils"]      = { icon = "", hl = "Operator" },  -- Blanco/Morado
                ["config"]     = { icon = "", hl = "PreProc" },   -- Amarillo/Morado
                ["tests"]      = { icon = "", hl = "String" },
                ["__tests__"]  = { icon = "", hl = "String" },
                ["src"]        = { icon = "", hl = "Directory" },
              }
              
              local data = special_folders[folder_name]
              if data then
                return { text = data.icon, highlight = data.hl }
              end
              
              if node.loaded and not node.empty_expanded then
                return { text = "", highlight = "NeoTreeDirectoryIcon" }
              elseif not node.loaded and not node.empty_expanded then
                return { text = "", highlight = "NeoTreeDirectoryIcon" }
              else
                return { text = "", highlight = "NeoTreeDirectoryIcon" }
              end
            end
            
            return { text = config.default, highlight = config.highlight }
          end
        },
      },
      default_component_configs = {
        indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
      }
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      vim.cmd("Neotree show")
    end,
  }
}