local execute = vim.cmd
local g = vim.g
execute('nmap ; <Plug>(easymotion-prefix)')
-- Motions
execute('nmap ;f <Plug>(easymotion-bd-f)')        -- Find {char}
execute('nmap ;of <Plug>(easymotion-overwin-f)')  -- Find {char} over windows
execute('nmap ;s <Plug>(easymotion-s2)')          -- Search for {char}{char}
execute('nmap ;os <Plug>(easymotion-overwin-f2)')
execute('nmap ;l <Plug>(easymotion-bd-jk)')       -- Move to line
execute('nmap ;ol <Plug>(easymotion-overwin-line)')
execute('nmap ;w <Plug>(easymotion-bd-w)')
execute('nmap ;ow <Plug>(easymotion-overwin-w)')
execute('nmap ;; <Plug>(easymotion-jumptoanywhere)')
g.EasyMotion_startofline = 0    -- keep cursor column when JK motion execute
execute('nmap / <Plug>(easymotion-sn)')
execute('nmap / <Plug>(easymotion-tn)')
