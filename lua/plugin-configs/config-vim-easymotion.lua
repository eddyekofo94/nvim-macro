local execute = vim.cmd
local g = vim.g
execute('nmap <Leader> <Plug>(easymotion-prefix)')
-- Motions
execute('nmap <Leader>f <Plug>(easymotion-bd-f)')        -- Find {char}
execute('nmap <Leader>of <Plug>(easymotion-overwin-f)')  -- Find {char} over windows
execute('nmap <Leader>s <Plug>(easymotion-s2)')          -- Search for {char}{char}
execute('nmap <Leader>os <Plug>(easymotion-overwin-f2)')
execute('nmap <Leader>r <Plug>(easymotion-bd-jk)')       -- Move to row
execute('nmap <Leader>or <Plug>(easymotion-overwin-line)')
execute('nmap <Leader>w <Plug>(easymotion-bd-w)')
execute('nmap <Leader>ow <Plug>(easymotion-overwin-w)')
execute('nmap <Leader>; <Plug>(easymotion-jumptoanywhere)')
execute('nmap <Leader>h <Plug>(easymotion-linebackward)')
execute('nmap <Leader>j <Plug>(easymotion-j)')
execute('nmap <Leader>k <Plug>(easymotion-k)')
execute('nmap <Leader>l <Plug>(easymotion-lineforward)')
g.EasyMotion_startofline = 0    -- keep cursor column when JK motion execute
execute('nmap / <Plug>(easymotion-sn)')
execute('nmap / <Plug>(easymotion-tn)')
