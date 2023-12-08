---Setup input method auto switch
---@return nil
local function setup()
  if vim.g.loaded_im ~= nil then
    return
  end
  vim.g.loaded_im = true

  if
    vim.env.SSH_TTY
    or vim.uv.os_uname().sysname:match('nix$')
      and vim.env.DISPLAY == nil
      and vim.env.WAYLAND_DISPLAY == nil
  then
    return
  end

  local fcitx_cmd = vim.fn.executable('fcitx5-remote') == 1 and 'fcitx5-remote'
    or vim.fn.executable('fcitx-remote') == 1 and 'fcitx-remote'
  if not fcitx_cmd then
    return
  end

  ---@return nil
  local function im_activate()
    if vim.b.im_toggle_flag then
      vim.system({ fcitx_cmd, '-o' })
      vim.b.im_toggle_flag = nil
    end
  end

  ---@return nil
  local function im_deactivate()
    vim.system({ fcitx_cmd }, {}, function(obj)
      if obj.code ~= 0 or tonumber(obj.stdout) == 2 then
        vim.b.im_toggle_flag = true
        vim.system({ fcitx_cmd, '-c' })
      end
    end)
  end

  local groupid = vim.api.nvim_create_augroup('IMSwitch', {})
  vim.api.nvim_create_autocmd('InsertEnter', {
    group = groupid,
    callback = im_activate,
  })
  vim.api.nvim_create_autocmd('CmdlineEnter', {
    group = groupid,
    pattern = '[/\\?]',
    callback = im_activate,
  })
  vim.api.nvim_create_autocmd({ 'CmdlineLeave', 'InsertLeave' }, {
    group = groupid,
    callback = im_deactivate,
  })
end

return {
  setup = setup,
}
