local api = vim.api
local ui = vim.ui
local fn = vim.fn
local uv = vim.loop
local cmd = vim.cmd

local function insert_image()
  local title
  ui.input({ prompt = 'Image title: ' }, function(input) title = input end)
  if not title or string.match(title, '^%s*$') then
    return
  end

  -- create directory and blank image file
  local fname = title:gsub('%s+', '_'):lower() .. '.drawio.png'
  local path = fn.expand('%:p:h') .. '/pic/' .. fn.expand('%:t:r')
  local stat = uv.fs_stat(path)
  if not stat or stat.type ~= 'directory' then
    fn.mkdir(path, 'p')
  end
  os.execute('cp ' .. fn.stdpath('config')
    .. '/ftplugin/markdown/resources/blank.drawio.png '
    .. path .. '/' .. fname)

  -- insert link
  cmd.lcd(fn.expand('%:p:h'))
  local link = string.format('![%s](%s)', title,
    fn.fnamemodify(path .. '/' .. fname, ':~:.'))
  cmd.lcd('-')
  fn.append(fn.line('.'), link)

  -- copy file path to system clipboard
  os.execute('echo ' .. path .. ' | xclip -sel clip')

  -- open drawio
  if _G.handler_drawio and not _G.handler_drawio:is_closing() then
    _G.handler_drawio:close()
  end
  _G.handler_drawio = uv.spawn('drawio', {
    args = { path .. '/' .. fname },
    detached = true,
  }, vim.schedule_wrap(function(code_drawio, _)
    if _G.handler_drawio and not _G.handler_drawio:is_closing() then
      _G.handler_drawio:close()
    end
    if code_drawio ~= 0 then
      vim.notify(string.format('task failed with code %d',
        code_drawio), vim.log.levels.ERROR)
    end
  end))
end

api.nvim_create_user_command('MarkdownInsertImage', insert_image, {
  desc = 'Insert an image on the current line'
})
