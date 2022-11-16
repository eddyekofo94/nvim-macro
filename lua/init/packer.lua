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
        return require('packer.util').float({ border = 'double' })
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
    Clean = { opts = { nargs = 0 }, func = function(_) require('packer').snapshot() end, } ,
    Compile = { opts = { nargs = '*' }, func = function(tbl) require('packer').compile(tbl.args) end, } ,
    Install = { opts = { nargs = '*' }, func = function(tbl) require('packer').install(nilify(tbl.fargs)) end, } ,
    Profile = { opts = { nargs = 0 }, func = function(_) require('packer').profile_output() end, } ,
    Rollback = { opts = { nargs = '+' }, func = function(tbl) require('packer').rollback(tbl.args) end, } ,
    Snapshot = { opts = { nargs = '+' }, func = function(tbl) require('packer').snapshot(tbl.args) end, } ,
    SnapshotDelete = { opts = { nargs = '+' }, func = function(tbl) require('packer.snapshot').delete(nilify(tbl.fargs)) end, } ,
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

-- pcall(require, 'load.packer_compiled')
-- pcall(require, 'load.extra')

-- return require('packer').startup({
--   function(use)
--     use(require('plugin-specs.packer'))             -- Packer manages itself

--     -- Editing
--     use(require('plugin-specs.cmp-buffer'))
--     use(require('plugin-specs.cmp-calc'))
--     use(require('plugin-specs.cmp-cmdline'))
--     use(require('plugin-specs.cmp-nvim-lsp'))
--     use(require('plugin-specs.cmp-path'))
--     use(require('plugin-specs.cmp-spell'))
--     use(require('plugin-specs.cmp_luasnip'))
--     use(require('plugin-specs.LuaSnip'))
--     use(require('plugin-specs.nvim-cmp'))           -- Auto completion
--     use(require('plugin-specs.vsc-vim-easymotion')) -- Easymotion for vscode-neovim
--     use(require('plugin-specs.vim-surround'))
--     use(require('plugin-specs.vim-commentary'))
--     use(require('plugin-specs.vim-sleuth'))         -- Auto detect indentation
--     use(require('plugin-specs.nvim-autopairs'))
--     use(require('plugin-specs.undotree'))           -- Visible undo history
--     use(require('plugin-specs.fcitx'))              -- Chinese input method
--     use(require('plugin-specs.copilot'))            -- Cloud AI assistance
--     use(require('plugin-specs.copilot-cmp'))        -- Copilot integration with nvim-cmp

--     -- Language support
--     use(require('plugin-specs.nvim-lspconfig'))     -- LSP config helper
--     use(require('plugin-specs.mason'))
--     use(require('plugin-specs.mason-lspconfig'))
--     use(require('plugin-specs.nvim-treesitter'))    -- Language parser

--     -- Integration
--     use(require('plugin-specs.toggleterm'))         -- Better terminal integration
--     use(require('plugin-specs.gitsigns'))           -- Show git info at side
--     use(require('plugin-specs.lualine'))

--     -- Navigation
--     use(require('plugin-specs.alpha-nvim'))         -- Greeting page
--     use(require('plugin-specs.barbar'))             -- Buffer line
--     use(require('plugin-specs.telescope'))          -- Fuzzy finding
--     use(require('plugin-specs.aerial'))             -- Code outline
--     use(require('plugin-specs.rnvimr'))             -- ranger integration

--     -- Notes and docs
--     use(require('plugin-specs.markdown-preview'))
--     use(require('plugin-specs.clipboard-image'))    -- Paste pictures to markdown
--     use(require('plugin-specs.vimtex'))
--     use(require('plugin-specs.vim-markdown'))

--     -- Tools
--     use(require('plugin-specs.nvim-colorizer'))     -- Show RGB colors inline
--     use(require('plugin-specs.firenvim'))
--   end,

--   config = {
--     clone_timeout = 300,
--     compile_path = fn.stdpath('config') .. '/lua/load/packer_compiled.lua',
--     snapshot_path = fn.stdpath('config') .. '/snapshots',
--     opt_default = false,
--     transitive_opt = true,
--     display = {
--       open_fn = function()
--         return require('packer.util').float({ border = 'double' })
--       end,
--       working_sym = '',
--       error_sym = '',
--       done_sym = '',
--       removed_sym = '',
--       moved_sym = 'ﰲ',
--       keybindings = {
--         toggle_info = '<Tab>'
--       }
--     }
--   }
-- })
