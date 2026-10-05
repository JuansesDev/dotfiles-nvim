-- :find difuso (fuzzy) nativo, sin plugins. Neovim 0.11+ (usa 'findfunc').
-- Escribes pedazos sueltos de ruta+nombre y filtra:  :fin acuer index
-- Al dar Enter abre la mejor coincidencia; con Tab ves y ciclas la lista.

-- Raiz del proyecto: sube desde el archivo actual buscando marcadores.
local function project_root()
  return vim.fs.root(0, {
    ".git", ".hg", "package.json", "Cargo.toml",
    "go.mod", "pubspec.yaml", "Makefile",
  }) or vim.fn.getcwd()
end

-- Lista de archivos del proyecto, cacheada por raiz (TTL corto) para que
-- 'findfunc' no relance fd en cada pulsacion de Tab en repos grandes.
local cache = {} -- root -> { t = ms, files = { ... } }

-- Rutas absolutas -> relativas al cwd, para verlas cortas y abrirlas bien.
-- Solo acorta los archivos que estan DEBAJO del cwd; los de arriba los deja
-- absolutos, que es lo que hace fnamemodify(":.") y siempre abre bien.
local function relativize(files)
  return vim.tbl_map(function(f)
    return vim.fn.fnamemodify(f, ":.")
  end, files)
end

local function list_files(root)
  local now = vim.uv.now()
  local hit = cache[root]
  if hit and (now - hit.t) < 3000 then
    return hit.files
  end

  -- .git y node_modules se excluyen siempre: sin esto :Fin lista miles de
  -- archivos de dependencias y el barrido se vuelve lento. Es la misma idea
  -- que el wildignore de lua/config/options.lua.
  local cmd
  if vim.fn.executable("fd") == 1 then
    cmd = { "fd", "--type", "f", "--hidden",
            "--exclude", ".git", "--exclude", "node_modules",
            "--absolute-path", ".", root }
  elseif vim.fn.executable("rg") == 1 then
    cmd = { "rg", "--files", "--hidden",
            "--glob", "!.git", "--glob", "!node_modules/**", root }
  else
    -- Ultimo recurso: find no respeta .gitignore, hay que filtrar a mano.
    cmd = { "find", root, "-type", "f",
            "-not", "-path", "*/.git/*", "-not", "-path", "*/node_modules/*" }
  end

  local files = relativize(vim.fn.systemlist(cmd))

  cache[root] = { t = now, files = files }
  return files
end

-- 'findfunc': (cmdarg, cmdcomplete) -> lista de rutas
_G.FuzzyFind = function(cmdarg, _cmdcomplete)
  local files = list_files(project_root())
  if cmdarg == "" then
    return files
  end
  return vim.fn.matchfuzzy(files, cmdarg)
end

vim.o.findfunc = "v:lua.FuzzyFind"

-- Comando personalizado :Fin  (se teclea "fin" y se vuelve "Fin", ver keymaps)
--   :Fin acuer index   -> abre la MEJOR coincidencia difusa (sin Tab, sin Oil)
--   :Fin index<Tab>    -> tambien puedes ciclar candidatos con Tab
vim.api.nvim_create_user_command("Fin", function(opts)
  if opts.args == "" then
    vim.notify(":Fin necesita algo que buscar. Ej: :Fin acuer index", vim.log.levels.INFO)
    return
  end
  local matches = FuzzyFind(opts.args, false)
  if #matches == 0 then
    vim.notify("Sin coincidencias para: " .. opts.args, vim.log.levels.WARN)
    return
  end
  vim.cmd.edit(vim.fn.fnameescape(matches[1]))
end, {
  nargs = "*",
  complete = function(arglead)
    if arglead == "" then
      return {}
    end
    return FuzzyFind(arglead, true)
  end,
  desc = "Buscar archivo (fuzzy) y abrir la mejor coincidencia",
})
