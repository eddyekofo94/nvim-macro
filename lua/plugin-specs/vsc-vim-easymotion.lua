return {
  'asvetliakov/vim-easymotion',
  as = 'vsc-vim-easymotion',    -- Avoid name confliction
  -- Only this plugin when called by vscode
  cond = function () return (nil ~= vim.g.vscode) end,
  config = require('utils.get').config('vsc-vim-easymotion')
}
