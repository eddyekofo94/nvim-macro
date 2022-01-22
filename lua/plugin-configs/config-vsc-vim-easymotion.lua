local execute = vim.cmd
local g = vim.g
execute('nmap <Space> <Plug>(easymotion-prefix)')
-- Motions
execute('nmap <Space>f <Plug>(easymotion-s2)')          -- Find {char}
execute('nmap <Space>r <Plug>(easymotion-bd-jk)')       -- Move to row
execute('nmap <Space>w <Plug>(easymotion-bd-w)')
execute('nmap <Space>~ <Plug>(easymotion-jumptoanywhere)')
execute('nmap <Space>h <Plug>(easymotion-linebackward)')
execute('nmap <Space>j <Plug>(easymotion-j)')
execute('nmap <Space>k <Plug>(easymotion-k)')
execute('nmap <Space>l <Plug>(easymotion-lineforward)')
g.EasyMotion_startofline = 0    -- keep cursor column when JK motion execute
execute('nmap <Space>/ <Plug>(easymotion-sn)')
execute('nmap <Space>/ <Plug>(easymotion-tn)')
