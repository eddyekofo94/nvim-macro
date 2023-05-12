local utils_fn = require('utils.fn')

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
---@field apply boolean|nil
---@field async boolean|nil
---@field bufnr integer|nil
---@field context table|nil
---@field cursor_position table|nil
---@field defaults table|nil
---@field diagnostics table|nil
---@field disable boolean|nil
---@field enable boolean|nil
---@field filter function|nil
---@field float boolean|table|nil
---@field format function|nil
---@field formatting_options table|nil
---@field global boolean|nil
---@field groups table|nil
---@field header string|table|nil
---@field id integer|nil
---@field local boolean|nil
---@field name string|nil
---@field namespace integer|nil
---@field new_name string|nil
---@field open boolean|nil
---@field options table|nil
---@field opts table|nil
---@field pat string|nil
---@field prefix function|string|table|nil
---@field query table|nil
---@field range table|nil
---@field severity integer|nil
---@field severity_map table|nil
---@field severity_sort boolean|nil
---@field show-status boolean|nil
---@field source boolean|string|nil
---@field str string|nil
---@field suffix function|string|table|nil
---@field timeout_ms integer|nil
---@field title string|nil
---@field toggle boolean|nil
---@field win_id integer|nil
---@field winnr integer|nil
---@field wrap boolean|nil

---Recursively build a nested table from a list of keys and a value
---@param key_parts string[] list of keys
---@param val any
---@return table
local function build_nested(key_parts, val)
  return key_parts[1]
      and { [key_parts[1]] = build_nested({ unpack(key_parts, 2) }, val) }
    or val
end

---Parse arguments passed to LSP commands
---@param fargs string[] list of arguments
---@param fn_name_alt string|nil alternative function name
---@return string|nil fn_name corresponding LSP / diagnostic function name
---@return parsed_arg_t parsed the parsed arguments
local function parse_cmdline_args(fargs, fn_name_alt)
  local fn_name = fn_name_alt or fargs[1] and table.remove(fargs, 1) or nil
  local parsed = {}
  -- First pass: parse arguments into a plain table
  for _, arg in ipairs(fargs) do
    local key, val = arg:match('^%-%-(%S+)=(.*)$')
    if not key then
      key = arg:match('^%-%-(%S+)$')
    end
    if type(val) == 'string' and vim.loop.fs_stat(vim.fn.expand(val)) then
      val = vim.fn.expand(val)
    end
    if key and val then -- '--key=value'
      local eval_valid, eval_result = pcall(vim.fn.eval, val)
      parsed[key] = not eval_valid and val or eval_result
    elseif key and not val then -- '--key'
      parsed[key] = true
    else -- 'value'
      table.insert(parsed, arg)
    end
  end
  -- Second pass: build nested tables from dot-separated keys
  for key, val in pairs(parsed) do
    if type(key) == 'string' then
      local key_parts = vim.split(key, '%.')
      parsed =
        vim.tbl_deep_extend('force', parsed, build_nested(key_parts, val))
      if #key_parts > 1 then
        parsed[key] = nil -- Remove the original dot-separated key
      end
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
        and vim.fn.resolve(vim.fn.fnamemodify(item, ':p'))
      or item
  end
end

---@class subcommand_info_t : table
---@field arg_handler function|nil
---@field opts string[]|nil
---@field fn_override function|nil
---@field completion function|nil

local subcommands = {
  lsp = {
    ---LSP subcommands
    ---@type table<string, subcommand_info_t>
    buf = {
      references = {
        ---@param args parsed_arg_t
        arg_handler = function(args)
          return args.context, args.options
        end,
        opts = { '--context', '--options.on_list' },
      },
      rename = {
        ---@param args parsed_arg_t
        arg_handler = function(args)
          return args.new_name or args[1], args.options
        end,
        opts = {
          '--new_name',
          '--options.filter',
          '--options.name',
        },
      },
      workspace_symbol = {
        ---@param args parsed_arg_t
        arg_handler = function(args)
          return args.query, args.options
        end,
        opts = { '--query', '--options.on_list' },
      },
      format = {
        arg_handler = arg_handler_range,
        opts = {
          '--formatting_options',
          '--formatting_options.tabSize',
          '--formatting_options.insertSpaces',
          '--formatting_options.trimTrailingWhitespace',
          '--formatting_options.insertFinalNewline',
          '--formatting_options.trimFinalNewlines',
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
        ---@param tbl table information passed to the command
        arg_handler = function(args, tbl)
          args.format = arg_handler_range(args, tbl).format
          return args
        end,
        opts = {
          '--format.formatting_options',
          '--format.formatting_options.tabSize',
          '--format.formatting_options.insertSpaces',
          '--format.formatting_options.trimTrailingWhitespace',
          '--format.formatting_options.insertFinalNewline',
          '--format.formatting_options.trimFinalNewlines',
          '--format.timeout_ms',
          '--format.bufnr',
          '--format.filter',
          '--format.async',
          '--format.id',
          '--format.name',
          '--format.range',
          '--local',
          '--global',
          '--enable',
          '--disable',
          '--toggle',
          '--show-status',
        },
        fn_override = function(opts)
          if opts['show-status'] then
            vim.notify(
              '[LSP] format-on-save: '
                .. (vim.b.lsp_format_on_save and 'enabled' or 'disabled')
                .. ' locally, '
                .. (vim.g.lsp_format_on_save and 'enabled' or 'disabled')
                .. ' globally,'
                .. ' local format options: '
                .. vim.inspect(vim.b.lsp_format_on_save_options)
                .. ', global format options: '
                .. vim.inspect(vim.g.lsp_format_on_save_options)
            )
            return
          end

          if not vim.g.lsp_format_on_save_initialized then
            vim.g.lsp_format_on_save_initialized = true
            vim.g.lsp_format_on_save_options = { timeout_ms = 500 }
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.bo[buf].bt == '' then
                vim.b[buf].lsp_format_on_save = false
                vim.b[buf].lsp_format_on_save_options =
                  vim.g.lsp_format_on_save_options
              end
            end
            local groupid = vim.api.nvim_create_augroup('LspFormatOnSave', {})
            vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
              group = groupid,
              callback = function(tbl)
                if vim.bo[tbl.buf].bt ~= '' then
                  return
                end
                if vim.b[tbl.buf].lsp_format_on_save == nil then
                  vim.b[tbl.buf].lsp_format_on_save = vim.g.lsp_format_on_save
                end
                if vim.b[tbl.buf].lsp_format_on_save_options == nil then
                  vim.b[tbl.buf].lsp_format_on_save_options =
                    vim.g.lsp_format_on_save_options
                end
              end,
            })
            vim.api.nvim_create_autocmd('BufWritePre', {
              group = groupid,
              callback = function(tbl)
                if vim.b[tbl.buf].lsp_format_on_save then
                  vim.lsp.buf.format(
                    vim.tbl_deep_extend(
                      'keep',
                      vim.b[tbl.buf].lsp_format_on_save_options
                        or vim.g.lsp_format_on_save_options
                        or {},
                      {
                        timeout_ms = 500,
                      }
                    )
                  )
                end
              end,
              desc = 'LSP format on save.',
            })
          end

          -- Set format-on-save flags
          if opts.toggle then
            if opts.scope_local then
              vim.b.lsp_format_on_save = not vim.b.lsp_format_on_save
            elseif opts.scope_global then
              vim.g.lsp_format_on_save = not vim.g.lsp_format_on_save
            else
              vim.b.lsp_format_on_save = not vim.b.lsp_format_on_save
              vim.g.lsp_format_on_save = vim.b.lsp_format_on_save
            end
          elseif opts.disable then
            if not opts.scope_global then
              vim.b.lsp_format_on_save = false
            end
            if not opts.scope_local then
              vim.g.lsp_format_on_save = false
            end
          else -- enable
            if not opts.scope_global then
              vim.b.lsp_format_on_save = true
            end
            if not opts.scope_local then
              vim.g.lsp_format_on_save = true
            end
          end

          -- Set format-on-save options
          if not opts.scope_global then
            vim.b.lsp_format_on_save_options = vim.tbl_deep_extend(
              'force',
              vim.b.lsp_format_on_save_options or {},
              opts.format or {}
            )
          end
          if not opts.scope_local then
            vim.g.lsp_format_on_save_options = vim.tbl_deep_extend(
              'force',
              vim.g.lsp_format_on_save_options or {},
              opts.format or {}
            )
          end

          vim.notify(
            '[LSP] format-on-save: '
              .. (vim.b.lsp_format_on_save and 'enabled' or 'disabled')
          )
        end,
      },
      code_action = {
        opts = {
          '--context.diagnostics',
          '--context.only',
          '--context.triggerKind',
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
              table.insert(
                subdirs,
                vim.fn.fnamemodify(
                  vim.fn.resolve(basedir .. '/' .. name),
                  ':p:~:.'
                )
              )
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
          return vim.tbl_map(function(path)
            local short = vim.fn.fnamemodify(path, ':p:~:.')
            return short ~= '' and short or './'
          end, vim.lsp.buf.list_workspace_folders())
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
      server_ready = {
        fn_override = function(...)
          vim.notify(vim.inspect(vim.lsp.buf.server_ready(...)))
        end,
      },
      signature_help = {},
    },
  },

  ---Diagnostic subcommands
  ---@type table<string, subcommand_info_t>
  diagnostic = {
    config = {
      ---@param args parsed_arg_t
      arg_handler = function(args)
        return args.opts, args.namespace
      end,
      opts = {
        '--opts.underline',
        '--opts.underline.severity',
        '--opts.virtual_text',
        '--opts.virtual_text.severity',
        '--opts.virtual_text.source',
        '--opts.virtual_text.spacing',
        '--opts.virtual_text.prefix',
        '--opts.virtual_text.suffix',
        '--opts.virtual_text.format',
        '--opts.signs',
        '--opts.signs.severity',
        '--opts.signs.priority',
        '--opts.float',
        '--opts.float.bufnr',
        '--opts.float.namespace',
        '--opts.float.scope',
        '--opts.float.pos',
        '--opts.float.severity_sort',
        '--opts.float.severity',
        '--opts.float.header',
        '--opts.float.source',
        '--opts.float.format',
        '--opts.float.prefix',
        '--opts.float.suffix',
        '--opts.update_in_insert',
        '--opts.severity_sort',
        '--opts.severity_sort.reverse',
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
        vim.diagnostic.show(nil, 0, vim.diagnostic.fromqflist(...))
      end,
    },
    get = {
      ---@param args parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.opts
      end,
      opts = {
        '--bufnr',
        '--opts.namespace',
        '--opts.lnum',
        '--opts.severity',
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
        '--float.bufnr',
        '--float.namespace',
        '--float.scope',
        '--float.pos',
        '--float.severity_sort',
        '--float.severity',
        '--float.header',
        '--float.source',
        '--float.format',
        '--float.prefix',
        '--float.suffix',
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
        '--float.bufnr',
        '--float.namespace',
        '--float.scope',
        '--float.pos',
        '--float.severity_sort',
        '--float.severity',
        '--float.header',
        '--float.source',
        '--float.format',
        '--float.prefix',
        '--float.suffix',
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
        '--float.bufnr',
        '--float.namespace',
        '--float.scope',
        '--float.pos',
        '--float.severity_sort',
        '--float.severity',
        '--float.header',
        '--float.source',
        '--float.format',
        '--float.prefix',
        '--float.suffix',
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
        '--float.bufnr',
        '--float.namespace',
        '--float.scope',
        '--float.pos',
        '--float.severity_sort',
        '--float.severity',
        '--float.header',
        '--float.source',
        '--float.format',
        '--float.prefix',
        '--float.suffix',
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
        '--float.bufnr',
        '--float.namespace',
        '--float.scope',
        '--float.pos',
        '--float.severity_sort',
        '--float.severity',
        '--float.header',
        '--float.source',
        '--float.format',
        '--float.prefix',
        '--float.suffix',
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
        '--float.bufnr',
        '--float.namespace',
        '--float.scope',
        '--float.pos',
        '--float.severity_sort',
        '--float.severity',
        '--float.header',
        '--float.source',
        '--float.format',
        '--float.prefix',
        '--float.suffix',
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
        return args.str,
          args.pat,
          args.groups,
          args.severity_map,
          args.defaults
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
        return args.namespace, args.bufnr, args.diagnostics, args.opts
      end,
      opts = {
        '--namespace',
        '--bufnr',
        '--diagnostics',
        '--opts.underline',
        '--opts.underline.severity',
        '--opts.virtual_text',
        '--opts.virtual_text.severity',
        '--opts.virtual_text.source',
        '--opts.virtual_text.spacing',
        '--opts.virtual_text.prefix',
        '--opts.virtual_text.suffix',
        '--opts.virtual_text.format',
        '--opts.signs',
        '--opts.signs.severity',
        '--opts.signs.priority',
        '--opts.float',
        '--opts.float.bufnr',
        '--opts.float.namespace',
        '--opts.float.scope',
        '--opts.float.pos',
        '--opts.float.severity_sort',
        '--opts.float.severity',
        '--opts.float.header',
        '--opts.float.source',
        '--opts.float.format',
        '--opts.float.prefix',
        '--opts.float.suffix',
        '--opts.update_in_insert',
        '--opts.severity_sort',
        '--opts.severity_sort.reverse',
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
        return args.namespace, args.bufnr, args.diagnostics, args.opts
      end,
      opts = {
        '--namespace',
        '--bufnr',
        '--diagnostics',
        '--opts.underline',
        '--opts.underline.severity',
        '--opts.virtual_text',
        '--opts.virtual_text.severity',
        '--opts.virtual_text.source',
        '--opts.virtual_text.spacing',
        '--opts.virtual_text.prefix',
        '--opts.virtual_text.suffix',
        '--opts.virtual_text.format',
        '--opts.signs',
        '--opts.signs.severity',
        '--opts.signs.priority',
        '--opts.float',
        '--opts.float.bufnr',
        '--opts.float.namespace',
        '--opts.float.scope',
        '--opts.float.pos',
        '--opts.float.severity_sort',
        '--opts.float.severity',
        '--opts.float.header',
        '--opts.float.source',
        '--opts.float.format',
        '--opts.float.prefix',
        '--opts.float.suffix',
        '--opts.update_in_insert',
        '--opts.severity_sort',
        '--opts.severity_sort.reverse',
      },
    },
    toqflist = {
      arg_handler = arg_handler_item,
      opts = { '--diagnostics' },
      fn_override = function(...)
        vim.fn.setqflist(vim.diagnostic.toqflist(...))
      end,
    },
  },
}

---Get meta command function
---@param subcommand_info_list subcommand_info_t[] subcommands information
---@param fn_scope table scope of corresponding functions for subcommands
---@param fn_name_alt string|nil name of the function to call given no subcommand
---@return function meta_command_fn
local function command_meta(subcommand_info_list, fn_scope, fn_name_alt)
  ---Meta command function, calls the appropriate subcommand with args
  ---@param tbl table information passed to the command
  return function(tbl)
    local fn_name, cmdline_args = parse_cmdline_args(tbl.fargs, fn_name_alt)
    local fn = subcommand_info_list[fn_name].fn_override or fn_scope[fn_name]
    local arg_handler = subcommand_info_list[fn_name].arg_handler
      or function(args)
        return args
      end
    fn(arg_handler(cmdline_args, tbl))
  end
end

---Get command completion function
---@param meta string meta command name
---@param subcommand_info_list subcommand_info_t[] subcommands information
---@return function completion_fn
local function command_complete(meta, subcommand_info_list)
  ---Command completion function
  ---@param arglead string leading portion of the argument being completed
  ---@param cmdline string entire command line
  ---@param cursorpos number cursor position in it (byte index)
  ---@return string[] completion completion results
  return function(arglead, cmdline, cursorpos)
    -- If subcommand is not specified, complete with subcommands
    if cmdline:sub(1, cursorpos):match('^%A*' .. meta .. '%s+%S*$') then
      return vim.tbl_filter(function(cmd)
        return cmd:find(arglead, 1, true) == 1
      end, vim.tbl_keys(subcommand_info_list))
    end
    -- If subcommand is specified, complete with its options or option values
    local subcommand = utils_fn.camel_to_snake(
      cmdline:match('^%s*' .. meta .. '(%w+)')
    ) or cmdline:match('^%s*' .. meta .. '%s+(%S+)')
    if not subcommand_info_list[subcommand] then
      return {}
    end
    -- Use subcommand's completion function if it exists
    if subcommand_info_list[subcommand].completion then
      return subcommand_info_list[subcommand].completion(
        arglead,
        cmdline,
        cursorpos
      )
    end
    -- Complete with option values
    if arglead:match('%-%-%S-=%S*$') then
      ---@param optvals string[] option values
      ---@return string[] completion completion results
      local function _opt_complete(optvals)
        return vim.tbl_filter(
          function(completion)
            return completion:find(arglead, 1, true) == 1
          end,
          vim.tbl_map(function(severity)
            return arglead:match('^.-=') .. severity
          end, optvals)
        )
      end
      local bool_opts = {
        'apply',
        'async',
        'disable',
        'enable',
        'float',
        'global',
        'insertSpaces',
        'local',
        'on_list',
        'reverse',
        'severity_sort',
        'show-status',
        'signs',
        'source',
        'toggle',
        'trimFinalNewlines',
        'trimTrailingWhitespace',
        'underline',
        'update_in_insert',
        'update_in_insert',
        'virtual_text',
      }
      for _, opt in ipairs(bool_opts) do
        if arglead:find(opt .. '=', 1, true) then
          return _opt_complete({ 'v:true', 'v:false' })
        end
      end
      if arglead:match('severity=%S*$') then
        return _opt_complete({ 'WARN', 'INFO', 'ERROR', 'HINT' })
      end
      if arglead:match('bufnr=%S*$') then
        return _opt_complete(vim.api.nvim_list_bufs())
      end
      return {}
    end
    -- Complete with subcommand's options
    if arglead == '' then
      return subcommand_info_list[subcommand].opts
    end
    if arglead:match('^%-%-') then
      return vim.tbl_filter(function(opt)
        return opt:find(arglead, 1, true) == 1
      end, subcommand_info_list[subcommand].opts)
    end
    return {}
  end
end

---Setup commands
---@param _ table LS client, ignored
---@param bufnr number buffer handler
---@param meta string meta command name
---@param subcommand_info_list table<string, subcommand_info_t> subcommands information
---@param fn_scope table scope of corresponding functions for subcommands
local function setup_commands(_, bufnr, meta, subcommand_info_list, fn_scope)
  -- Format: MetaCommand sub_command opts ...
  vim.api.nvim_buf_create_user_command(
    bufnr,
    meta,
    command_meta(subcommand_info_list, fn_scope),
    {
      range = true,
      nargs = '*',
      complete = command_complete(meta, subcommand_info_list),
    }
  )
  -- Format: MetaCommandSubcommand opts ...
  for subcommand, _ in pairs(subcommand_info_list) do
    vim.api.nvim_buf_create_user_command(
      bufnr,
      meta .. utils_fn.snake_to_camel(subcommand),
      command_meta(subcommand_info_list, fn_scope, subcommand, subcommand),
      {
        range = true,
        nargs = '*',
        complete = command_complete(meta, subcommand_info_list),
      }
    )
  end
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
      elseif not vim.wo.diff and vim.b._lsp_diagnostics_temp_disabled then
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
    setup_commands(client, bufnr, 'Lsp', subcommands.lsp.buf, vim.lsp.buf)
    setup_commands(
      client,
      bufnr,
      'Diagnostic',
      subcommands.diagnostic,
      vim.diagnostic
    )
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
