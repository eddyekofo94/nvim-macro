local default_config = require('configs.lsp-server-configs.shared.default')
local nvimlib = {
  vim.fn.expand('$VIMRUNTIME'),
}
local neodevok, neodevcfg = pcall(require, 'neodev.config')
if neodevok then
  table.insert(nvimlib, neodevcfg.types())
end

---Check if a path is inside nvim's runtime paths
---@param path string
---@return boolean
local function inside_nvim_runtime_paths(path)
  for _, runtime_path in ipairs(vim.api.nvim_list_runtime_paths()) do
    if vim.startswith(path, runtime_path) then
      return true
    end
  end
  return false
end

return vim.tbl_deep_extend('force', default_config, {
  on_new_config = function(config, new_root)
    if not new_root then
      return
    end
    config.settings = config.settings or {}
    if inside_nvim_runtime_paths(new_root) then
      config.settings = vim.tbl_deep_extend('force', config.settings, {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            path = vim.split(package.path, ';'),
          },
          workspace = {
            library = nvimlib,
            checkThirdParty = false,
          },
          completion = {
            callSnippet = 'Replace',
          },
          diagnostics = {
            enable = true,
            globals = { 'vim' },
          },
          telemetry = {
            enable = false,
          },
        },
      })
    elseif
      new_root:match(
        (os.getenv('XDG_CONFIG_HOME') or os.getenv('HOME') or '')
          .. '/.config/awesome'
      )
    then
      config.settings = vim.tbl_deep_extend('force', config.settings, {
        Lua = {
          runtime = {
            path = {
              '/usr/share/awesome/lib',
              '/usr/share/awesome/themes',
            },
          },
          diagnostics = {
            enable = true,
            globals = {
              'awesome',
              'client',
              'screen',
              'root',
            },
          },
          telemetry = {
            enable = false,
          },
        },
      })
    end
  end,
})
