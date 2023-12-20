local keymap = require('utils.keymap').set_keymap
local nxo = require('utils.keymap').nxo

return {
  {
    'chrisgrieser/nvim-spider',
    opts = {
      skipInsignificantPunctuation = true,
    },
    keys = { 'w', 'e', 'b', 'ge' },
    config = function()
      keymap(nxo, 'w', function()
        require('spider').motion('w', { skipInsignificantPunctuation = false })
      end, 'Spider-w')
      keymap(
        nxo,
        'e',
        "<cmd>lua require('spider').motion('e')<CR>",
        'Spider-e'
      )
      keymap(
        nxo,
        'b',
        "<cmd>lua require('spider').motion('b')<CR>",
        'Spider-b'
      )
      keymap(
        nxo,
        'ge',
        "<cmd>lua require('spider').motion('ge')<CR>",
        { desc = 'Spider-ge' }
      )
    end,
  },
}
