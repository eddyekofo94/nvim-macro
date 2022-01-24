return {
  'tpope/vim-surround',
  event = 'InsertEnter',
  -- To repeat surrounding operations
  requires = require('utils/get').spec('vim-repeat')
}
-- Change surrounding from <char1> to <char2>: cs<char1><char2>
-- Change surrounding to <char>: cst<char>
-- Delete surrounding <char>: ds<char>
-- Add surrounding with <char>: ys<text obj><char>
-- Wrap the entire line: yss<char>
-- Surround multiple lines in visual mode (with tags): VS<char>
--                                                    /  \
--                                line-wise visual mode  surround
