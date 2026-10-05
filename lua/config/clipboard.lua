-- Portapapeles cross-platform: macOS / Linux (X11 y Wayland) / WSL / SSH.
--
-- Neovim ya trae los proveedores nativos: pbcopy/pbpaste en macOS y
-- xclip/xsel/wl-copy en Linux. Los casos que se rompen son otros dos:
--
--   1. WSL: Linux no ve el portapapeles de Windows. Se usa win32yank.exe si
--      esta instalado, y si no OSC52.
--   2. SSH o terminal sin servidor grafico: no hay proveedor, asi que el yank
--      se pierde y el paste se queda colgado unos segundos. OSC52 lo manda por
--      el propio terminal, que si tiene portapapeles.
--
-- OSC52 necesita Neovim >= 0.10 y un terminal que lo soporte: Windows
-- Terminal, kitty, wezterm, foot, iTerm2, etc.

local function has_exe(name)
  return vim.fn.executable(name) == 1
end

local function is_wsl()
  if vim.fn.has("wsl") == 1 then
    return true
  end
  -- Neovim viejo: detectarlo por la firma de Microsoft en /proc/version.
  local f = io.open("/proc/version", "r")
  if not f then
    return false
  end
  local content = (f:read("*a") or ""):lower()
  f:close()
  return content:find("microsoft") ~= nil
end

local function use_osc52()
  local ok, osc52 = pcall(require, "vim.ui.clipboard.osc52")
  if not ok then
    return false
  end
  vim.g.clipboard = {
    name = "osc52",
    copy  = { ["+"] = osc52.copy("+"),  ["*"] = osc52.copy("*") },
    paste = { ["+"] = osc52.paste("+"), ["*"] = osc52.paste("*") },
  }
  return true
end

-- Hay proveedor nativo para este sistema? (macOS y Windows siempre lo tienen)
local function has_native_provider()
  if vim.fn.has("mac") == 1 and has_exe("pbcopy") then
    return true
  end
  if vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1 then
    return true
  end
  for _, exe in ipairs({ "wl-copy", "xclip", "xsel", "lemonade", "doitclient" }) do
    if has_exe(exe) then
      return true
    end
  end
  return false
end

if is_wsl() then
  local yank
  if has_exe("win32yank.exe") then
    yank = "win32yank.exe"
  elseif has_exe("win32yank") then
    yank = "win32yank"
  end

  if yank then
    vim.g.clipboard = {
      name = "win32yank",
      copy  = { ["+"] = { yank, "-i", "--crlf" }, ["*"] = { yank, "-i", "--crlf" } },
      paste = { ["+"] = { yank, "-o", "--lf" },   ["*"] = { yank, "-o", "--lf" } },
      cache_enabled = 0,
    }
  else
    -- Sin win32yank. OSC52 funciona igual; si el pegado te molesta, instala
    -- win32yank.exe y esta rama deja de usarse.
    use_osc52()
  end
elseif not has_native_provider() then
  -- SSH / headless / contenedor: no hay portapapeles local, usar el terminal.
  use_osc52()
end

-- unnamedplus: yank y paste van al portapapeles del sistema ademas de a los
-- registros "+ y "* de Vim.
vim.opt.clipboard = "unnamedplus"
