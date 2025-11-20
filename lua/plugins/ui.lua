-- DEFINICIÓN DE LA LÓGICA DE ICONOS (Debe ir ANTES del return)
local function GetCustomFolderIcon(name)
  local folder_name = name:lower()
  
  -- Mapeo de Iconos y Colores
  local folders = {
    -- NÚCLEO / RAÍZ
    ["src"]          = { "", "Directory" },
    ["dist"]         = { "", "NonText" },
    ["build"]        = { "", "NonText" },
    ["bin"]          = { "", "Operator" },
    ["public"]       = { "", "GitSignsChange" },
    ["app"]          = { "", "Type" },
    ["core"]         = { "", "Special" },
    ["server"]       = { "", "Function" },
    ["client"]       = { "", "Constant" },
    ["node_modules"] = { "", "Comment" },
    [".git"]         = { "", "Comment" },
    [".vscode"]      = { "", "Identifier" },

    -- FRONTEND / UI
    ["components"]   = { "󰆧", "Type" },
    ["pages"]        = { "", "Special" },
    ["views"]        = { "", "Special" },
    ["layouts"]      = { "󰙵", "Identifier" },
    ["templates"]    = { "󰦱", "String" },
    ["widgets"]      = { "󰅨", "Type" },
    ["containers"]   = { "", "Type" },
    ["fragments"]    = { "󰆧", "Type" },
    ["modals"]       = { "", "Special" },
    ["sections"]     = { "󰄱", "Identifier" },

    -- BACKEND / LOGIC
    ["api"]          = { "", "Function" },
    ["services"]     = { "󰒋", "Function" },
    ["controllers"]  = { "", "Function" },
    ["models"]       = { "", "String" },
    ["entities"]     = { "󰌗", "String" },
    ["dto"]          = { "", "String" },
    ["repositories"] = { "", "Constant" },
    ["resolvers"]    = { "󰌟", "Function" },
    ["routes"]       = { "󰄉", "Constant" },
    ["router"]       = { "󰄉", "Constant" },
    ["middleware"]   = { "󰡶", "PreProc" },
    ["handlers"]     = { "", "Function" },
    ["stores"]       = { "", "String" },
    ["state"]        = { "", "String" },
    ["actions"]      = { "󰐥", "Function" },
    ["reducers"]     = { "", "Function" },
    ["hooks"]        = { "", "Type" },
    ["composables"]  = { "", "Type" },

    -- ASSETS / RECURSOS
    ["assets"]       = { "", "Number" },
    ["images"]       = { "", "Number" },
    ["img"]          = { "", "Number" },
    ["icons"]        = { "", "Number" },
    ["fonts"]        = { "", "Number" },
    ["styles"]       = { "", "PreProc" },
    ["css"]          = { "", "PreProc" },
    ["scss"]         = { "", "PreProc" },
    ["sass"]         = { "", "PreProc" },
    ["media"]        = { "", "Number" },
    ["static"]       = { "", "Number" },
    ["resources"]    = { "", "Number" },

    -- UTILS / CONFIG
    ["utils"]        = { "", "Operator" },
    ["helpers"]      = { "", "Operator" },
    ["lib"]          = { "", "Operator" },
    ["common"]       = { "", "Operator" },
    ["shared"]       = { "", "Operator" },
    ["constants"]    = { "", "Constant" },
    ["directives"]   = { "", "PreProc" },
    ["plugins"]      = { "", "PreProc" },
    ["boot"]         = { "", "PreProc" },
    ["scripts"]      = { "", "PreProc" },
    ["config"]       = { "", "PreProc" },
    ["env"]          = { "", "PreProc" },
    ["environments"] = { "", "PreProc" },
    ["settings"]     = { "", "PreProc" },
    ["setup"]        = { "", "PreProc" },

    -- DATABASE
    ["db"]           = { "", "String" },
    ["database"]     = { "", "String" },
    ["migrations"]   = { "", "String" },
    ["seeds"]        = { "󰽐", "String" },
    ["seeders"]      = { "󰽐", "String" },
    ["schemas"]      = { "", "String" },
    ["queries"]      = { "", "String" },

    -- TESTING
    ["tests"]        = { "", "String" },
    ["__tests__"]    = { "", "String" },
    ["spec"]         = { "", "String" },
    ["e2e"]          = { "", "String" },
    ["mocks"]        = { "", "Comment" },
    ["fixtures"]     = { "", "Comment" },
    ["coverage"]     = { "", "Identifier" },

    -- DEVOPS / OTROS
    ["docker"]       = { "", "Identifier" },
    ["k8s"]          = { "󱃾", "Identifier" },
    ["kubernetes"]   = { "󱃾", "Identifier" },
    ["ci"]           = { "", "PreProc" },
    ["workflows"]    = { "", "PreProc" },
    ["docs"]         = { "", "Comment" },
    ["examples"]     = { "", "Comment" },
    ["locales"]      = { "󰗊", "Constant" },
    ["i18n"]         = { "󰗊", "Constant" },
    ["types"]        = { "", "Type" },
    ["interfaces"]   = { "", "Type" },
  }

  local data = folders[folder_name]
  if data then
    return data[1], data[2]
  end
  return nil, nil
end

-- INICIO DE LA CONFIGURACIÓN DEL PLUGIN
return {
  -- 1. TEMA
  {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("onedark").setup({ style = "darker" })
      require("onedark").load()
    end,
  },

  -- 2. DEPENDENCIAS UI
  { "nvim-tree/nvim-web-devicons", opts = { default = true, color_icons = true } },
  { "MunifTanjim/nui.nvim" },

  -- 3. NEO-TREE
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
      -- Colores personalizados para Git y Diagnósticos
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
        indent = { with_expanders = true, expander_collapsed = "", expander_expanded = "" },
        git_status = {
          symbols = { untracked = "U", modified = "", deleted = "✖", renamed = "󰑕" },
        },
      },

      filesystem = {
        bind_to_cwd = false,
        
        -- Fix para que el árbol siga al archivo abierto
        follow_current_file = {
          enabled = true,
          leave_dirs_open = false,
        },
        use_libuv_file_watcher = true, 

        filtered_items = { visible = true, hide_dotfiles = false },

        components = {
          icon = function(config, node, state)
            -- 1. Archivos
            if node.type == 'file' then
              local success, web_devicons = pcall(require, 'nvim-web-devicons')
              if success then
                local devicon, hl = web_devicons.get_icon(node.name, node.ext)
                return { text = devicon or config.default, highlight = hl or config.highlight }
              end
            end

            -- 2. Directorios (Usa la función definida arriba)
            if node.type == 'directory' then
              local icon, hl = GetCustomFolderIcon(node.name)
              return { text = icon or "", highlight = hl or "NeoTreeDirectoryIcon" }
            end
            
            return { text = config.default, highlight = config.highlight }
          end
        },
      },
    },
  }
}