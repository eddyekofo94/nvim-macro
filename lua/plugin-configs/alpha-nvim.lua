local alpha = require('alpha')
local dashboard = require('alpha.themes.dashboard')

local leader = '<LD>'

local function button(sc, txt, leader_txt, keybind, keybind_opts)
  local sc_after = sc:gsub('%s', ''):gsub(leader_txt, '<leader>')

  local opts = {
    position = 'center',
    shortcut = sc,
    cursor = 5,
    width = 50,
    align_shortcut = 'right',
    hl_shortcut = 'Keyword',
  }

  if nil == keybind then
    keybind = sc_after
  end
  keybind_opts = vim.F.if_nil(keybind_opts, { noremap = true, silent = true, nowait = true })
  opts.keymap = { 'n', sc_after, keybind, keybind_opts }

  local function on_press()
    -- local key = vim.api.nvim_replace_termcodes(keybind .. '<Ignore>', true, false, true)
    local key = vim.api.nvim_replace_termcodes(sc_after .. '<Ignore>', true, false, true)
    vim.api.nvim_feedkeys(key, 't', false)
  end

  return {
    type = 'button',
    val = txt,
    on_press = on_press,
    opts = opts,
  }
end

dashboard.section.buttons.val= {
  button('e', '  New file', leader, '<cmd>ene<CR>'),
  button('s', '  Sync plugins' , leader, [[<cmd>echo 'Syncing...' | PackerSync<CR>]]),
  button(leader .. ' f f', '  Find files', leader, '<cmd>Telescope find_files<CR>'),
  button(leader .. ' fof', '  Find old files', leader, '<cmd>Telescope oldfiles<CR>'),
  button(leader .. ' f ;', 'ﭨ  Live grep', leader, '<cmd>Telescope live_grep<CR>'),
  button(leader .. ' f g', '  Git status', leader, '<cmd>Telescope git_status<CR>'),
  button(leader .. '   q', '  Quit' , leader, '<cmd>qa<CR>')
}

-- Foot must be a table so that its height is correctly measured
dashboard.section.footer.val = { #vim.tbl_keys(packer_plugins) .. ' plugins ﮣ loaded' }
dashboard.section.footer.opts.hl = 'Comment'

local height = #dashboard.section.header.val + 2 * #dashboard.section.buttons.val
               + #dashboard.section.footer.val + 5
local header_padding = math.floor((vim.fn.winheight('$') - height) * 0.4)
if 0 > header_padding then header_padding = 0 end

dashboard.config.layout = {
  { type = 'padding', val = header_padding },
  dashboard.section.header,
  { type = 'padding', val = 4 },
  dashboard.section.buttons,
  { type = 'padding', val = 1 },
  dashboard.section.footer
}

alpha.setup(dashboard.opts)
