local fn = vim.fn
local cmd = vim.cmd
local uv = vim.loop
local api = vim.api
local packer_compile_path = fn.stdpath('data') .. '/site/lua/packer_compiled.lua'
local packer_install_path = fn.stdpath('data') .. '/site/pack/packer/opt/packer.nvim'
local packer_snapshot_path = fn.stdpath('config') .. '/snapshots'
local packer_url = 'https://github.com/wbthomason/packer.nvim'
local packer = nil


local function packer_init()
  packer.init({
    clone_timeout = 300,
    compile_path = packer_compile_path,
    snapshot_path = packer_snapshot_path,
    opt_default = false,
    transitive_opt = true,
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end,
      working_sym = '',
      error_sym = '',
      done_sym = '',
      removed_sym = '',
      moved_sym = 'ﰲ',
      keybindings = { toggle_info = '<Tab>' }
    }
  })
end


local function packer_load_modules()
  -- packer.nvim manages itself
  packer.use({ 'wbthomason/packer.nvim', opt = true })
  -- manage other plugins
  local modules_path = vim.split(vim.fn.globpath(fn.stdpath('config')
                        .. '/lua/modules/', '*'), '\n')
  for _, module_path in ipairs(modules_path) do
    local specs = require(module_path:match('modules/.*'))
    for _, spec in pairs(specs) do
      packer.use(spec)
    end
  end
end


-- Install and add packer.nvim if not installed
local function packer_bootstrap()
  if fn.empty(fn.glob(packer_install_path)) > 0 then
    vim.notify('Installing packer.nvim...', vim.log.levels.INFO)
    PACKER_BOOTSTRAP = fn.system ({
      'git', 'clone', '--depth', '1', packer_url, packer_install_path
    })
    vim.notify('packer.nvim cloned to ' .. packer_install_path,
        vim.log.levels.INFO)
    cmd('packadd packer.nvim')
    packer = require('packer')

    -- make directory for packer compiled file
    uv.fs_mkdir(packer_compile_path, 744, function ()
      assert('Failed to create packer compile path')
    end)
    packer_init()
    packer_load_modules()
    packer.sync()
  end
end


local function load_packer_compiled()
  local packer_compiled_ok, err_msg = pcall(require, 'packer_compiled')
  if not packer_compiled_ok then
    vim.notify('Error loading packer_compiled.lua: ' .. err_msg,
        vim.log.levels.ERROR)
  end
end


local function create_packer_usercmds()

  local function nilify(tbl)
    if type(tbl) == 'table' and not next(tbl) then
      return nil
    end
    return tbl
  end

  local packer_cmds = {
    Clean = { opts = { nargs = 0 }, func = function(tbl) require('packer').snapshot(tbl.args) end, } ,
    Compile = { opts = { nargs = '*' }, func = function(tbl) require('packer').compile(tbl.args) end, } ,
    Install = { opts = { nargs = '*' }, func = function(tbl) require('packer').install(nilify(tbl.fargs)) end, } ,
    Profile = { opts = { nargs = 0 }, func = function(_) require('packer').profile_output() end, } ,
    Rollback = { opts = { nargs = '+' }, func = function(tbl) require('packer').rollback(tbl.args) end, } ,
    Snapshot = { opts = { nargs = '+' }, func = function(tbl) require('packer').snapshot(tbl.args) end, } ,
    SnapshotDelete = { opts = { nargs = '+' }, func = function(tbl) require('packer.snapshot').delete(tbl.args) end, } ,
    Status = { opts = { nargs = 0 }, func = function(_) require('packer').status() end, } ,
    Sync = { opts = { nargs = '*' }, func = function(tbl) require('packer').sync(nilify(tbl.fargs)) end, } ,
    Update = { opts = { nargs = '*' }, func = function(tbl) require('packer').update(nilify(tbl.fargs)) end, } ,
  }

  for packer_cmd, attr in pairs(packer_cmds) do
    api.nvim_create_user_command('Packer' .. packer_cmd, function(tbl)
      -- load packer if not loaded
      if not packer then
        cmd('packadd packer.nvim')
        packer = require('packer')
        packer_init()
        packer_load_modules()
      end
      -- then call the corresponding function with args
      attr.func(tbl)
    end, attr.opts)
  end
end


local function create_packer_autocmds()
  api.nvim_create_autocmd('User', {
    pattern = 'PackerCompileDone',
    callback = function()
      vim.notify('Packer compiled successfully!', vim.log.levels.INFO)
    end,
  })
end


packer_bootstrap()
load_packer_compiled()
create_packer_usercmds()
create_packer_autocmds()
