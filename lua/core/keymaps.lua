local utils = require('utils')

vim.keymap.set({ 'n', 'x' }, '<Space>', '<Ignore>')
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Multi-window operations
-- stylua: ignore start
vim.keymap.set({ 'x', 'n' }, '<M-W>',      '<C-w>W')
vim.keymap.set({ 'x', 'n' }, '<M-H>',      '<C-w>H')
vim.keymap.set({ 'x', 'n' }, '<M-J>',      '<C-w>J')
vim.keymap.set({ 'x', 'n' }, '<M-K>',      '<C-w>K')
vim.keymap.set({ 'x', 'n' }, '<M-L>',      '<C-w>L')
vim.keymap.set({ 'x', 'n' }, '<M-=>',      '<C-w>=')
vim.keymap.set({ 'x', 'n' }, '<M-_>',      '<C-w>_')
vim.keymap.set({ 'x', 'n' }, '<M-|>',      '<C-w>|')
vim.keymap.set({ 'x', 'n' }, '<M->>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-<>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-.>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-,>',      '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-+>',      'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-->',      'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<M-p>',      '<C-w>p')
vim.keymap.set({ 'x', 'n' }, '<M-r>',      '<C-w>r')
vim.keymap.set({ 'x', 'n' }, '<M-v>',      '<C-w>v')
vim.keymap.set({ 'x', 'n' }, '<M-s>',      '<C-w>s')
vim.keymap.set({ 'x', 'n' }, '<M-x>',      '<C-w>x')
vim.keymap.set({ 'x', 'n' }, '<M-z>',      '<C-w>z')
vim.keymap.set({ 'x', 'n' }, '<M-c>',      '<C-w>c')
vim.keymap.set({ 'x', 'n' }, '<M-n>',      '<C-w>n')
vim.keymap.set({ 'x', 'n' }, '<M-o>',      '<C-w>o')
vim.keymap.set({ 'x', 'n' }, '<M-t>',      '<C-w>t')
vim.keymap.set({ 'x', 'n' }, '<M-T>',      '<C-w>T')
vim.keymap.set({ 'x', 'n' }, '<M-]>',      '<C-w>]')
vim.keymap.set({ 'x', 'n' }, '<M-^>',      '<C-w>^')
vim.keymap.set({ 'x', 'n' }, '<M-b>',      '<C-w>b')
vim.keymap.set({ 'x', 'n' }, '<M-d>',      '<C-w>d')
vim.keymap.set({ 'x', 'n' }, '<M-f>',      '<C-w>f')
vim.keymap.set({ 'x', 'n' }, '<M-}>',      '<C-w>}')
vim.keymap.set({ 'x', 'n' }, '<M-g>]',     '<C-w>g]')
vim.keymap.set({ 'x', 'n' }, '<M-g>}',     '<C-w>g}')
vim.keymap.set({ 'x', 'n' }, '<M-g>f',     '<C-w>gf')
vim.keymap.set({ 'x', 'n' }, '<M-g>F',     '<C-w>gF')
vim.keymap.set({ 'x', 'n' }, '<M-g>t',     '<C-w>gt')
vim.keymap.set({ 'x', 'n' }, '<M-g>T',     '<C-w>gT')
vim.keymap.set({ 'x', 'n' }, '<M-w>',      '<C-w><C-w>')
vim.keymap.set({ 'x', 'n' }, '<M-h>',      '<C-w><C-h>')
vim.keymap.set({ 'x', 'n' }, '<M-j>',      '<C-w><C-j>')
vim.keymap.set({ 'x', 'n' }, '<M-k>',      '<C-w><C-k>')
vim.keymap.set({ 'x', 'n' }, '<M-l>',      '<C-w><C-l>')
vim.keymap.set({ 'x', 'n' }, '<M-g><M-]>', '<C-w>g<C-]>')
vim.keymap.set({ 'x', 'n' }, '<M-g><Tab>', '<C-w>g<Tab>')

vim.keymap.set({ 'x', 'n' }, '<C-w>>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w><', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>,', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>.', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
vim.keymap.set({ 'x', 'n' }, '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
-- stylua: ignore end

-- Terminal mode keymaps
-- stylua: ignore start
vim.keymap.set('t', '<M-v>',      '<Cmd>wincmd v<CR>')
vim.keymap.set('t', '<M-s>',      '<Cmd>wincmd s<CR>')
vim.keymap.set('t', '<M-W>',      '<Cmd>wincmd W<CR>')
vim.keymap.set('t', '<M-H>',      '<Cmd>wincmd H<CR>')
vim.keymap.set('t', '<M-J>',      '<Cmd>wincmd J<CR>')
vim.keymap.set('t', '<M-K>',      '<Cmd>wincmd K<CR>')
vim.keymap.set('t', '<M-L>',      '<Cmd>wincmd L<CR>')
vim.keymap.set('t', '<M-=>',      '<Cmd>wincmd =<CR>')
vim.keymap.set('t', '<M-_>',      '<Cmd>wincmd _<CR>')
vim.keymap.set('t', '<M-|>',      '<Cmd>wincmd |<CR>')
vim.keymap.set('t', '<M->>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"', { expr = true })
vim.keymap.set('t', '<M-<>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"', { expr = true })
vim.keymap.set('t', '<M-.>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"', { expr = true })
vim.keymap.set('t', '<M-,>',      '"<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"', { expr = true })
vim.keymap.set('t', '<M-+>',      '<Cmd>wincmd 2+<CR>')
vim.keymap.set('t', '<M-->',      '<Cmd>wincmd 2-<CR>')
vim.keymap.set('t', '<M-r>',      '<Cmd>wincmd r<CR>')
vim.keymap.set('t', '<M-R>',      '<Cmd>wincmd R<CR>')
vim.keymap.set('t', '<M-x>',      '<Cmd>wincmd x<CR>')
vim.keymap.set('t', '<M-p>',      '<Cmd>wincmd p<CR>')
vim.keymap.set('t', '<M-c>',      '<Cmd>wincmd c<CR>')
vim.keymap.set('t', '<M-o>',      '<Cmd>wincmd o<CR>')
vim.keymap.set('t', '<M-w>',      '<Cmd>wincmd w<CR>')
vim.keymap.set('t', '<M-h>',      '<Cmd>wincmd h<CR>')
vim.keymap.set('t', '<M-j>',      '<Cmd>wincmd j<CR>')
vim.keymap.set('t', '<M-k>',      '<Cmd>wincmd k<CR>')
vim.keymap.set('t', '<M-l>',      '<Cmd>wincmd l<CR>')
-- stylua: ignore end

---@param linenr integer? line number
---@return boolean
local function is_wrapped(linenr)
  if not vim.wo.wrap then
    return false
  end
  linenr = linenr or vim.fn.line('.')
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  return vim.fn.strdisplaywidth(vim.fn.getline(linenr) --[[@as string]])
    >= wininfo.width - wininfo.textoff
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped(key, remap)
  return function()
    return is_wrapped() and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_cur_or_next_line_nocount(key, remap)
  return function()
    return vim.v.count == 0
        and (is_wrapped() or is_wrapped(vim.fn.line('.') + 1))
        and remap
      or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_cur_or_prev_line_nocount(key, remap)
  return function()
    return vim.v.count == 0
        and (is_wrapped() or is_wrapped(vim.fn.line('.') - 1))
        and remap
      or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_first_line_nocount(key, remap)
  return function()
    return vim.v.count == 0 and is_wrapped(1) and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_last_line_nocount(key, remap)
  return function()
    return vim.v.count == 0 and is_wrapped(vim.fn.line('$')) and remap or key
  end
end

---@param key string
---@param remap string
---@return fun(): string
local function map_wrapped_eol(key, remap)
  local remap_esc = vim.api.nvim_replace_termcodes(remap, true, true, true)
  return function()
    if not is_wrapped() then
      return key
    end
    vim.api.nvim_feedkeys(remap_esc, 'nx', false)
    return vim.fn.col('.') == vim.fn.col('$') - 1 and key or remap
  end
end

-- More consistent behavior when &wrap is set
-- stylua: ignore start
vim.keymap.set({ 'n', 'x' }, 'j',        map_wrapped_cur_or_next_line_nocount('j', 'gj'),               { expr = true })
vim.keymap.set({ 'n', 'x' }, 'k',        map_wrapped_cur_or_prev_line_nocount('k', 'gk'),               { expr = true })
vim.keymap.set({ 'n', 'x' }, '<Down>',   map_wrapped_cur_or_next_line_nocount('<Down>', 'g<Down>'),     { expr = true })
vim.keymap.set({ 'n', 'x' }, '<Up>',     map_wrapped_cur_or_prev_line_nocount('<Up>', 'g<Up>'),         { expr = true })
vim.keymap.set({ 'n', 'x' }, 'gg',       map_wrapped_first_line_nocount('gg', 'gg99999gk'),             { expr = true })
vim.keymap.set({ 'n', 'x' }, 'G',        map_wrapped_last_line_nocount('G', 'G99999gj'),                { expr = true })
vim.keymap.set({ 'n', 'x' }, '<C-Home>', map_wrapped_first_line_nocount('<C-Home>', '<C-Home>99999gk'), { expr = true })
vim.keymap.set({ 'n', 'x' }, '<C-End>',  map_wrapped_last_line_nocount('<C-End>', '<C-End>99999gj'),    { expr = true })
vim.keymap.set({ 'n', 'x' }, '0',        map_wrapped('0', 'g0'),             { expr = true })
vim.keymap.set({ 'n', 'x' }, '$',        map_wrapped_eol('$', 'g$'),         { expr = true })
vim.keymap.set({ 'n', 'x' }, '^',        map_wrapped('^', 'g^'),             { expr = true })
vim.keymap.set({ 'n', 'x' }, '<Home>',   map_wrapped('<Home>', 'g<Home>'),   { expr = true })
vim.keymap.set({ 'n', 'x' }, '<End>',    map_wrapped_eol('<End>', 'g<End>'), { expr = true })
-- stylua: ignore end

-- Buffer navigation
vim.keymap.set('n', ']b', '<Cmd>exec v:count1 . "bn"<CR>')
vim.keymap.set('n', '[b', '<Cmd>exec v:count1 . "bp"<CR>')

-- Tabpages
---@param tab_action function
---@param default_count number?
---@return function
local function tabswitch(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = vim.fn.tabpagenr('$')
    if num_tabs >= count then
      tab_action(count ~= 0 and count or nil)
      return
    end
    vim.cmd.tablast()
    for _ = 1, count - num_tabs do
      vim.cmd.tabnew()
    end
  end
end
vim.keymap.set('n', 'gt', tabswitch(vim.cmd.tabnext))
vim.keymap.set('n', 'gT', tabswitch(vim.cmd.tabprev))
vim.keymap.set('n', 'gy', tabswitch(vim.cmd.tabprev)) -- gT is too hard to press

vim.keymap.set('n', '<Leader>0', '<Cmd>0tabnew<CR>')
vim.keymap.set('n', '<Leader>1', tabswitch(vim.cmd.tabnext, 1))
vim.keymap.set('n', '<Leader>2', tabswitch(vim.cmd.tabnext, 2))
vim.keymap.set('n', '<Leader>3', tabswitch(vim.cmd.tabnext, 3))
vim.keymap.set('n', '<Leader>4', tabswitch(vim.cmd.tabnext, 4))
vim.keymap.set('n', '<Leader>5', tabswitch(vim.cmd.tabnext, 5))
vim.keymap.set('n', '<Leader>6', tabswitch(vim.cmd.tabnext, 6))
vim.keymap.set('n', '<Leader>7', tabswitch(vim.cmd.tabnext, 7))
vim.keymap.set('n', '<Leader>8', tabswitch(vim.cmd.tabnext, 8))
vim.keymap.set('n', '<Leader>9', tabswitch(vim.cmd.tabnext, 9))

-- Complete line
vim.keymap.set('i', '<C-l>', '<C-x><C-l>')

-- Correct misspelled word / mark as correct
vim.keymap.set('i', '<C-g>+', '<Esc>[szg`]a')
vim.keymap.set('i', '<C-g>=', '<C-g>u<Esc>[s1z=`]a<C-G>u')

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
vim.keymap.set('n', '<C-l>', function()
  return vim.v.hlsearch == 1 and '<Cmd>nohlsearch|diffupdate|echo<CR>'
    or '<Cmd>nohlsearch|diffupdate|normal! <C-l><CR>'
end, { expr = true })

-- Don't include extra spaces around quotes
vim.keymap.set({ 'o', 'x' }, 'a"', '2i"', { noremap = false })
vim.keymap.set({ 'o', 'x' }, "a'", "2i'", { noremap = false })
vim.keymap.set({ 'o', 'x' }, 'a`', '2i`', { noremap = false })

-- Close all floating windows
vim.keymap.set('n', 'q', function()
  local count = 0
  local current_win = vim.api.nvim_get_current_win()
  -- close current win only if it's a floating window
  if vim.api.nvim_win_get_config(current_win).relative ~= '' then
    vim.api.nvim_win_close(current_win, true)
    return
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      local config = vim.api.nvim_win_get_config(win)
      -- close floating windows that can be focused
      if config.relative ~= '' and config.focusable then
        vim.api.nvim_win_close(win, false) -- do not force
        count = count + 1
      end
    end
  end
  if count == 0 then -- Fallback
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('q', true, true, true),
      'n',
      false
    )
  end
end)

-- Text object: current buffer
-- stylua: ignore start
vim.keymap.set('x', 'af', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
vim.keymap.set('x', 'if', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- Text object: folds
---Returns the key sequence to select around/inside a fold,
---supposed to be called in visual mode
---@param motion 'i'|'a'
---@return string
function _G.textobj_fold(motion)
  local lnum = vim.fn.line('.') --[[@as integer]]
  local sel_start = vim.fn.line('v')
  local lev = vim.fn.foldlevel(lnum)
  local levp = vim.fn.foldlevel(lnum - 1)
  -- Multi-line selection with cursor on top of selection
  if sel_start > lnum then
    return (lev == 0 and 'zk' or lev > levp and levp > 0 and 'k' or '')
      .. vim.v.count1
      .. (motion == 'i' and ']zkV[zj' or ']zV[z')
  end
  return (lev == 0 and 'zj' or lev > levp and 'j' or '')
    .. vim.v.count1
    .. (motion == 'i' and '[zjV]zk' or '[zV]z')
end
-- stylua: ignore start
vim.keymap.set('x', 'iz', '":<C-u>silent! keepjumps normal! " . v:lua.textobj_fold("i") . "<CR>"', { silent = true, expr = true, noremap = false })
vim.keymap.set('x', 'az', '":<C-u>silent! keepjumps normal! " . v:lua.textobj_fold("a") . "<CR>"', { silent = true, expr = true, noremap = false })
vim.keymap.set('o', 'iz', '<Cmd>silent! normal Viz<CR>', { silent = true, noremap = false })
vim.keymap.set('o', 'az', '<Cmd>silent! normal Vaz<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
vim.keymap.set({ 'n', 'x' }, 'g{', function()
  local chunk_size = 10
  local linenr = vim.fn.line('.')
  local count = vim.v.count1

  -- If current line is the first line of paragraph, move one line
  -- upwards first to goto the first line of previous paragraph
  if linenr >= 2 then
    local lines = vim.api.nvim_buf_get_lines(0, linenr - 2, linenr, false)
    if lines[1]:match('^$') and lines[2]:match('%S') then
      linenr = linenr - 1
    end
  end

  while linenr >= 1 do
    local chunk = vim.api.nvim_buf_get_lines(
      0,
      math.max(0, linenr - chunk_size - 1),
      linenr - 1,
      false
    )
    for i, line in ipairs(vim.iter(chunk):rev():totable()) do
      local current_linenr = linenr - i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr + 1))
          return
        end
      elseif current_linenr <= 1 then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd('1')
        return
      end
    end
    linenr = linenr - chunk_size
  end
end, { noremap = false })

vim.keymap.set({ 'n', 'x' }, 'g}', function()
  local chunk_size = 10
  local linenr = vim.fn.line('.')
  local buf_line_count = vim.api.nvim_buf_line_count(0)
  local count = vim.v.count1

  -- If current line is the last line of paragraph, move one line
  -- downwards first to goto the last line of next paragraph
  if buf_line_count - linenr >= 1 then
    local lines = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr + 1, false)
    if lines[1]:match('%S') and lines[2]:match('^$') then
      linenr = linenr + 1
    end
  end

  while linenr <= buf_line_count do
    local chunk =
      vim.api.nvim_buf_get_lines(0, linenr, linenr + chunk_size, false)
    for i, line in ipairs(chunk) do
      local current_linenr = linenr + i
      if line:match('^$') then
        count = count - 1
        if count <= 0 then
          vim.cmd.normal({ "m'", bang = true })
          vim.cmd(tostring(current_linenr - 1))
          return
        end
      elseif current_linenr >= buf_line_count then
        vim.cmd.normal({ "m'", bang = true })
        vim.cmd(tostring(buf_line_count))
        return
      end
    end
    linenr = linenr + chunk_size
  end
end, { noremap = false })

vim.keymap.set('o', 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })
vim.keymap.set('o', 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })

-- Abbreviations
vim.keymap.set('!a', 'ture', 'true')
vim.keymap.set('!a', 'Ture', 'True')
vim.keymap.set('!a', 'flase', 'false')
vim.keymap.set('!a', 'fasle', 'false')
vim.keymap.set('!a', 'Flase', 'False')
vim.keymap.set('!a', 'Fasle', 'False')
vim.keymap.set('!a', 'lcaol', 'local')
vim.keymap.set('!a', 'lcoal', 'local')
vim.keymap.set('!a', 'locla', 'local')
vim.keymap.set('!a', 'sahre', 'share')
vim.keymap.set('!a', 'saher', 'share')
vim.keymap.set('!a', 'balme', 'blame')

utils.keymap.command_map('S', '%s/')
utils.keymap.command_map(':', 'lua ')
utils.keymap.command_abbrev('man', 'Man')
utils.keymap.command_abbrev('bt', 'bel te')
utils.keymap.command_abbrev('ep', 'e%:p:h')
utils.keymap.command_abbrev('vep', 'vs%:p:h')
utils.keymap.command_abbrev('sep', 'sp%:p:h')
utils.keymap.command_abbrev('tep', 'tabe%:p:h')
utils.keymap.command_abbrev('rm', '!rm')
utils.keymap.command_abbrev('mv', '!mv')
utils.keymap.command_abbrev('mkd', '!mkdir')
utils.keymap.command_abbrev('mkdir', '!mkdir')
utils.keymap.command_abbrev('touch', '!touch')
