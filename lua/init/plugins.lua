---Read file contents
---@param path string
---@return string?
local function read_file(path)
  local file = io.open(path, 'r')
  if not file then
    return nil
  end
  local content = file:read('*a')
  file:close()
  return content
end

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  vim.g.package_path = vim.fn.stdpath('data') .. '/site/pack/packages/opt'
  vim.g.package_lock = vim.fn.stdpath('config') .. '/package-lock.json'
  local lazy_path = vim.g.package_path .. '/lazy.nvim'
  vim.opt.rtp:prepend(lazy_path)
  vim.opt.pp:prepend(lazy_path)
  if not vim.loop.fs_stat(lazy_path) then
    local lock = read_file(vim.g.package_lock)
    local lock_data = lock and vim.json.decode(lock) or nil
    local commit = lock_data
        and lock_data['lazy.nvim']
        and lock_data['lazy.nvim'].commit
      or nil
    local url = 'https://github.com/folke/lazy.nvim.git'
    vim.notify('Installing lazy.nvim...', vim.log.levels.INFO)
    vim.fn.mkdir(vim.g.package_path, 'p')
    local cloned = os.execute(
      table.concat(
        { 'git', 'clone', '--filter=blob:none', url, lazy_path },
        ' '
      )
    )
    if commit then
      os.execute(table.concat({
        'git',
        '--git-dir=' .. lazy_path .. '/.git',
        '--work-tree=' .. lazy_path,
        'checkout',
        commit,
      }, ' '))
    end
    if cloned ~= 0 then
      vim.notify('Failed to clone lazy.nvim', vim.log.levels.ERROR)
      return false
    end
    vim.notify('lazy.nvim cloned to ' .. lazy_path, vim.log.levels.INFO)
  end
  return true
end

---Enable modules
---@param module_names string[]
local function enable_modules(module_names)
  local config = {
    root = vim.g.package_path,
    ui = {
      border = 'shadow',
      size = { width = 0.7, height = 0.74 },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = { colorscheme = { 'cockatoo' } },
    performance = {
      rtp = {
        disabled_plugins = {
          'gzip',
          'matchit',
          'tarPlugin',
          'tohtml',
          'tutor',
          'zipPlugin',
          'health',
          'netrwPlugin',
        },
      },
    },
  }
  local modules = {}
  for _, module_name in ipairs(module_names) do
    vim.list_extend(modules, require('modules.' .. module_name))
  end
  require('lazy').setup(modules, config)
end

if not bootstrap() then
  return
end
if vim.g.vscode then
  enable_modules({
    'base',
    'treesitter',
    'editor',
  })
else
  enable_modules({
    'base',
    'completion',
    'debug',
    'editor',
    'lsp',
    'markup',
    'tools',
    'treesitter',
    'ui',
  })
end

-- a handy abbreviation
vim.cmd('cnoreabbrev lz Lazy')
