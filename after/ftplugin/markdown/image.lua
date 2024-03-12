local api = vim.api
local ui = vim.ui
local fn = vim.fn
local uv = vim.uv
local cmd = vim.cmd

---Make directory for the image
local function make_image_dir(path)
  local stat = uv.fs_stat(path)
  if not stat or stat.type ~= 'directory' then
    fn.mkdir(path, 'p')
  end
end

---Get image name
local function get_image_name()
  local name
  ui.input({
    prompt = 'Image name: ',
    default = os.date('%y-%m-%d-%H-%M-%S'),
  }, function(input)
    name = input
  end)
  if not name or string.match(name, '^%s*$') then
    return
  end
  return name
end

---Insert a link for the image
---@param path string path to the image
---@param fname string filename of the image
local function insert_link(path, fname)
  cmd('silent! lcd ' .. fn.expand('%:p:h'))
  local link = string.format(
    '![%s](%s)',
    fn.fnamemodify(fname, ':t:r'),
    fn.fnamemodify(vim.fs.joinpath(path, fname), ':~:.')
  )
  cmd('silent! lcd -')
  fn.append(fn.line('.'), link)
end

---Insert an image
local function insert_image()
  local title = get_image_name()
  if not title then
    return
  end

  -- create directory and blank image file
  local fname = title:gsub('%s+', '_'):lower() .. '.drawio.png'
  local path = vim.fs.joinpath(
    fn.expand('%:p:h') --[[@as string]],
    'pic',
    fn.expand('%:t:r')
  )
  make_image_dir(path)
  vim.system({
    'cp',
    vim.fs.joinpath(
      fn.stdpath('config') --[[@as string]],
      'after',
      'ftplugin',
      'markdown',
      'resources',
      'blank.drawio.png'
    ),
    vim.fs.joinpath(path, fname),
  })

  -- insert link
  insert_link(fname, path)

  -- copy file path to system clipboard
  os.execute('echo "' .. path .. '" | xclip -sel clip')

  -- open drawio
  if _G.handler_drawio and not _G.handler_drawio:is_closing() then
    _G.handler_drawio:close()
  end
  _G.handler_drawio = uv.spawn(
    'drawio',
    ---@diagnostic disable-next-line: missing-fields
    {
      args = { vim.fs.joinpath(path, fname) },
      detached = true,
    },
    vim.schedule_wrap(function(code_drawio, _)
      if _G.handler_drawio and not _G.handler_drawio:is_closing() then
        _G.handler_drawio:close()
      end
      if code_drawio ~= 0 then
        vim.notify(
          string.format('task failed with code %d', code_drawio),
          vim.log.levels.ERROR
        )
      end
    end)
  )
end

local clipboard_commands = {
  wayland = {
    exec = 'wl-paste',
    check = 'wl-paste --list-types',
    paste = 'wl-paste --no-newline --type image/png > %s',
  },
  x11 = {
    exec = 'xclip',
    check = 'xclip -selection clipboard -o -t TARGETS',
    paste = 'xclip -selection clipboard -o -t image/png > %s',
  },
}
clipboard_commands.tty = clipboard_commands.x11

---Paste an iamge from system clipboard
local function paste_image()
  if not vim.env.XDG_SESSION_TYPE then
    return vim.notify(
      '[markdown-image] XDG_SESSION_TYPE is not set',
      vim.log.levels.ERROR
    )
  end

  local command = clipboard_commands[vim.env.XDG_SESSION_TYPE]
  if not command then
    return vim.notify(
      string.format(
        '[markdown-image] XDG_SESSION_TYPE is not supported: %s',
        vim.env.XDG_SESSION_TYPE
      ),
      vim.log.levels.ERROR
    )
  end

  if vim.fn.executable(command.exec) == 0 then
    return vim.notify(
      string.format(
        '[markdown-image] clipboard utility %s is not installed',
        command.exec
      ),
      vim.log.levels.ERROR
    )
  end

  local outputs = {}
  for output in io.popen(command.check):lines() do
    table.insert(outputs, output)
  end

  if not vim.tbl_contains(outputs, 'image/png') then
    return vim.notify(
      '[markdown-image] clipboard does not contain image',
      vim.log.levels.WARN
    )
  end

  -- Make directory for the image
  local path = vim.fs.joinpath(fn.expand('%:p:h'), 'img', fn.expand('%:t:r'))
  make_image_dir(path)

  -- Get image name
  local title = get_image_name()
  if not title then
    return
  end

  -- Save image to file
  os.execute(
    command.paste:format(
      vim.fn.fnameescape(vim.fs.joinpath(path, title .. '.png'))
    )
  )

  -- Insert link
  insert_link(path, title .. '.png')
end

api.nvim_buf_create_user_command(0, 'MarkdownInsertImage', insert_image, {
  desc = 'Insert an image on the current line',
})

api.nvim_buf_create_user_command(0, 'MarkdownPasteImage', paste_image, {
  desc = 'Paste an image from system clipboard',
})
