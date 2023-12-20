local utils = require('utils')
local conf_path = vim.fn.stdpath('config') --[[@as string]]
local data_path = vim.fn.stdpath('data') --[[@as string]]
local state_path = vim.fn.stdpath('state') --[[@as string]]

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  vim.g.package_path = vim.fs.joinpath(data_path, 'site/pack/packages/opt')
  vim.g.package_lock = vim.fs.joinpath(conf_path, 'package-lock.json')
  local lazy_path = vim.fs.joinpath(vim.g.package_path, 'lazy.nvim')
  if vim.uv.fs_stat(lazy_path) then
    vim.opt.rtp:prepend(lazy_path)
    return true
  end

  local startup_file = vim.fs.joinpath(state_path, 'startup.json')
  local startup_data = utils.json.read(startup_file)
  if startup_data.bootstrap == false then
    return false
  end

  local response = ''
  vim.ui.input({
    prompt = '[packages] package manager not found, bootstrap? [y/N/never] ',
  }, function(r)
    response = r
  end)

  if vim.fn.match(response, '[Nn][Ee][Vv][Ee][Rr]') >= 0 then
    startup_data.bootstrap = false
    utils.json.write(startup_file, startup_data)
    return false
  end

  if vim.fn.match(response, '^[Yy]\\([Ee][Ss]\\)\\?$') < 0 then
    return false
  end

  print('\n')
  local lock_data = utils.json.read(vim.g.package_lock)
  local commit = lock_data['lazy.nvim'] and lock_data['lazy.nvim'].commit
  local url = 'https://github.com/folke/lazy.nvim.git'
  vim.notify('[packages] installing lazy.nvim...')
  vim.fn.mkdir(vim.g.package_path, 'p')
  if
    not utils.git.execute({
      'clone',
      '--filter=blob:none',
      url,
      lazy_path,
    }, vim.log.levels.INFO).success
  then
    return false
  end

  if commit then
    utils.git.dir_execute(
      lazy_path,
      { 'checkout', commit },
      vim.log.levels.INFO
    )
  end
  vim.notify('[packages] lazy.nvim cloned to ' .. lazy_path)
  vim.opt.rtp:prepend(lazy_path)
  return true
end

---Enable modules
---@param module_names string[]
local function enable_modules(module_names)
  local config = {
    root = vim.g.package_path,
    lockfile = vim.g.package_lock,
    ui = {
      border = 'solid',
      size = { width = 0.7, height = 0.74 },
    },
    checker = { enabled = false },
    change_detection = { notify = false },
    install = {
      colorscheme = { 'dragon', 'nano', 'cockatoo' },
    },
    performance = {
      rtp = {
        disabled_plugins = {},
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
    'lib',
    'edit',
    'treesitter',
  })
else
  enable_modules({
    'lib',
    'lsp',
    'edit',
    'debug',
    'tools',
    'markup',
    'completion',
    'treesitter',
    'colorschemes',
    'telescope',
    'auto-session',
    'early-retirement',
    'conform',
    'winsep',
    'flash',
    'which-key',
    'mini',
    'lsp.mason',
    -- 'zen',
    'project',
    'conform',
    'git.git',
    -- 'persisted',
    -- 'persistence',
    -- 'sessions',
    'catppuccin',
    'spider',
    'focus',
  })
end

vim.api.nvim_create_autocmd('User', {
  desc = 'Reverse/Apply local patches on updating/intalling plugins.',
  group = vim.api.nvim_create_augroup('LazyPatches', {}),
  pattern = {
    'LazyInstall*',
    'LazyUpdate*',
    'LazyRestore*',
  },
  callback = function(info)
    local patches_path = vim.fs.joinpath(conf_path, 'patches')
    for patch in vim.fs.dir(patches_path) do
      local patch_path = vim.fs.joinpath(patches_path, patch)
      local plugin_path =
        vim.fs.joinpath(vim.g.package_path, (patch:gsub('%.patch$', '')))
      if vim.uv.fs_stat(plugin_path) then
        utils.git.dir_execute(plugin_path, {
          'restore',
          '.',
        })
        if not info.match:find('Pre$') then
          vim.notify('[packages] applying patch ' .. patch)
          utils.git.dir_execute(plugin_path, {
            'apply',
            '--ignore-space-change',
            patch_path,
          }, vim.log.levels.WARN)
        end
      end
    end
  end,
})

-- A handy abbreviation
utils.keymap.command_abbrev('lz', 'Lazy')
