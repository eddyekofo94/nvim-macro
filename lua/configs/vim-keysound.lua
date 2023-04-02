local function keysound_enable()
  local python = vim.fn.executable('python3') == 1 and 'python3'
    or vim.fn.executable('python') == 1 and 'python'
    or nil
  if not python then
    return
  end
  if os.execute(python .. [[ -c 'import sdl2' 2>/dev/null]]) == 0 then
    vim.cmd('KeysoundEnable')
    vim.g.keysound_theme = 'typewriter'
    vim.g.keysound_volume = 1000
  end
end

keysound_enable()
