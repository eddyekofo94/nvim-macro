local twilight = require('twilight')
local limelight_check = require('configs.limelight').limelight_check

twilight.setup({
  context = 0,
  dimming = {
    alpha = 0.4,
    color = { 'Turquoise', '#7fa0af' },
    term_bg = '#171d2b',
  },
  exclude = { 'markdown', 'tex' }
})

vim.api.nvim_create_user_command('Twilight', function(_)
  twilight.toggle()
  vim.g.twilight_active = not vim.g.twilight_active
  limelight_check()
end, { desc = 'Toggle twilight.nvim and limelight.vim' })
vim.api.nvim_create_user_command('TwilightDisable', function(_)
  twilight.disable()
  vim.g.twilight_active = false
  limelight_check()
end, { desc = 'Disable twilight.nvim and limelight.vim' })
vim.api.nvim_create_user_command('TwilightEnable', function(_)
  twilight.enable()
  vim.g.twilight_active = true
  limelight_check()
end, { desc = 'Enable twilight.nvim and limelight.vim' })

vim.keymap.set('n', '<Leader>;', '<Cmd>Twilight<CR>', {
  silent = true,
  noremap = true
})
