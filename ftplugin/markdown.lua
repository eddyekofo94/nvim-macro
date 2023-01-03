local handler_md2pdf = nil
local handler_viewer = nil

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

local function get_previewers()
  local previewers = {
    'firefox',
    'google-chrome',
    'google-chrome-beta',
    'google-chrome-dev',
    'google-chrome-stable',
    'okular',
    'zathura',
  }
  local idx = 1
  while idx <= #previewers do
    local previewer = previewers[idx]
    if os.execute('command -v ' .. previewer .. ' >/dev/null 2>&1') ~= 0 then
      table.remove(previewers, idx)
    else
      idx = idx + 1
    end
  end
  return previewers
end

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

local function complete_md_to_pdf(arg_before, cmdline, cursor_pos)
  if arg_before == '' then
    return get_md_files()
  elseif arg_before == '--' then
    return {
      '--previewer',
      '--pdf-engine',
    }
  elseif arg_before == '--previewer=' then
    return get_previewers()
  elseif arg_before == '--pdf-engine=' then
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

local function md_to_pdf(tbl)
  local args, opts = parse_args(tbl.fargs)
  local pdf_engine = opts['pdf-engine'] or 'pdflatex'
  local fname_mds = (not vim.tbl_isempty(args) and args) or { vim.fn.expand('%') }
  local fname_pdfs = {}
  for _, fname in ipairs(fname_mds) do
    local fname_pdf = fname:gsub('%.md$', '.pdf')
    table.insert(fname_pdfs, fname_pdf)
  end
  vim.cmd('write')
  handler_md2pdf = vim.loop.spawn('md2pdf',
    { args = { '--' .. pdf_engine, unpack(fname_mds) } },
    vim.schedule_wrap(function(code_md2pdf, _)
      if handler_md2pdf then
        handler_md2pdf:close()
      end
      if code_md2pdf ~= 0 then
        vim.notify(string.format('md2pdf failed with code %d',
          code_md2pdf), vim.log.levels.ERROR)
      elseif opts.previewer then
        handler_viewer = vim.loop.spawn(opts.previewer,
          { args = { unpack(fname_pdfs) } },
          vim.schedule_wrap(function(code_viewer, _)
            if handler_viewer then
              handler_viewer:close()
            end
            if code_viewer ~= 0 then
              vim.notify(string.format('previewer %s failed with code %d',
                opts.previewer, code_viewer), vim.log.levels.ERROR)
            end
          end))
      end
    end))
end

vim.api.nvim_buf_create_user_command(0, 'MarkdownToPDF', md_to_pdf, {
  nargs = '*',
  complete = complete_md_to_pdf,
  desc = 'Convert markdown to pdf'
})
