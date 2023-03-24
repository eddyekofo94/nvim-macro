local set_autocmds = function(autocmds)
  for _, autocmd in ipairs(autocmds) do
    if autocmd[2].group and vim.fn.exists('#' .. autocmd[2].group) == 0 then
      vim.api.nvim_create_augroup(autocmd[2].group, { clear = true })
    end
    vim.api.nvim_create_autocmd(unpack(autocmd))
  end
end

local autocmds = {
  -- Highlight the selection on yank
  {
    { 'TextYankPost' },
    {
      pattern = '*',
      group = 'YankHighlight',
      callback = function()
        vim.highlight.on_yank({ higroup = 'Visual', timeout = 200 })
      end,
    },
  },

  -- Autosave on focus change
  {
    { 'BufLeave', 'WinLeave', 'FocusLost' },
    {
      pattern = '*',
      group = 'Autosave',
      command = 'silent! wall',
      nested = true,
    },
  },

  -- Jump to last accessed window on closing the current one
  {
    { 'WinEnter' },
    {
      pattern = '*',
      group = 'WinCloseJmp',
      callback = function()
        require('utils.funcs').win_close_jmp()
      end,
    },
  },

  -- Last-position-jump
  {
    { 'BufReadPost' },
    {
      pattern = '*',
      group = 'LastPosJmp',
      callback = function()
        require('utils.funcs').last_pos_jmp()
      end,
    },
  },

  -- Automatically change local current directory
  {
    { 'WinEnter', 'BufWinEnter' },
    {
      pattern = '*',
      group = 'AutoCwd',
      callback = function(tbl)
        if tbl.file == '' then
          return
        end
        local proj_dir = require('utils.funcs').proj_dir(tbl.file)
        if proj_dir then
          vim.cmd.tcd(proj_dir)
        end
      end,
    },
  },

  -- Automatically create missing directories
  {
    { 'BufWritePre' },
    {
      pattern = '*',
      group = 'AutoMkdir',
      callback = function()
        vim.fn.mkdir(vim.fn.expand('%:p:h'), 'p')
      end,
    },
  },

  -- Restore dark/light background from ShaDa
  {
    { 'BufReadPre', 'UIEnter' },
    {
      group = 'RestoreBackground',
      callback = function()
        if not vim.g.background_restored then
          vim.opt.background = vim.g.BACKGROUND or 'dark'
          vim.g.background_restored = true
        end
      end,
      once = true,
    },
  },

  -- Set window-navigation keymaps for prompt buffers
  {
    { 'BufEnter' },
    {
      group = 'PromptKeymaps',
      callback = function(tbl)
        if vim.bo[tbl.buf].buftype == 'prompt' then
          vim.keymap.set('i', '<M-W>',      '<C-w>W',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-H>',      '<C-w>H',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-J>',      '<C-w>J',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-K>',      '<C-w>K',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-L>',      '<C-w>L',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-=>',      '<C-w>=',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-->',      '<C-w>-',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-+>',      '<C-w>+',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-_>',      '<C-w>_',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-|>',      '<C-w>|',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-<>',      '<C-w><',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M->>',      '<C-w>>',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-p>',      '<C-w>p',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-r>',      '<C-w>r',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-v>',      '<C-w>v',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-s>',      '<C-w>s',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-x>',      '<C-w>x',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-z>',      '<C-w>z',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-c>',      '<C-w>c',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-n>',      '<C-w>n',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-o>',      '<C-w>o',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-t>',      '<C-w>t',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-T>',      '<C-w>T',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-]>',      '<C-w>]',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-^>',      '<C-w>^',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-b>',      '<C-w>b',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-d>',      '<C-w>d',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-f>',      '<C-w>f',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-}>',      '<C-w>}',      { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g>]',     '<C-w>g]',     { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g>}',     '<C-w>g}',     { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g>f',     '<C-w>gf',     { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g>F',     '<C-w>gF',     { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g>t',     '<C-w>gt',     { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g>T',     '<C-w>gT',     { buffer = tbl.buf })
          vim.keymap.set('i', '<M-w>',      '<C-w><C-w>',  { buffer = tbl.buf })
          vim.keymap.set('i', '<M-h>',      '<C-w><C-h>',  { buffer = tbl.buf })
          vim.keymap.set('i', '<M-j>',      '<C-w><C-j>',  { buffer = tbl.buf })
          vim.keymap.set('i', '<M-k>',      '<C-w><C-k>',  { buffer = tbl.buf })
          vim.keymap.set('i', '<M-l>',      '<C-w><C-l>',  { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g><M-]>', '<C-w>g<C-]>', { buffer = tbl.buf })
          vim.keymap.set('i', '<M-g><Tab>', '<C-w>g<Tab>', { buffer = tbl.buf })
        end
      end
    }
  }
}

set_autocmds(autocmds)
