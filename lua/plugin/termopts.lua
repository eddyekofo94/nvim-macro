local utils = require('utils')

---@type table<string, true>
local shells_list = {
  sh = true,
  zsh = true,
  bash = true,
  dash = true,
  fish = true,
  less = true,
  gawk = true,
  python = true,
  python3 = true,
  ipython = true,
  ipython3 = true,
  lua = true,
}

---Set global terminal keymaps
---@return nil
local function term_set_global_keymaps()
  -- Basic window navigations
  -- stylua: ignore start
  vim.keymap.set('t', '<M-W>',      '<Cmd>wincmd W<CR>')
  vim.keymap.set('t', '<M-H>',      '<Cmd>wincmd H<CR>')
  vim.keymap.set('t', '<M-J>',      '<Cmd>wincmd J<CR>')
  vim.keymap.set('t', '<M-K>',      '<Cmd>wincmd K<CR>')
  vim.keymap.set('t', '<M-L>',      '<Cmd>wincmd L<CR>')
  vim.keymap.set('t', '<M-=>',      '<Cmd>wincmd =<CR>')
  vim.keymap.set('t', '<M-_>',      '<Cmd>wincmd _<CR>')
  vim.keymap.set('t', '<M-|>',      '<Cmd>wincmd |<CR>')
  vim.keymap.set('t', '<M->>',      '"<C-\\><C-n><C-w>" . (winnr() == winnr("l") ? "<" : ">") . "i"', { expr = true })
  vim.keymap.set('t', '<M-<>',      '"<C-\\><C-n><C-w>" . (winnr() == winnr("l") ? ">" : "<") . "i"', { expr = true })
  vim.keymap.set('t', '<M-.>',      '"<C-\\><C-n><C-w>" . (winnr() == winnr("l") ? "<" : ">") . "i"', { expr = true })
  vim.keymap.set('t', '<M-,>',      '"<C-\\><C-n><C-w>" . (winnr() == winnr("l") ? ">" : "<") . "i"', { expr = true })
  vim.keymap.set('t', '<M-+>',      '<Cmd>wincmd +<CR>')
  vim.keymap.set('t', '<M-->',      '<Cmd>wincmd -<CR>')
  vim.keymap.set('t', '<M-p>',      '<Cmd>wincmd p<CR>')
  vim.keymap.set('t', '<M-c>',      '<Cmd>wincmd c<CR>')
  vim.keymap.set('t', '<M-w>',      '<Cmd>wincmd w<CR>')
  vim.keymap.set('t', '<M-h>',      '<Cmd>wincmd h<CR>')
  vim.keymap.set('t', '<M-j>',      '<Cmd>wincmd j<CR>')
  vim.keymap.set('t', '<M-k>',      '<Cmd>wincmd k<CR>')
  vim.keymap.set('t', '<M-l>',      '<Cmd>wincmd l<CR>')
  -- stylua: ignore end

  -- Use <C-Space>[ and <C-Space>: (same keybindings as in tmux)
  -- to exit terminal mode and enter command mode
  vim.keymap.set('t', '<C-Space>[', '<C-\\><C-n>')
  vim.keymap.set('t', '<C-Space>:', '<C-\\><C-n>:')
  -- Use <Esc> to exit terminal mode when running a shell,
  -- use double <Esc> to send <Esc> to shell
  vim.keymap.set('t', '<Esc>', function()
    return shells_list[utils.term.proc_name(0)]
        and (function()
          ---@diagnostic disable-next-line: undefined-field
          vim.b.t_esc = vim.uv.now()
          return true
        end)()
        and '<Cmd>stopinsert<CR>'
      or '<Esc>'
  end, { expr = true })
  vim.keymap.set('n', '<Esc>', function()
    return vim.b.t_esc
        ---@diagnostic disable-next-line: undefined-field
        and vim.uv.now() - vim.b.t_esc <= vim.go.tm
        and shells_list[utils.term.proc_name(0)]
        and '<Cmd>startinsert<CR><Esc>'
      or '<Esc>'
  end, { expr = true })
end

---Set local terminal keymaps and options, start insert immediately
---@param buf integer terminal buffer handler
---@return nil
local function term_set_local_keymaps_and_opts(buf)
  if not vim.api.nvim_buf_is_valid(buf) or vim.bo[buf].bt ~= 'terminal' then
    return
  end

  -- Set initial terminal split size
  local winnr = vim.fn.winnr()
  local wintype = vim.fn.win_gettype(winnr)
  if wintype == '' then
    if
      vim.fn.winnr('j') == winnr
      and vim.fn.winnr('k') == winnr
      and vim.api.nvim_win_get_width(0) > vim.go.columns * 0.35
    then
      vim.cmd('vertical resize ' .. math.ceil(vim.go.columns * 0.35))
    elseif
      vim.fn.winnr('h') == winnr
      and vim.fn.winnr('l') == winnr
      and vim.api.nvim_win_get_height(0) > vim.go.lines * 0.35
    then
      vim.cmd('resize ' .. math.ceil(vim.go.lines * 0.35))
    end
  end

  vim.keymap.set('n', 'o', '<Cmd>startinsert<CR>', { buffer = buf })
  vim.opt_local.nu = false
  vim.opt_local.rnu = false
  vim.opt_local.spell = false
  vim.opt_local.statuscolumn = ''
  vim.opt_local.signcolumn = 'no'
  if wintype == 'popup' then
    vim.opt_local.scrolloff = 0
    vim.opt_local.sidescrolloff = 0
  end
  vim.cmd.startinsert()
end

---@param buf integer terminal buffer handler
---@return nil
local function setup(buf)
  term_set_global_keymaps()
  term_set_local_keymaps_and_opts(buf)

  local groupid = vim.api.nvim_create_augroup('TermOpts', {})
  vim.api.nvim_create_autocmd('TermOpen', {
    group = groupid,
    desc = 'Set terminal keymaps and options, open term in split.',
    callback = function(info)
      term_set_local_keymaps_and_opts(info.buf)
    end,
  })

  vim.api.nvim_create_autocmd('TermEnter', {
    group = groupid,
    desc = 'Disable mousemoveevent in terminal mode.',
    callback = function()
      vim.g.mousemev = vim.go.mousemev
      vim.go.mousemev = false
    end,
  })

  vim.api.nvim_create_autocmd('TermLeave', {
    group = groupid,
    desc = 'Restore mousemoveevent after leaving terminal mode.',
    callback = function()
      if vim.g.mousemev ~= nil then
        vim.go.mousemev = vim.g.mousemev
        vim.g.mousemev = nil
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinLeave', 'WinLeave' }, {
    group = groupid,
    desc = 'Record mode when leaving terminal window.',
    callback = function(info)
      if vim.bo[info.buf].bt == 'terminal' then
        vim.b[info.buf].termode = vim.api.nvim_get_mode().mode
      end
    end,
  })

  vim.api.nvim_create_autocmd({ 'BufWinEnter', 'WinEnter' }, {
    group = groupid,
    desc = 'Recover inseart mode when entering terminal buffer.',
    callback = function(info)
      if
        vim.bo[info.buf].bt == 'terminal'
        and vim.b[info.buf].termode == 't'
      then
        vim.cmd.startinsert()
      end
    end,
  })
end

return { setup = setup }
