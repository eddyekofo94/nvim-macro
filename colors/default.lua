-- Name:         default
-- Description:  Improves default colorscheme
-- Author:       Bekaboo <kankefengjing@gmail.com>
-- Maintainer:   Bekaboo <kankefengjing@gmail.com>
-- License:      GPL-3.0
-- Last Updated: Sat 30 Dec 2023 05:57:00 AM CST

vim.cmd.hi('clear')
vim.g.colors_name = 'default'

if vim.go.background == 'dark' then
  vim.api.nvim_set_hl(0, 'Comment', { fg = 'NvimDarkGrey4', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'LineNr', { fg = 'NvimDarkGrey4', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'NonText', { fg = 'NvimDarkGrey4', ctermfg = 8 })
  vim.api.nvim_set_hl(0, 'SpellBad', { underdashed = true, cterm = {} })
  vim.api.nvim_set_hl(0, 'NormalFloat', {
    bg = 'NvimDarkGrey1',
    ctermbg = 7,
    ctermfg = 0,
  })
end

-- vim:ts=2:sw=2:sts=2:fdm=marker:fdl=0
