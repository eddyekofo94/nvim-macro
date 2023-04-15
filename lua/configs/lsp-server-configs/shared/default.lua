---Check if there exists an LS that supports the given method
---for the given buffer
---@param method string the method to check for
---@param bufnr number buffer handler
local function supports_method(method, bufnr)
  local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Setup LSP keymaps
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function setup_keymaps(_, bufnr)
  -- stylua: ignore start
  vim.keymap.set('n', '<Leader>ca', vim.lsp.buf.code_action,   { buffer = bufnr })
  vim.keymap.set('n', '<Leader>r',  vim.lsp.buf.rename,        { buffer = bufnr })
  vim.keymap.set('n', '<Leader>R',  vim.lsp.buf.references,    { buffer = bufnr })
  vim.keymap.set('n', '<Leader>e',  vim.diagnostic.open_float, { buffer = bufnr })
  vim.keymap.set('n', '<leader>E',  vim.diagnostic.setloclist, { buffer = bufnr })
  vim.keymap.set('n', '[e',         vim.diagnostic.goto_prev,  { buffer = bufnr })
  vim.keymap.set('n', ']e',         vim.diagnostic.goto_next,  { buffer = bufnr })
  -- stylua: ignore end
  vim.keymap.set('n', '[E', function()
    vim.diagnostic.goto_prev({
      severity = vim.diagnostic.severity.ERROR,
    })
  end, { buffer = bufnr })
  vim.keymap.set('n', ']E', function()
    vim.diagnostic.goto_next({
      severity = vim.diagnostic.severity.ERROR,
    })
  end, { buffer = bufnr })
  vim.keymap.set('n', '[W', function()
    vim.diagnostic.goto_prev({
      severity = vim.diagnostic.severity.WARN,
    })
  end, { buffer = bufnr })
  vim.keymap.set('n', ']W', function()
    vim.diagnostic.goto_next({
      severity = vim.diagnostic.severity.WARN,
    })
  end, { buffer = bufnr })
  vim.keymap.set('n', 'gd', function()
    if supports_method('textDocument/definition', bufnr) then
      vim.lsp.buf.definition()
    else
      vim.api.nvim_feedkeys('gd', 'in', false)
    end
  end, { buffer = bufnr })
  vim.keymap.set('n', 'gD', function()
    if supports_method('textDocument/typeDefinition', bufnr) then
      vim.lsp.buf.type_definition()
    else
      vim.api.nvim_feedkeys('gD', 'in', false)
    end
  end, { buffer = bufnr })
  vim.keymap.set('n', 'K', function()
    if supports_method('textDocument/hover', bufnr) then
      vim.lsp.buf.hover()
    else
      vim.api.nvim_feedkeys('K', 'in', false)
    end
  end, { buffer = bufnr })
end

---@class parsed_arg_t : table
---@field context table|nil
---@field options table|nil
---@field on_list boolean|nil
---@field new_name string|nil
---@field query table|nil
---@field formatting_options table|nil
---@field timeout_ms integer|nil
---@field bufnr integer|nil
---@field filter function|nil
---@field async boolean|nil
---@field id integer|nil
---@field name string|nil
---@field range table|nil
---@field underline boolean|table|nil
---@field underline.severity integer|nil
---@field virtual_text boolean|table|nil
---@field virtual_text.severity integer|nil
---@field virtual_text.source boolean|string|nil
---@field virtual_text.spacing integer|nil
---@field virtual_text.prefix string|nil
---@field virtual_text.suffix string|function|nil
---@field virtual_text.format function|nil
---@field signs boolean|table|nil
---@field signs.severity integer|nil
---@field signs.priority integer|nil
---@field float table|nil
---@field update_in_insert boolean|nil
---@field severity_sort boolean|nil
---@field severity_sort.reverse boolean|nil
---@field namespace integer|nil
---@field lnum integer|nil
---@field severity integer|nil
---@field win_id integer|nil
---@field str string|nil
---@field pat string|nil
---@field groups table|nil
---@field severity_map table|nil
---@field defaults table|nil
---@field diagnostics table|nil
---@field local boolean|nil
---@field enable boolean|nil
---@field disable boolean|nil
---@field toggle boolean|nil
---@field show boolean|nil
---@field only table|nil
---@field triggerKind number|nil
---@field apply boolean|nil

---Parse arguments passed to LSP commands
---@param fargs string[] list of arguments
---@return string fn_name corresponding LSP / diagnostic function name
---@return parsed_arg_t parsed the parsed arguments
local function parse_cmdline_args(fargs)
  local fn_name = table.remove(fargs, 1)
  local parsed = {}
  for _, arg in ipairs(fargs) do
    local key, val = arg:match('^%-%-(%S+)=(%S+)$')
    if not key then
      key = arg:match('^%-%-(%S+)$')
    end
    if type(val) == 'string' then
      val = vim.fn.expand(val)
    end
    if key and val then -- '--key=value'
      local eval_valid, eval_result = pcall(vim.fn.eval, val)
      parsed[key] = eval_valid and eval_result or val
    elseif key and not val then -- '--key'
      parsed[key] = true
    else -- 'value'
      table.insert(parsed, arg)
    end
  end
  return fn_name, parsed
end

---LSP command argument handler for functions that receive a range
---@param args parsed_arg_t
---@param tbl table information passed to the command
---@return table args
local function arg_handler_range(args, tbl)
  args.range = args.range
    or tbl.range > 0 and {
      ['start'] = { tbl.line1, 0 },
      ['end'] = { tbl.line2, 999 },
    }
    or nil
  return args
end

---Extract the first item from a table, expand it to absolute path if possible
---@param args parsed_arg_t
---@return any
local function arg_handler_item(args)
  for _, item in pairs(args) do
    return type(item) == 'string'
        and vim.loop.fs_stat(vim.fn.fnamemodify(item, ':p'))
        and vim.fn.fnamemodify(item, ':p')
      or item
  end
end

---@class subcommand_info_t : table
---@field arg_handler function|nil
---@field opts string[]|nil
---@field fn_override function|nil
---@field completion function|nil

---LSP subcommands
---@type table<string, subcommand_info_t>
local lsp_subcommands = {
  references = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.context, { on_list = args.on_list }
    end,
    opts = { '--context', '--on_list' },
  },
  rename = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.new_name, { filter = args.filter, name = args.name }
    end,
    opts = {
      '--new_name',
      '--filter',
      '--name',
    },
  },
  workspace_symbol = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.query, { on_list = args.on_list }
    end,
    opts = { '--query', '--on_list' },
  },
  format = {
    arg_handler = arg_handler_range,
    opts = {
      '--formatting_options',
      '--timeout_ms',
      '--bufnr',
      '--filter',
      '--async',
      '--id',
      '--name',
      '--range',
    },
  },
  format_on_save = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args['local'],
        args.enable,
        args.disable,
        args.toggle,
        args.show,
        {
          formatting_options = args.formatting_options,
          timeout_ms = args.timeout_ms,
          bufnr = args.bufnr,
          filter = args.filter,
          async = args.async,
          id = args.id,
          name = args.name,
          range = args.range,
        }
    end,
    opts = {
      '--formatting_options',
      '--timeout_ms',
      '--bufnr',
      '--filter',
      '--async',
      '--id',
      '--name',
      '--range',
      '--local',
      '--enable',
      '--disable',
      '--toggle',
      '--show',
    },
    fn_override = function(scope_local, _, disable, toggle, show, fmt_opts)
      if show then
        vim.notify(
          '[LSP] format-on-save: '
            .. (vim.b.lsp_format_on_save and 'enabled' or 'disabled')
            .. ' locally, '
            .. (vim.g.lsp_format_on_save and 'enabled' or 'disabled')
            .. ' globally'
        )
        return
      end

      if not vim.g.lsp_format_on_save_initialized then
        vim.g.lsp_format_on_save_initialized = true
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].bt == '' then
            vim.b[buf].lsp_format_on_save = false
          end
        end
        local groupid = vim.api.nvim_create_augroup('LspFormatOnSave', {})
        vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
          group = groupid,
          callback = function(tbl)
            if
              vim.bo[tbl.buf].bt == ''
              and vim.b[tbl.buf].lsp_format_on_save == nil
            then
              vim.b[tbl.buf].lsp_format_on_save = vim.g.lsp_format_on_save
            end
          end,
        })
        vim.api.nvim_create_autocmd('BufWritePre', {
          group = groupid,
          callback = function()
            if vim.b.lsp_format_on_save then
              vim.lsp.buf.format(vim.tbl_deep_extend('force', fmt_opts or {}, {
                timeout_ms = 500,
              }))
            end
          end,
          desc = 'LSP format on save.',
        })
      end

      if vim.b.lsp_format_on_save == nil then
        vim.b.lsp_format_on_save = vim.g.lsp_format_on_save
      end
      if toggle then
        vim.b.lsp_format_on_save = not vim.b.lsp_format_on_save
        vim.g.lsp_format_on_save = vim.b.lsp_format_on_save
      elseif disable then
        vim.b.lsp_format_on_save = false
        if not scope_local then
          vim.g.lsp_format_on_save = false
        end
      else -- enable
        vim.b.lsp_format_on_save = true
        if not scope_local then
          vim.g.lsp_format_on_save = true
        end
      end
      vim.notify(
        '[LSP] format-on-save: '
          .. (vim.b.lsp_format_on_save and 'enabled' or 'disabled')
      )
    end,
  },
  code_action = {
    ---@param args parsed_arg_t
    arg_handler = function(args, tbl)
      local context = {
        diagnostics = args.diagnostics,
        only = args.only,
        triggerKind = args.triggerKind,
      }
      for opt, optval in pairs(context) do
        if type(optval) == 'table' and vim.tbl_isempty(optval) then
          context[opt] = nil
        end
      end
      if vim.tbl_isempty(context) then
        context = nil
      end
      return {
        context = context,
        filter = args.filter,
        apply = args.apply,
        range = args.range or arg_handler_range({}, tbl).range,
      }
    end,
    opts = {
      '--diagnostics',
      '--only',
      '--triggerKind',
      '--filter',
      '--apply',
      '--range',
    },
  },
  add_workspace_folder = {
    arg_handler = arg_handler_item,
    completion = function(arglead, _, _)
      local basedir = arglead == '' and vim.fn.getcwd() or arglead
      local incomplete = nil ---@type string|nil
      if not vim.loop.fs_stat(basedir) then
        basedir = vim.fn.fnamemodify(basedir, ':h')
        incomplete = vim.fn.fnamemodify(arglead, ':t')
      end
      local subdirs = {}
      for name, type in vim.fs.dir(basedir) do
        if type == 'directory' and name ~= '.' and name ~= '..' then
          table.insert(subdirs, vim.fn.resolve(basedir .. '/' .. name))
        end
      end
      if incomplete then
        return vim.tbl_filter(function(s)
          return s:find(incomplete, 1, true)
        end, subdirs)
      end
      return subdirs
    end,
  },
  remove_workspace_folder = {
    arg_handler = arg_handler_item,
    completion = function(_, _, _)
      return vim.lsp.buf.list_workspace_folders()
    end,
  },
  execute_command = { arg_handler = arg_handler_item },
  type_definition = { opts = { '--reuse_win', '--on_list' } },
  declaration = { opts = { '--reuse_win', '--on_list' } },
  definition = { opts = { '--reuse_win', '--on_list' } },
  document_symbol = { opts = { '--on_list' } },
  implementation = { opts = { '--on_list' } },
  hover = {},
  document_highlight = {},
  clear_references = {},
  list_workspace_folders = {
    fn_override = function()
      vim.notify(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end,
  },
  incoming_calls = {},
  outgoing_calls = {},
  server_ready = {},
  signature_help = {},
}

---LSP command completion function
---@param arglead string leading portion of the argument being completed
---@param cmdline string entire command line
---@param cursorpos number cursor position in it (byte index)
---@return string[] completion
local function lsp_command_complete(arglead, cmdline, cursorpos)
  -- If subcommand is not specified, complete with subcommands
  if cmdline:sub(1, cursorpos):match('^%s*Lsp%s+%S*$') then
    return vim.tbl_filter(function(cmd)
      return cmd:find(arglead, 1, true) == 1
    end, vim.tbl_keys(lsp_subcommands))
  end
  -- If subcommand is specified, complete with its options
  local subcommand = cmdline:match('^%s*Lsp%s+(%S+)')
  if not lsp_subcommands[subcommand] then
    return {}
  end
  -- Use subcommand's completion function if it exists
  if lsp_subcommands[subcommand].completion then
    return lsp_subcommands[subcommand].completion(arglead, cmdline, cursorpos)
  end
  -- Complete with subcommand's options
  if arglead == '' then
    return lsp_subcommands[subcommand].opts
  end
  if arglead:match('^%-%-') then
    return vim.tbl_filter(function(opt)
      return opt:find(arglead, 1, true) == 1
    end, lsp_subcommands[subcommand].opts)
  end
  return {}
end

---Parse command arguments and call corresponding LSP function
---@param tbl table information passed to the command
local function lsp_do_command(tbl)
  local fn_name, cmdline_args = parse_cmdline_args(tbl.fargs)
  local fn = lsp_subcommands[fn_name].fn_override or vim.lsp.buf[fn_name]
  local arg_handler = lsp_subcommands[fn_name].arg_handler
    or function(args)
      return args
    end
  fn(arg_handler(cmdline_args, tbl))
end

---Setup LSP commands
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function setup_commands_lsp(_, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, 'Lsp', lsp_do_command, {
    range = true,
    nargs = '*',
    complete = lsp_command_complete,
  })
end

-- Maps severity name to number
-- stylua: ignore start
local diagnostic_severity_map = {
  OFF   = nil,  -- invalid level for diagnostic
  WARN  = 2,
  TRACE = nil,  -- invalid level for diagnostic
  INFO  = 4,
  ERROR = 5,
  DEBUG = nil,  -- invalid level for diagnostic
}
-- stylua: ignore end

---Argument handler for diagnostic config subcommand
---@param args parsed_arg_t
---@return table|nil display_opts param 'opts' passed to vim.diagnostic.config
---@return number|nil namespace param 'namespace' passed to vim.diagnostic.config
local function arg_handler_diagnostic_config(args)
  local display_opts = {
    underline = args.underline or {
      severity = diagnostic_severity_map[args['underline.severity']]
        or args['underline-severity'],
    },
    virtual_text = args.virtual_text
      or {
        severity = diagnostic_severity_map[args['virtual_text.severity']]
          or args['virtual_text.severity'],
        source = args['virtual_text.source'],
        spacing = args['virtual_text.spacing'],
        prefix = args['virtual_text.prefix'],
        suffix = args['virtual_text.suffix'],
        format = args['virtual_text.format'],
      },
    signs = args.signs or {
      severity = diagnostic_severity_map[args['signs.severity']]
        or args['signs.severity'],
      priority = args['signs.priority'],
    },
    float = args.float,
    update_in_insert = args.update_in_insert,
    severity_sort = args.severity_sort or {
      reverse = args['severity_sort.reverse'],
    },
  }
  for opt, optval in pairs(display_opts) do
    if type(optval) == 'table' and vim.tbl_isempty(optval) then
      display_opts[opt] = nil
    end
  end
  return not vim.tbl_isempty(display_opts) and display_opts or nil,
    args.namespace
end

---Diagnostic subcommands
---@type table<string, subcommand_info_t>
local diagnostic_subcommands = {
  config = {
    arg_handler = arg_handler_diagnostic_config,
    opts = {
      '--underline',
      '--underline.severity',
      '--virtual_text',
      '--virtual_text.severity',
      '--virtual_text.source',
      '--virtual_text.spacing',
      '--virtual_text.prefix',
      '--virtual_text.suffix',
      '--virtual_text.format',
      '--signs',
      '--signs.severity',
      '--signs.priority',
      '--float',
      '--update_in_insert',
      '--severity_sort',
      '--severity_sort.reverse',
      '--namespace',
    },
  },
  disable = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.bufnr, args.namespace
    end,
    opts = { '--bufnr', '--namespace' },
  },
  enable = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.bufnr, args.namespace
    end,
    opts = { '--bufnr', '--namespace' },
  },
  fromqflist = {
    arg_handler = arg_handler_item,
    opts = { '--list' },
    fn_override = function(...)
      vim.notify(vim.diagnostic.setqflist(...))
    end,
  },
  get = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.bufnr,
        {
          namespace = args.namespace,
          lnum = args.lnum,
          severity = diagnostic_severity_map[args.severity] or args.severity,
        }
    end,
    opts = {
      '--bufnr',
      '--namespace',
      '--lnum',
      '--severity',
    },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.get(...)))
    end,
  },
  get_namespace = {
    arg_handler = arg_handler_item,
    opts = { '--namespace' },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.get_namespace(...)))
    end,
  },
  get_namespaces = {
    fn_override = function()
      vim.notify(vim.inspect(vim.diagnostic.get_namespaces()))
    end,
  },
  get_next = {
    opts = {
      '--namespace',
      '--cursor_position',
      '--wrap',
      '--severity',
      '--float',
      '--win_id',
    },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.get_next(...)))
    end,
  },
  get_next_pos = {
    opts = {
      '--namespace',
      '--cursor_position',
      '--wrap',
      '--severity',
      '--float',
      '--win_id',
    },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.get_next_pos(...)))
    end,
  },
  get_prev = {
    opts = {
      '--namespace',
      '--cursor_position',
      '--wrap',
      '--severity',
      '--float',
      '--win_id',
    },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.get_prev(...)))
    end,
  },
  get_prev_pos = {
    opts = {
      '--namespace',
      '--cursor_position',
      '--wrap',
      '--severity',
      '--float',
      '--win_id',
    },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.get_prev_pos(...)))
    end,
  },
  goto_next = {
    opts = {
      '--namespace',
      '--cursor_position',
      '--wrap',
      '--severity',
      '--float',
      '--win_id',
    },
  },
  goto_prev = {
    opts = {
      '--namespace',
      '--cursor_position',
      '--wrap',
      '--severity',
      '--float',
      '--win_id',
    },
  },
  hide = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.namespace, args.bufnr
    end,
    opts = { '--namespace', '--bufnr' },
  },
  is_disabled = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.bufnr, args.namespace
    end,
    opts = { '--bufnr', '--namespace' },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.is_disabled(...)))
    end,
  },
  match = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.str, args.pat, args.groups, args.severity_map, args.defaults
    end,
    opts = {
      '--str',
      '--pat',
      '--groups',
      '--severity_map',
      '--defaults',
    },
    fn_override = function(...)
      vim.notify(vim.inspect(vim.diagnostic.match(...)))
    end,
  },
  open_float = {
    opts = {
      '--bufnr',
      '--namespace',
      '--scope',
      '--pos',
      '--severity_sort',
      '--severity',
      '--header',
      '--source',
      '--format',
      '--prefix',
      '--suffix',
    },
  },
  reset = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      return args.namespace, args.bufnr
    end,
    opts = { '--namespace', '--bufnr' },
  },
  set = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      local display_opts, _ = arg_handler_diagnostic_config(args)
      return args.namespace, args.bufnr, args.diagnostics, display_opts
    end,
    opts = {
      '--namespace',
      '--bufnr',
      '--diagnostics',
      '--underline',
      '--underline.severity',
      '--virtual_text',
      '--virtual_text.severity',
      '--virtual_text.source',
      '--virtual_text.spacing',
      '--virtual_text.prefix',
      '--virtual_text.suffix',
      '--virtual_text.format',
      '--signs',
      '--signs.severity',
      '--signs.priority',
      '--float',
      '--update_in_insert',
      '--severity_sort',
      '--severity_sort.reverse',
    },
  },
  setloclist = {
    opts = {
      '--namespace',
      '--winnr',
      '--open',
      '--title',
      '--severity',
    },
  },
  setqflist = {
    opts = {
      '--namespace',
      '--open',
      '--title',
      '--severity',
    },
  },
  show = {
    ---@param args parsed_arg_t
    arg_handler = function(args)
      local display_opts, _ = arg_handler_diagnostic_config(args)
      return args.namespace, args.bufnr, args.diagnostics, display_opts
    end,
    opts = {
      '--namespace',
      '--bufnr',
      '--diagnostics',
      '--underline',
      '--underline.severity',
      '--virtual_text',
      '--virtual_text.severity',
      '--virtual_text.source',
      '--virtual_text.spacing',
      '--virtual_text.prefix',
      '--virtual_text.suffix',
      '--virtual_text.format',
      '--signs',
      '--signs.severity',
      '--signs.priority',
      '--float',
      '--update_in_insert',
      '--severity_sort',
      '--severity_sort.reverse',
    },
  },
  toqflist = {
    arg_handler = arg_handler_item,
    opts = { '--diagnostics' },
    fn_override = function(...)
      vim.fn.setqflist(vim.diagnostic.toqflist(...))
    end,
  },
}

---Diagnostic command completion function
---@param arglead string leading portion of the argument being completed
---@param cmdline string entire command line
---@param cursorpos number cursor position in it (byte index)
---@return string[] completion
local function diagnostic_command_complete(arglead, cmdline, cursorpos)
  -- If subcommand is not specified, complete with subcommands
  if cmdline:sub(1, cursorpos):match('^%s*Diagnostic%s+%S*$') then
    return vim.tbl_filter(function(cmd)
      return cmd:find(arglead, 1, true) == 1
    end, vim.tbl_keys(diagnostic_subcommands))
  end
  -- If subcommand is specified, complete with its options or option values
  local subcommand = cmdline:match('^%s*Diagnostic%s+(%S+)')
  if not diagnostic_subcommands[subcommand] then
    return {}
  end
  -- Use subcommand's completion function if it exists
  if diagnostic_subcommands[subcommand].completion then
    return diagnostic_subcommands[subcommand].completion(
      arglead,
      cmdline,
      cursorpos
    )
  end
  -- Complete with option values
  if arglead:match('=%S*$') then
    if arglead:match('severity=%S*$') then
      return vim.tbl_filter(
        function(completion)
          return completion:match(arglead)
        end,
        vim.tbl_map(function(severity)
          return '--severity=' .. severity
        end, vim.tbl_keys(diagnostic_severity_map))
      )
    end
    return {}
  end
  -- Complete with options
  if arglead == '' then
    return diagnostic_subcommands[subcommand].opts
  end
  if arglead:match('^%-%-') then
    return vim.tbl_filter(function(opt)
      return opt:find(arglead, 1, true) == 1
    end, diagnostic_subcommands[subcommand].opts)
  end
  return {}
end

---Parse command arguments and call corresponding diagnostic function
---@param tbl table information passed to the command
local function diagnostic_do_command(tbl)
  local fn_name, cmdline_args = parse_cmdline_args(tbl.fargs)
  local fn = diagnostic_subcommands[fn_name].fn_override
    or vim.diagnostic[fn_name]
  local arg_handler = diagnostic_subcommands[fn_name].arg_handler
    or function(args)
      return args
    end
  fn(arg_handler(cmdline_args, tbl))
end

---Setup diagnostic commands
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function setup_commands_diagnostic(_, bufnr)
  vim.api.nvim_buf_create_user_command(
    bufnr,
    'Diagnostic',
    diagnostic_do_command,
    {
      range = true,
      nargs = '*',
      complete = diagnostic_command_complete,
    }
  )
end

---Automatically enable / disable diagnostics on mode change
---@param _ table LS client, ignored
---@param bufnr number buffer handler
local function setup_diagnostics_on_mode_change(_, bufnr)
  local augroup_diagnostic = 'LspDiagnostic' .. bufnr
  vim.api.nvim_create_augroup(augroup_diagnostic, { clear = true })
  vim.api.nvim_create_autocmd('ModeChanged', {
    buffer = bufnr,
    group = augroup_diagnostic,
    callback = function(tbl)
      if vim.fn.match(tbl.match, '.*:[iRsS\x13].*') ~= -1 then
        vim.diagnostic.disable(bufnr)
        vim.b._lsp_diagnostics_temp_disabled = true
      elseif vim.b._lsp_diagnostics_temp_disabled then
        vim.diagnostic.enable(bufnr)
        vim.b._lsp_diagnostics_temp_disabled = nil
      end
    end,
    desc = 'LSP diagnostics on mode change.',
  })
end

---Set up keymaps and commands
---@param client table LS client, ignored
---@param bufnr number buffer handler
local function on_attach(client, bufnr)
  if not vim.b[bufnr].lsp_attached then
    vim.b[bufnr].lsp_attached = true
    setup_keymaps(client, bufnr)
    setup_commands_lsp(client, bufnr)
    setup_commands_diagnostic(client, bufnr)
    setup_diagnostics_on_mode_change(client, bufnr)
  end
end

-- Merge default capabilities with extra capabilities provided by cmp-nvim-lsp
local capabilities =
  vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        dynamicRegistration = false,
        completionItem = {
          snippetSupport = true,
          commitCharactersSupport = true,
          deprecatedSupport = true,
          preselectSupport = true,
          tagSupport = {
            valueSet = {
              1, -- Deprecated
            },
          },
          insertReplaceSupport = true,
          resolveSupport = {
            properties = {
              'documentation',
              'detail',
              'additionalTextEdits',
            },
          },
          insertTextModeSupport = {
            valueSet = {
              1, -- asIs
              2, -- adjustIndentation
            },
          },
          labelDetailsSupport = true,
        },
        contextSupport = true,
        insertTextMode = 1,
        completionList = {
          itemDefaults = {
            'commitCharacters',
            'editRange',
            'insertTextFormat',
            'insertTextMode',
            'data',
          },
        },
      },
    },
  })

local default_config = {
  on_attach = on_attach,
  capabilities = capabilities,
}

return default_config
