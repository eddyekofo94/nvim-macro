local Utils = require "utils.keymap.keymaps"
local General = require "utils.general"
local Buffer = require "utils.buffer"

local map = Utils.set_keymap
local lmap = Utils.set_leader_keymap
local nxo = Utils.nxo

local Keymap = {}

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map({ "n", "v" }, "<leader>ll", function()
  local state = vim.o.number
  vim.o.number = not state
  vim.o.relativenumber = not state
end, { desc = "toggle [l]ine number mode" })

Keymap.__index = Keymap
function Keymap.new(mode, lhs, rhs, opts)
  local action = function()
    if type(opts) == "string" then
      opts = { desc = opts }
    end
    local merged_opts = vim.tbl_extend("force", { noremap = true, silent = true }, opts or {})
    map(mode, lhs, rhs, merged_opts)
  end
  return setmetatable({ action = action }, Keymap)
end

function Keymap:bind(nextMapping)
  self.action()
  return nextMapping
end

function Keymap:execute()
  self.action()
end

--  INFO: Buffers
Keymap
  .new("n", "<leader>wh", function()
    return Buffer.hide_window(0)
  end, "Hide window")
  :bind(Keymap.new("n", "<leader>wx", function()
    return Buffer.close_window()
  end, "Close current windows "))
  :bind(Keymap.new("n", "<leader>wX", function()
    return Buffer.close_all_visible_window(false)
  end, "Close all windows but current"))
  :bind(Keymap.new("n", "<leader>bH", function()
    Buffer.close_all_empty_buffers()
  end, "Close hidden/empty buffers"))
  :bind(Keymap.new("n", "<leader>bx", function()
    Buffer.close_buffer(0, false)
  end, "Close all buffers except current"))
  :bind(Keymap.new("n", "<leader>bX", function()
    Buffer.close_all_buffers(true, true)
  end, "Close all buffers except current"))
  :bind(Keymap.new("n", "<leader>bR", function()
    Buffer.reset()
  end, "Close all buf/win except current"))
  :bind(Keymap.new("n", "<S-x>", function()
    Buffer.close_buffer(0, true)
  end, "[Force] Close buffer"))
  -- :bind(Keymap.new())
  --  TODO: 2024-02-15 13:25 PM - Implement this in the near
  -- future
  -- ["<leader>wV"] = {
  --   function()
  --     return Buffers.close_all_hidden_buffers()
  --   end,
  --   "Close all windows but current",
  -- },
  :execute()

Keymap.new("i", "<C-b>", "<ESC>^i")
  :bind(Keymap.new("i", "<C-c>", "<esc>", "CTRL-C doesn't trigger the InsertLeave autocmd . map to <ESC> instead."))
  :bind(Keymap.new("i", "<C-a>", "<End>"))
  :bind(Keymap.new("i", "<C-l>", function()
    return Utils.escapePair()
  end, "move over a closing element in insert mode"))
  :execute()

-- INFO: Search always center
Keymap.new("n", "<C-u>", "zz<C-u>")
  :bind(Keymap.new("n", "<C-d>", "zz<C-d>"))
  :bind(Keymap.new("n", "{", "zz{"))
  :bind(Keymap.new("n", "}", "zz}"))
  :bind(Keymap.new("n", "n", function()
    vim.cmd.normal {
      "zzn",
      bang = true,
      mods = { emsg_silent = true },
    }
  end))
  :bind(Keymap.new("n", "N", function()
    vim.cmd.normal {
      "zzN",
      bang = true,
      mods = { emsg_silent = true },
    }
  end))
  :bind(Keymap.new("n", "<C-i>", "zz<C-i>"))
  :bind(Keymap.new("n", "<C-o>", "zz<C-o>"))
  :bind(Keymap.new("n", "%", "zz%"))
  :bind(Keymap.new("n", "*", "zz*"))
  :bind(Keymap.new("n", "#", "zz#"))
  :execute()

--  INFO: General
--  TODO: 2024-07-04 - Turn this to a Lua method, 0 = first character on the line
-- function! LineHome()
--   let x = col('.')
--   execute "normal ^"
--   if x == col('.')
--     unmap 0
--     execute "normal 0"
--     map 0 :call LineHome()<CR>:echo<CR>
--   endif
--   return ""
-- endfunction

Keymap
  .new("n", "<leader>hh", "<cmd>nohl<BAR>redraws<cr>", "Clear highlight")
  :bind(
    -- Clear search, diff update and redraw
    -- taken from runtime/lua/_editor.lua
    Keymap.new(
      "n",
      "<leader>ur",
      "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
      { desc = "Redraw / clear hlsearch / diff update" }
    )
  )
  :bind(Keymap.new({ "i", "n" }, "<esc>", "<cmd>noh<bar>redraws<cr><esc>", "Escape and clear hlsearch"))
  :bind(Keymap.new("n", "<leader>mm", "<cmd>messages<cr>"))
  :bind(
    Keymap.new("n", "<leader>oo", ':<C-u>call append(line("."),   repeat([""], v:count1))<CR>', "insert line below")
  )
  :bind(
    Keymap.new("n", "<leader>OO", ':<C-u>call append(line(".")-1, repeat([""], v:count1))<CR>', "insert line above")
  )
  -- INFO: Reload Vim
  :bind(Keymap.new("n", "<leader>vR", function()
    require("utils").general.reload(false)
  end, "[v]im [R]eload"))
  :bind(Keymap.new("n", "<leader>L", "<cmd>Lazy<CR>", "Lazy"))
  :bind(Keymap.new("n", "<leader>N", "<cmd>Noice<CR>", "Noice"))
  :bind(Keymap.new("n", "<leader>M", "<cmd>Mason<CR>", "Mason"))
  :bind(Keymap.new("n", "<leader>zz", "<cmd>ZenMode<cr>", "Zen mode"))
  :bind(Keymap.new("n", "<leader>ca", ": %y+<CR>", "COPY EVERYTHING/ALL"))
  :bind(Keymap.new("v", "/", '"fy/\\V<C-R>f<CR>'))
  :bind(Keymap.new("v", "*", '"fy/\\V<C-R>f<CR>'))
  :bind(Keymap.new(nxo, "gh", "g^", " move to start of line"))
  :bind(Keymap.new(nxo, "gl", "g$", " move to end of line"))
  :bind(Keymap.new("x", "p", '"_dP', "don't yank on paste"))
  :bind(Keymap.new("x", "v", "$h", "select until end"))
  :bind(Keymap.new("x", "p", '"_dP', "don't yank on paste"))
  :bind(Keymap.new({ "n", "x" }, "c", '"_c'))
  :bind(Keymap.new({ "n", "x" }, "C", '"_C'))
  :bind(Keymap.new({ "n", "x" }, "S", '"_S', "Don't save to register"))
  :bind(Keymap.new({ "n", "x" }, "x", '"_x'))
  :bind(Keymap.new("x", "X", '"_c'))
  :bind(Keymap.new("n", "<M-l>", function()
    return Utils.escapePair()
  end, "move over a closing element in normal mode"))
  :bind(Keymap.new("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" }))
  :bind(Keymap.new("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" }))
  -- :bind(Keymap.new("n", "<leader>qq", function() -- DISABLED: for quicker.nvim
  --   require("utils.functions").toggle_qf()
  -- end, { desc = "Toggle quickfix" }))
  :execute()

-- Use <C-\><C-r> to insert contents of a register in terminal mode
map("t", [[<C-\><C-r>]], [['<C-\><C-n>"' . nr2char(getchar()) . 'pi']], { expr = true })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

map("t", "<C-x>", vim.api.nvim_replace_termcodes("<C-\\><C-N>", true, true, true), "Escape terminal mode")

map("n", "i", function()
  if #vim.fn.getline "." == 0 then
    return [["_cc]]
  else
    return "i"
  end
end, { expr = true, desc = "rebind 'i' to do a smart-indent if its a blank line" })

map("n", "dd", function()
  if vim.api.nvim_get_current_line():match "^%s*$" then
    return '"_dd'
  else
    return "dd"
  end
end, { expr = true, desc = "Don't yank empty lines into the main register" })

-- Multi-window operations
-- stylua: ignore start
map({ 'x', 'n' }, '<M-W>',      '<C-w>W')
map({ 'x', 'n' }, '<M-H>',      '<C-w>H')
map({ 'x', 'n' }, '<M-J>',      '<C-w>J')
map({ 'x', 'n' }, '<M-K>',      '<C-w>K')
map({ 'x', 'n' }, '<M-L>',      '<C-w>L')
map({ 'x', 'n' }, '<M-p>',      '<C-w>p')
map({ 'x', 'n' }, '<M-r>',      '<C-w>r')
map({ 'x', 'n' }, '<M-v>',      '<C-w>v')
map({ 'x', 'n' }, '<M-s>',      '<C-w>s')
map({ 'x', 'n' }, '<M-x>',      '<C-w>x')
map({ 'x', 'n' }, '<M-z>',      '<C-w>z')
map({ 'x', 'n' }, '<M-c>',      '<C-w>c')
map({ 'x', 'n' }, '<M-q>',      '<C-w>q')
map({ 'x', 'n' }, '<M-n>',      '<C-w>n')
map({ 'x', 'n' }, '<M-o>',      '<C-w>o')
map({ 'x', 'n' }, '<M-t>',      '<C-w>t')
map({ 'x', 'n' }, '<M-T>',      '<C-w>T')
map({ 'x', 'n' }, '<M-]>',      '<C-w>]')
map({ 'x', 'n' }, '<M-^>',      '<C-w>^')
map({ 'x', 'n' }, '<M-b>',      '<C-w>b')
map({ 'x', 'n' }, '<M-d>',      '<C-w>d')
map({ 'x', 'n' }, '<M-f>',      '<C-w>f')
map({ 'x', 'n' }, '<M-}>',      '<C-w>}')
map({ 'x', 'n' }, '<M-g>]',     '<C-w>g]')
map({ 'x', 'n' }, '<M-g>}',     '<C-w>g}')
map({ 'x', 'n' }, '<M-g>f',     '<C-w>gf')
map({ 'x', 'n' }, '<M-g>F',     '<C-w>gF')
map({ 'x', 'n' }, '<M-g>t',     '<C-w>gt', "Go to next Tab")
map({ 'x', 'n' }, '<M-g>T',     '<C-w>gT', "Go to next Tab")
map({ 'x', 'n' }, '<M-w>',      '<C-w><C-w>')
map({ 'x', 'n' }, '<M-h>',      '<C-w><C-h>')
map({ 'x', 'n' }, '<M-j>',      '<C-w><C-j>')
map({ 'x', 'n' }, '<M-k>',      '<C-w><C-k>')
map({ 'x', 'n' }, '<M-l>',      '<C-w><C-l>')
map({ 'x', 'n' }, '<M-g><M-]>', '<C-w>g<C-]>')
map({ 'x', 'n' }, '<M-g><Tab>', '<C-w>g<Tab>', "Go to next Tab")

map({ 'x', 'n' }, '<M-=>', '<C-w>=')
map({ 'x', 'n' }, '<M-_>', '<C-w>_')
map({ 'x', 'n' }, '<M-|>', '<C-w>|')
map({ 'x', 'n' }, '<M-+>', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
map({ 'x', 'n' }, '<M-->', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
map({ 'x', 'n' }, '<M->>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
map({ 'x', 'n' }, '<M-<>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
map({ 'x', 'n' }, '<M-.>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
map({ 'x', 'n' }, '<M-,>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })

map({ 'x', 'n' }, '<C-w>>', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
map({ 'x', 'n' }, '<C-w><', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
map({ 'x', 'n' }, '<C-w>,', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w><" : "<C-w>>")', { expr = true })
map({ 'x', 'n' }, '<C-w>.', '(v:count ? "" : 4) . (winnr() == winnr("l") ? "<C-w>>" : "<C-w><")', { expr = true })
map({ 'x', 'n' }, '<C-w>+', 'v:count ? "<C-w>+" : "2<C-w>+"', { expr = true })
map({ 'x', 'n' }, '<C-w>-', 'v:count ? "<C-w>-" : "2<C-w>-"', { expr = true })
-- stylua: ignore end

-- Terminal mode keymaps
-- stylua: ignore start
map('t', '<C-6>', [[v:lua.require'utils.term'.running_tui() ? "<C-6>" : "<Cmd>b#<CR>"]],        { expr = true, replace_keycodes = false })
map('t', '<C-^>', [[v:lua.require'utils.term'.running_tui() ? "<C-^>" : "<Cmd>b#<CR>"]],        { expr = true, replace_keycodes = false })
map('t', '<Esc>', [[v:lua.require'utils.term'.running_tui() ? "<Esc>" : "<Cmd>stopi<CR>"]],     { expr = true, replace_keycodes = false })
map('t', '<M-v>', [[v:lua.require'utils.term'.running_tui() ? "<M-v>" : "<Cmd>wincmd v<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-s>', [[v:lua.require'utils.term'.running_tui() ? "<M-s>" : "<Cmd>wincmd s<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-W>', [[v:lua.require'utils.term'.running_tui() ? "<M-W>" : "<Cmd>wincmd W<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-H>', [[v:lua.require'utils.term'.running_tui() ? "<M-H>" : "<Cmd>wincmd H<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-J>', [[v:lua.require'utils.term'.running_tui() ? "<M-J>" : "<Cmd>wincmd J<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-K>', [[v:lua.require'utils.term'.running_tui() ? "<M-K>" : "<Cmd>wincmd K<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-L>', [[v:lua.require'utils.term'.running_tui() ? "<M-L>" : "<Cmd>wincmd L<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-r>', [[v:lua.require'utils.term'.running_tui() ? "<M-r>" : "<Cmd>wincmd r<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-R>', [[v:lua.require'utils.term'.running_tui() ? "<M-R>" : "<Cmd>wincmd R<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-x>', [[v:lua.require'utils.term'.running_tui() ? "<M-x>" : "<Cmd>wincmd x<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-p>', [[v:lua.require'utils.term'.running_tui() ? "<M-p>" : "<Cmd>wincmd p<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-c>', [[v:lua.require'utils.term'.running_tui() ? "<M-c>" : "<Cmd>wincmd c<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-q>', [[v:lua.require'utils.term'.running_tui() ? "<M-q>" : "<Cmd>wincmd q<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-o>', [[v:lua.require'utils.term'.running_tui() ? "<M-o>" : "<Cmd>wincmd o<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-w>', [[v:lua.require'utils.term'.running_tui() ? "<M-w>" : "<Cmd>wincmd w<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-h>', [[v:lua.require'utils.term'.running_tui() ? "<M-h>" : "<Cmd>wincmd h<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-j>', [[v:lua.require'utils.term'.running_tui() ? "<M-j>" : "<Cmd>wincmd j<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-k>', [[v:lua.require'utils.term'.running_tui() ? "<M-k>" : "<Cmd>wincmd k<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-l>', [[v:lua.require'utils.term'.running_tui() ? "<M-l>" : "<Cmd>wincmd l<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-=>', [[v:lua.require'utils.term'.running_tui() ? "<M-=>" : "<Cmd>wincmd =<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-_>', [[v:lua.require'utils.term'.running_tui() ? "<M-_>" : "<Cmd>wincmd _<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-|>', [[v:lua.require'utils.term'.running_tui() ? "<M-|>" : "<Cmd>wincmd |<CR>"]],  { expr = true, replace_keycodes = false })
map('t', '<M-+>', [[v:lua.require'utils.term'.running_tui() ? "<M-+>" : "<Cmd>wincmd 2+<CR>"]], { expr = true, replace_keycodes = false })
map('t', '<M-->', [[v:lua.require'utils.term'.running_tui() ? "<M-->" : "<Cmd>wincmd 2-<CR>"]], { expr = true, replace_keycodes = false })
map('t', '<M->>', [[v:lua.require'utils.term'.running_tui() ? "<M->>" : "<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"]], { expr = true })
map('t', '<M-<>', [[v:lua.require'utils.term'.running_tui() ? "<M-<>" : "<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"]], { expr = true })
map('t', '<M-.>', [[v:lua.require'utils.term'.running_tui() ? "<M-.>" : "<Cmd>wincmd 4" . (winnr() == winnr("l") ? "<" : ">") . "<CR>"]], { expr = true })
map('t', '<M-,>', [[v:lua.require'utils.term'.running_tui() ? "<M-,>" : "<Cmd>wincmd 4" . (winnr() == winnr("l") ? ">" : "<") . "<CR>"]], { expr = true })
-- stylua: ignore end

-- Use <C-\><C-r> to insert contents of a register in terminal mode
map("t", [[<C-\><C-r>]], [['<C-\><C-n>"' . nr2char(getchar()) . 'pi']], { expr = true })

-- Past with correct indentation in insert mode
map("i", "<C-r>", "<C-r><C-p>")

-- More consistent behavior when &wrap is set
-- stylua: ignore start
map({ 'n', 'x' }, 'j', 'v:count ? "j" : "gj"', { expr = true })
map({ 'n', 'x' }, 'k', 'v:count ? "k" : "gk"', { expr = true })
map({ 'n', 'x' }, '<Down>', 'v:count ? "<Down>" : "g<Down>"', { expr = true, replace_keycodes = false })
map({ 'n', 'x' }, '<Up>',   'v:count ? "<Up>"   : "g<Up>"',   { expr = true, replace_keycodes = false })
map({ 'i' }, '<Down>', '<Cmd>norm! g<Down><CR>')
map({ 'i' }, '<Up>',   '<Cmd>norm! g<Up><CR>')
-- stylua: ignore end

-- Buffer navigation
map("n", "]b", '<Cmd>exec v:count1 . "bn"<CR>')
map("n", "[b", '<Cmd>exec v:count1 . "bp"<CR>')

-- Tabpages
---@param tab_action function
---@param default_count number?
---@return function
local function tabswitch(tab_action, default_count)
  return function()
    local count = default_count or vim.v.count
    local num_tabs = vim.fn.tabpagenr "$"
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
map({ "n", "x" }, "gt", tabswitch(vim.cmd.tabnext))
map({ "n", "x" }, "gT", tabswitch(vim.cmd.tabprev))
map({ "n", "x" }, "gy", tabswitch(vim.cmd.tabprev)) -- gT is too hard to press

map({ "n", "x" }, "<Leader>0", "<Cmd>0tabnew<CR>")
map({ "n", "x" }, "<Leader>1", tabswitch(vim.cmd.tabnext, 1))
map({ "n", "x" }, "<Leader>2", tabswitch(vim.cmd.tabnext, 2))
map({ "n", "x" }, "<Leader>3", tabswitch(vim.cmd.tabnext, 3))
map({ "n", "x" }, "<Leader>4", tabswitch(vim.cmd.tabnext, 4))
map({ "n", "x" }, "<Leader>5", tabswitch(vim.cmd.tabnext, 5))
map({ "n", "x" }, "<Leader>6", tabswitch(vim.cmd.tabnext, 6))
map({ "n", "x" }, "<Leader>7", tabswitch(vim.cmd.tabnext, 7))
map({ "n", "x" }, "<Leader>8", tabswitch(vim.cmd.tabnext, 8))
map({ "n", "x" }, "<Leader>9", tabswitch(vim.cmd.tabnext, 9))

-- Complete line
-- map("i", "<C-l>", "<C-x><C-l>")

-- Correct misspelled word / mark as correct
map("i", "<C-g>+", "<Esc>[szg`]a")
map("i", "<C-g>=", "<C-g>u<Esc>[s1z=`]a<C-G>u")

-- Only clear highlights and message area and don't redraw if search
-- highlighting is on to avoid flickering
-- Use `:sil! dif` to suppress error
-- 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits'
-- in command window
map(
  { "n", "x" },
  "<C-l>",
  [['<Cmd>ec|noh|sil! dif<CR>' . (v:hlsearch ? '' : '<C-l>')]],
  { expr = true, replace_keycodes = false }
)

-- Don't include extra spaces around quotes
map({ "o", "x" }, 'a"', '2i"', { noremap = false })
map({ "o", "x" }, "a'", "2i'", { noremap = false })
map({ "o", "x" }, "a`", "2i`", { noremap = false })

-- Close all floating windows
map({ "n", "x" }, "q", function()
  require("utils.misc").q()
end)

-- Edit current file's directory
map({ "n", "x" }, "-", "<Cmd>e%:p:h<CR>")

-- Enter insert mode, add a space after the cursor
map({ "n", "x" }, "<M-i>", "i<Space><Left>")
map({ "n", "x" }, "<M-I>", "I<Space><Left>")
map({ "n", "x" }, "<M-a>", "a<Space><Left>")
map({ "n", "x" }, "<M-A>", "A<Space><Left>")

-- Text object: current buffer
-- stylua: ignore start
map('x', 'af', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
map('x', 'if', ':<C-u>silent! keepjumps normal! ggVG<CR>', { silent = true, noremap = false })
map('o', 'af', '<Cmd>silent! normal m`Vaf<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
map('o', 'if', '<Cmd>silent! normal m`Vif<CR><Cmd>silent! normal! ``<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- stylua: ignore start
map('x', 'iz', [[':<C-u>silent! keepjumps normal! ' . v:lua.require'utils.misc'.textobj_fold('i') . '<CR>']], { silent = true, expr = true, noremap = false })
map('x', 'az', [[':<C-u>silent! keepjumps normal! ' . v:lua.require'utils.misc'.textobj_fold('a') . '<CR>']], { silent = true, expr = true, noremap = false })
map('o', 'iz', '<Cmd>silent! normal Viz<CR>', { silent = true, noremap = false })
map('o', 'az', '<Cmd>silent! normal Vaz<CR>', { silent = true, noremap = false })
-- stylua: ignore end

-- Use 'g{' and 'g}' to move to the first/last line of a paragraph
-- stylua: ignore start
map({ 'o' }, 'g{', '<Cmd>silent! normal Vg{<CR>', { noremap = false })
map({ 'o' }, 'g}', '<Cmd>silent! normal Vg}<CR>', { noremap = false })
map({ 'n', 'x' }, 'g{', function() require('utils.misc').goto_paragraph_firstline() end, { noremap = false })
map({ 'n', 'x' }, 'g}', function() require('utils.misc').goto_paragraph_lastline() end, { noremap = false })
-- stylua: ignore end

-- Fzf keymaps
-- map("n", "<Leader>.", "<Cmd>FZF<CR>")
-- map("n", "<Leader>ff", "<Cmd>FZF<CR>")

-- Abbreviations
map("!a", "ture", "true")
map("!a", "Ture", "True")
map("!a", "flase", "false")
map("!a", "fasle", "false")
map("!a", "Flase", "False")
map("!a", "Fasle", "False")
map("!a", "lcaol", "local")
map("!a", "lcoal", "local")
map("!a", "locla", "local")
map("!a", "sahre", "share")
map("!a", "saher", "share")
map("!a", "balme", "blame")

vim.api.nvim_create_autocmd("CmdlineEnter", {
  once = true,
  callback = function()
    if General.is_available "telescope.nvim" then
      Utils.command_abbrev("tel", "Telescope")
    end
    -- local utils = require "utils"
    Utils.command_abbrev("Xa", "xa")
    Utils.command_abbrev("Qa", "qa")
    Utils.command_abbrev("QA", "qa")
    Utils.command_abbrev("W", "w")
    Utils.command_abbrev("Wqa", "wqa")
    Utils.command_abbrev("Wq", "wq")
    Utils.command_abbrev("Wa", "wa")
    Utils.command_abbrev("ep", "e%:p:h")
    Utils.command_abbrev("vep", "vs%:p:h")
    Utils.command_abbrev("sep", "sp%:p:h")
    Utils.command_abbrev("tep", "tabe%:p:h")
    Utils.command_map(":", "lua ")
    Utils.command_abbrev("man", "Man")
    Utils.command_abbrev("ht", "hor te")
    Utils.command_abbrev("vt", "vert te")
    Utils.command_abbrev("rm", "!rm")
    Utils.command_abbrev("mv", "!mv")
    Utils.command_abbrev("git", "!git")
    Utils.command_abbrev("mkd", "!mkdir")
    Utils.command_abbrev("mkdir", "!mkdir")
    Utils.command_abbrev("touch", "!touch")
    return true
  end,
})
