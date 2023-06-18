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

---Print shell command error
---@param cmd string[] shell command
---@param msg string error message
---@param lev number? log level to use for errors, defaults to WARN
---@return nil
local function shell_error(cmd, msg, lev)
  lev = lev or vim.log.levels.WARN
  vim.notify(
    '[plugins] failed to execute shell command: '
      .. table.concat(cmd, ' ')
      .. '\n'
      .. msg,
    lev
  )
end

---Execute git command in directory
---@param dir string directory to execute command in
---@param cmd string[] git command to execute
---@param error_lev number? log level to use for errors, defaults to WARN
---@reurn { success: boolean, output: string }
local function git_dir_execute(dir, cmd, error_lev)
  error_lev = error_lev or vim.log.levels.WARN
  local shell_args = { 'git', '-C', dir, unpack(cmd) }
  local shell_out = vim.fn.system(shell_args)
  if vim.v.shell_error ~= 0 then
    shell_error(shell_args, shell_out, error_lev)
    return {
      success = false,
      output = shell_out,
    }
  end
  return {
    success = true,
    output = shell_out,
  }
end

---Execute git command in current directory
---@param cmd string[] git command to execute
---@param error_lev number? log level to use for errors, defaults to WARN
---@reurn { success: boolean, output: string }
local function git_execute(cmd, error_lev)
  error_lev = error_lev or vim.log.levels.WARN
  local shell_args = { 'git', unpack(cmd) }
  local shell_out = vim.fn.system(shell_args)
  if vim.v.shell_error ~= 0 then
    shell_error(shell_args, shell_out, error_lev)
    return {
      success = false,
      output = shell_out,
    }
  end
  return {
    success = true,
    output = shell_out,
  }
end

---Install package manager if not already installed
---@return boolean success
local function bootstrap()
  vim.g.package_path = vim.fn.stdpath('data') .. '/site/pack/packages/opt'
  vim.g.package_lock = vim.fn.stdpath('config') .. '/package-lock.json'
  local lazy_path = vim.g.package_path .. '/lazy.nvim'
  vim.opt.rtp:prepend(lazy_path)
  vim.opt.pp:prepend(lazy_path)
  if vim.loop.fs_stat(lazy_path) then
    return true
  end

  local lock = read_file(vim.g.package_lock)
  local lock_data = lock and vim.json.decode(lock) or nil
  local commit = lock_data
      and lock_data['lazy.nvim']
      and lock_data['lazy.nvim'].commit
    or nil
  local url = 'https://github.com/folke/lazy.nvim.git'
  vim.notify('[plugins] installing lazy.nvim...', vim.log.levels.INFO)
  vim.fn.mkdir(vim.g.package_path, 'p')
  if
    not git_execute(
      { 'clone', '--filter=blob:none', url, lazy_path },
      vim.log.levels.INFO
    ).success
  then
    return false
  end
  if commit then
    git_dir_execute(lazy_path, { 'checkout', commit }, vim.log.levels.INFO)
  end
  vim.notify(
    '[plugins] lazy.nvim cloned to ' .. lazy_path,
    vim.log.levels.INFO
  )
  return true
end

---Enable modules
---@param module_names string[]
local function enable_modules(module_names)
  local config = {
    root = vim.g.package_path,
    lockfile = vim.g.package_lock,
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

if vim.env.NVIM_MANPAGER or not bootstrap() then
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

-- Autocommands to apply and restore local patches to plugins
local patches_path = vim.fn.stdpath('config') .. '/patches'
vim.api.nvim_create_autocmd('User', {
  pattern = 'LazyUpdate*',
  group = vim.api.nvim_create_augroup('LazyPatches', {}),
  callback = function(info)
    for patch in vim.fs.dir(patches_path) do
      local patch_path = patches_path .. '/' .. patch
      local plugin_path = vim.g.package_path
        .. '/'
        .. patch:gsub('%.patch$', '')
      if vim.loop.fs_stat(plugin_path) then
        if
          info.match == 'LazyUpdatePre'
          and git_dir_execute(plugin_path, { 'diff', '--stat' }).output ~= ''
        then
          git_dir_execute(plugin_path, {
            'apply',
            '--reverse',
            '--ignore-space-change',
            patch_path,
          })
        elseif info.match == 'LazyUpdate' then
          git_dir_execute(plugin_path, {
            'apply',
            '--ignore-space-change',
            patch_path,
          })
        end
      end
    end
  end,
  desc = 'Reverse/Apply local patches before/after updating plugins.',
})
