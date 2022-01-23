local execute = vim.cmd
local g = vim.g
execute('nmap <Leader><Leader> <Plug>(easymotion-prefix)')
-- Motions
execute('nmap <Leader><Leader>f <Plug>(easymotion-s2)')          -- Find {char}
execute('nmap <Leader><Leader>r <Plug>(easymotion-bd-jk)')       -- Move to row
execute('nmap <Leader><Leader>w <Plug>(easymotion-bd-w)')
execute('nmap <Leader><Leader>; <Plug>(easymotion-jumptoanywhere)')
execute('nmap <Leader><Leader>h <Plug>(easymotion-linebackward)')
execute('nmap <Leader><Leader>j <Plug>(easymotion-j)')
execute('nmap <Leader><Leader>k <Plug>(easymotion-k)')
execute('nmap <Leader><Leader>l <Plug>(easymotion-lineforward)')
g.EasyMotion_startofline = 0    -- keep cursor column when JK motion execute
execute('nmap / <Plug>(easymotion-sn)')
execute('nmap / <Plug>(easymotion-tn)')
