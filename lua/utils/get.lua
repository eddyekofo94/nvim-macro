local get = {}

function get.config (name)
  return("require 'plugin-configs/config-" .. name .. "'")
end

function get.spec (name)
  local status, spec
    = pcall(require, 'plugin-specs/spec-' .. name)
  if not status then
    print('Error: cannot get plugin-spec: ' .. name)
    return {}
  end
  return spec
end

function get.lsp_server_config (name)
  local status, server_config =
    pcall(require, 'lsp-server-configs/serverconfig-' .. name)
  if not status then return {}
  else return server_config
  end
end

-- Get treesitter parser list from utils.shared.langs
function get.ts_list (langs)
  local ts_list = {}
  for lang, _ in pairs(langs) do
    table.insert(ts_list, langs[lang].ts)
  end
  return ts_list
end

-- Get filetype list from utils.shared.langs
function get.ft_list (langs)
  local ft_list = {}
  for lang, _ in pairs(langs) do
    table.insert(ft_list, langs[lang].ft)
  end
  return ft_list
end

-- Get lsp-server list from utils.shared.langs
function get.lsp_server_list (langs)
  local server_list = {}
  for lang, _ in pairs(langs) do
    table.insert(server_list, langs[lang].lsp_server)
  end
  return server_list
end

return get
