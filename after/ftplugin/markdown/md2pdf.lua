---Parse command line arguments into args (files) and options
---@param fargs string[] <f-args>
---@return string[] args
---@return table<string, string> opts
local function parse_args(fargs)
  local args = {}
  local opts = {}
  for _, arg in ipairs(fargs) do
    if arg:match('^%-%-') then
      local key, val = arg:match('^%-%-(%S+)=(.*)')
      opts[key] = val
    else
      table.insert(args, vim.fn.expand(arg))
    end
  end
  return args, opts
end

---Get list of available viewers
---@return string[]
local function get_viewers()
  local viewers = {
    'firefox',
    'google-chrome',
    'google-chrome-beta',
    'google-chrome-dev',
    'google-chrome-stable',
    'okular',
    'zathura',
  }
  local idx = 1
  while idx <= #viewers do
    local viewer = viewers[idx]
    if vim.fn.executable(viewer) == 0 then
      table.remove(viewers, idx)
    else
      idx = idx + 1
    end
  end
  return viewers
end

---Get list of markdown files currently opened in buffers
---@return string[]
local function get_md_files()
  local bufnames = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':~:.')
    if bufname:match('.md$') then
      table.insert(bufnames, bufname)
    end
  end
  return bufnames
end

---Command completion function
---@param arglead string leading portion of the argument being completed
---@return string[] completion completion results
local function complete_md_to_pdf(arglead, _, _)
  local md_files = get_md_files()
  local opts = {
    '--viewer',
    '--pdf-engine',
  }
  if arglead == '' then
    local completions = md_files
    for _, opt in ipairs(opts) do
      table.insert(completions, opt)
    end
    return completions
  elseif arglead == '--viewer=' then
    return get_viewers()
  elseif arglead == '--pdf-engine=' then
    return {
      'latexmk',
      'lualatex',
      'pdflatex',
      'wkhtmltopdf',
      'xelatex',
    }
  end
  return {}
end

---Close a handler if it is not nil and not closing
---@param handler uv.uv_process_t?
local function close_handler(handler)
  if handler and not handler:is_closing() then
    handler:close()
  end
end

---Spawn a viewer
---@param files string[] files to be viewed
---@param opts table<string, string> options
local function spawn_viewer(files, opts)
  close_handler(_G.handler_viewer)
  _G.handler_viewer = vim.uv.spawn(
    opts.viewer,
    ---@diagnostic disable-next-line: missing-fields
    { args = files },
    vim.schedule_wrap(function(code_viewer, _)
      close_handler(_G.handler_viewer)
      if code_viewer ~= 0 then
        vim.notify(
          string.format(
            'viewer %s failed with code %d',
            opts.viewer,
            code_viewer
          ),
          vim.log.levels.ERROR
        )
      end
    end)
  )
end

---Spawn md2pdf shell script
---@param args string[] markdown files to be converted
---@param opts table<string, string> options
local function spawn_pandoc(args, opts)
  close_handler(_G.handler_md2pdf)
  _G.handler_md2pdf = vim.uv.spawn(
    'md2pdf',
    ---@diagnostic disable-next-line: missing-fields
    { args = { '--' .. opts['pdf-engine'], unpack(args) } },
    vim.schedule_wrap(function(code_md2pdf, _)
      close_handler(_G.handler_md2pdf)
      if code_md2pdf ~= 0 then
        vim.notify(
          string.format('md2pdf failed with code %d', code_md2pdf),
          vim.log.levels.ERROR
        )
      elseif opts.viewer then
        local fname_pdfs = {}
        for _, fname in ipairs(args) do
          local fname_pdf = fname:gsub('%.md$', '.pdf')
          table.insert(fname_pdfs, fname_pdf)
        end
        spawn_viewer(fname_pdfs, opts)
      end
    end)
  )
end

---Convert markdown to pdf
---@param tbl table information passed to the command
local function md_to_pdf(tbl)
  local args, opts = parse_args(tbl.fargs)
  args = vim.tbl_deep_extend('force', { vim.fn.expand('%') }, args)
  opts = vim.tbl_deep_extend('force', { ['pdf-engine'] = 'pdflatex' }, opts)
  vim.cmd.update({ mods = { emsg_silent = true } })
  spawn_pandoc(args, opts)
end

vim.api.nvim_buf_create_user_command(0, 'MarkdownToPDF', md_to_pdf, {
  nargs = '*',
  complete = complete_md_to_pdf,
  desc = 'Convert markdown to pdf',
})
