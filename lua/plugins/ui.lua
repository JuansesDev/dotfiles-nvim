return {
  {
    "kdheepak/monochrome.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      -- Verde-gris oscuro: reemplaza SOLO el tono mas apagado del tema
      -- (#5e5e5e), el de keywords y nombres de tipo (export/interface/IMeta).
      -- Los otros dos tonos del monocromo quedan intactos.
      local dim_green = "#83c092"

      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "monochrome",
        callback = function()
          -- Transparencia: quitar solo el fondo, preservando el resto.
          for _, g in ipairs({
            "Normal", "NormalNC", "NormalFloat", "FloatBorder",
            "SignColumn", "LineNr", "EndOfBuffer",
          }) do
            local hl = vim.api.nvim_get_hl(0, { name = g })
            hl.bg, hl.ctermbg = nil, nil
            vim.api.nvim_set_hl(0, g, hl)
          end

          -- Tinte verde-gris en el tono apagado (keywords + nombres de tipo).
          -- NO se toca @type.builtin (number/string), que va en el tono claro.
          for _, g in ipairs({
            "Keyword", "Statement", "Conditional", "Repeat",
            "Include", "Exception", "StorageClass", "Structure",
            "PreProc", "Type",
            "@keyword", "@keyword.function", "@keyword.return",
            "@keyword.operator", "@keyword.import", "@keyword.export",
            "@keyword.type", "@keyword.conditional", "@keyword.repeat",
            "@keyword.exception", "@keyword.coroutine", "@keyword.modifier",
            "@conditional", "@repeat", "@include", "@exception",
            "@type", "@type.definition", "@type.qualifier",
            -- estructura del HTML/Vue: nombres de tag = menta
            "@tag", "@tag.builtin",
          }) do
            vim.api.nvim_set_hl(0, g, { fg = dim_green })
          end

          -- Declaraciones sin usar (LSP "declared but never read"): el tema
          -- las manda a un gris casi invisible sobre negro. Subir a un gris
          -- legible pero mas apagado que el codigo normal, y conservar el
          -- subrayado difuso como senal de "no usado".
          for _, g in ipairs({ "DiagnosticUnnecessary", "@lsp.mod.unused" }) do
            vim.api.nvim_set_hl(0, g, { fg = "#8a8a8a", underline = true, sp = "#5e5e5e" })
          end
        end,
      })

      vim.cmd.colorscheme("monochrome")
    end,
  },

  { "nvim-tree/nvim-web-devicons", opts = { default = true, color_icons = true } },
}
