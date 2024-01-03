local utils = require("utils")
local keymap_utils = require("utils.keymap")
local keymap = keymap_utils.set_keymap

---Check if there exists an LS that supports the given method
---for the given buffer
---@param method string the method to check for
---@param bufnr number buffer handler
local function supports_method(method, bufnr)
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  for _, client in ipairs(clients) do
    if client.supports_method(method) then
      return true
    end
  end
  return false
end

---Setup LSP keymaps
---@return nil
local function setup_keymaps()
  ---@param direction 'prev'|'next'
  ---@param level 'ERROR'|'WARN'|'INFO'|'HINT'
  ---@return function
  local function goto_diagnostic(direction, level)
    return function()
      vim.diagnostic["goto_" .. direction]({
        severity = vim.diagnostic.severity[level],
      })
    end
  end
  ---@param method string LSP method
  ---@param fn_name string function name, used to index vim.lsp.buf
  ---@param fallback string fallback keymap
  ---@return function
  local function if_supports_lsp_method(method, fn_name, fallback)
    return function()
      return supports_method(method, 0)
          and string.format(
            '<Cmd>lua vim.lsp.buf["%s"]()<CR>',
            vim.fn.escape(fn_name, '"\\')
          )
        or fallback
    end
  end
  -- stylua: ignore start
  keymap({ 'n' }, 'gq;', vim.lsp.buf.format, "format")
  keymap({ 'n', 'x' }, '<Leader>ca', vim.lsp.buf.code_action, "code action")
  keymap({ 'n', 'x' }, '<Leader>r', vim.lsp.buf.rename, "rename")
  keymap({ 'n', 'x' }, '<Leader>e', vim.diagnostic.open_float)
  keymap({ 'n', 'x' }, '<leader>E', vim.diagnostic.setloclist)
  keymap({ 'n', 'x' }, '[e', utils.keymap.count_wrap(vim.diagnostic.goto_prev))
  keymap({ 'n', 'x' }, ']e', utils.keymap.count_wrap(vim.diagnostic.goto_next))
  keymap({ 'n', 'x' }, '[E', utils.keymap.count_wrap(goto_diagnostic('prev', 'ERROR')))
  keymap({ 'n', 'x' }, ']E', utils.keymap.count_wrap(goto_diagnostic('next', 'ERROR')))
  keymap({ 'n', 'x' }, '[W', utils.keymap.count_wrap(goto_diagnostic('prev', 'WARN')))
  keymap({ 'n', 'x' }, ']W', utils.keymap.count_wrap(goto_diagnostic('next', 'WARN')))
  keymap({ 'n', 'x' }, '[I', utils.keymap.count_wrap(goto_diagnostic('prev', 'INFO')))
  keymap({ 'n', 'x' }, ']I', utils.keymap.count_wrap(goto_diagnostic('next', 'INFO')))
  keymap({ 'n', 'x' }, '[H', utils.keymap.count_wrap(goto_diagnostic('prev', 'HINT')))
  keymap({ 'n', 'x' }, ']H', utils.keymap.count_wrap(goto_diagnostic('next', 'HINT')))
  keymap({ 'n', 'x' }, 'g.', vim.lsp.buf.references, "references")
  keymap({ 'n', 'x' }, 'gd', if_supports_lsp_method('textDocument/definition', 'definition', 'gd'), { expr = true })
  keymap({ 'n', 'x' }, 'gD', if_supports_lsp_method('textDocument/typeDefinition', 'type_definition', 'gD'), { expr = true })
  -- stylua: ignore end
end

---Setup LSP handlers overrides
---@return nil
local function setup_lsp_overrides()
  -- Show notification if no references, definition, declaration,
  -- implementation or type definition is found
  local handlers = {
    ["textDocument/references"] = vim.lsp.handlers["textDocument/references"],
    ["textDocument/definition"] = vim.lsp.handlers["textDocument/definition"],
    ["textDocument/declaration"] = vim.lsp.handlers["textDocument/declaration"],
    ["textDocument/implementation"] = vim.lsp.handlers["textDocument/implementation"],
    ["textDocument/typeDefinition"] = vim.lsp.handlers["textDocument/typeDefinition"],
  }
  for method, handler in pairs(handlers) do
    vim.lsp.handlers[method] = function(err, result, ctx, cfg)
      if not result or type(result) == "table" and vim.tbl_isempty(result) then
        vim.notify(
          "[LSP] no " .. method:match("/(%w*)$") .. " found",
          vim.log.levels.WARN
        )
      end
      handler(err, result, ctx, cfg)
    end
  end

  -- Configure hovering window style
  local opts_override_floating_preview = {
    border = "solid",
    max_width = math.max(80, math.ceil(vim.go.columns * 0.75)),
    max_height = math.max(20, math.ceil(vim.go.lines * 0.4)),
    close_events = {
      "CursorMoved",
      "CursorMovedI",
      "WinScrolled",
    },
  }
  vim.api.nvim_create_autocmd("VimResized", {
    desc = "Update LSP floating window maximum size on VimResized.",
    group = vim.api.nvim_create_augroup("LspUpdateFloatingWinMaxSize", {}),
    callback = function()
      opts_override_floating_preview.max_width =
        math.max(80, math.ceil(vim.go.columns * 0.75))
      opts_override_floating_preview.max_height =
        math.max(20, math.ceil(vim.go.lines * 0.4))
    end,
  })
  -- Hijack LSP floating window function to use custom options
  local _open_floating_preview = vim.lsp.util.open_floating_preview
  ---@param contents table of lines to show in window
  ---@param syntax string of syntax to set for opened buffer
  ---@param opts table with optional fields (additional keys are passed on to |nvim_open_win()|)
  ---@returns bufnr,winnr buffer and window number of the newly created floating preview window
  ---@diagnostic disable-next-line: duplicate-set-field
  function vim.lsp.util.open_floating_preview(contents, syntax, opts)
    local source_ft = vim.bo[vim.api.nvim_get_current_buf()].ft
    opts = vim.tbl_deep_extend("force", opts, opts_override_floating_preview)
    -- If source filetype if markdown, use custom mkd syntax instead of
    -- markdown syntax to avoid using treesitter highlight and get math
    -- concealing provided by vimtex in the floating window
    if source_ft == "markdown" then
      syntax = "mkd"
      opts.wrap = false
    end
    local floating_bufnr, floating_winnr =
      _open_floating_preview(contents, syntax, opts)
    vim.wo[floating_winnr].concealcursor = "nc"
    return floating_bufnr, floating_winnr
  end
end

---@class lsp_command_parsed_arg_t : parsed_arg_t
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

---Parse arguments passed to LSP commands
---@param fargs string[] list of arguments
---@param fn_name_alt string|nil alternative function name
---@return string|nil fn_name corresponding LSP / diagnostic function name
---@return lsp_command_parsed_arg_t parsed the parsed arguments
local function parse_cmdline_args(fargs, fn_name_alt)
  local fn_name = fn_name_alt or fargs[1] and table.remove(fargs, 1) or nil
  local parsed = utils.command.parse_cmdline_args(fargs)
  return fn_name, parsed
end

---LSP command argument handler for functions that receive a range
---@param args lsp_command_parsed_arg_t
---@param tbl table information passed to the command
---@return table args
local function arg_handler_range(args, tbl)
  args.range = args.range
    or tbl.range > 0 and {
      ["start"] = { tbl.line1, 0 },
      ["end"] = { tbl.line2, 999 },
    }
    or nil
  return args
end

---Extract the first item from a table, expand it to absolute path if possible
---@param args lsp_command_parsed_arg_t
---@return any
local function arg_handler_item(args)
  for _, item in pairs(args) do
    return type(item) == "string" and vim.uv.fs_realpath(item) or item
  end
end

---@type table<string, string[]|fun(): any[]>
local optvals = {
  bool = { "v:true", "v:false" },
  severity = { "WARN", "INFO", "ERROR", "HINT" },
  bufs = function()
    return vim.api.nvim_list_bufs()
  end,
}

---@class subcommand_info_t : table
---@field arg_handler function|nil
---@field params table|nil
---@field opts table|nil
---@field fn_override function|nil
---@field completion function|nil

local subcommands = {
  lsp = {
    ---LSP subcommands
    ---@type table<string, subcommand_info_t>
    buf = {
      references = {
        ---@param args lsp_command_parsed_arg_t
        arg_handler = function(args)
          return args.context, args.options
        end,
        opts = { "context", "options.on_list" },
      },
      rename = {
        ---@param args lsp_command_parsed_arg_t
        arg_handler = function(args)
          return args.new_name or args[1], args.options
        end,
        opts = {
          "new_name",
          "options.filter",
          "options.name",
        },
      },
      workspace_symbol = {
        ---@param args lsp_command_parsed_arg_t
        arg_handler = function(args)
          return args.query, args.options
        end,
        opts = { "query", "options.on_list" },
      },
      format = {
        arg_handler = arg_handler_range,
        opts = {
          "formatting_options",
          "formatting_options.tabSize",
          ["formatting_options.insertSpaces"] = optvals.bool,
          ["formatting_options.trimTrailingWhitespace"] = optvals.bool,
          ["formatting_options.insertFinalNewline"] = optvals.bool,
          ["formatting_options.trimFinalNewlines"] = optvals.bool,
          "timeout_ms",
          ["bufnr"] = optvals.bufs,
          "filter",
          ["async"] = optvals.bool,
          "id",
          "name",
          "range",
        },
      },
      auto_format = {
        ---@param args lsp_command_parsed_arg_t
        ---@param tbl table information passed to the command
        ---@return lsp_command_parsed_arg_t args
        ---@return table tbl
        arg_handler = function(args, tbl)
          args.format = arg_handler_range(args, tbl).format
          return args, tbl
        end,
        params = {
          "enable",
          "disable",
          "toggle",
          "reset",
          "status",
        },
        opts = {
          "format.formatting_options",
          "format.formatting_options.tabSize",
          ["format.formatting_options.insertSpaces"] = optvals.bool,
          ["format.formatting_options.trimTrailingWhitespace"] = optvals.bool,
          ["formatting_options.insertFinalNewline"] = optvals.bool,
          ["format.formatting_options.trimFinalNewlines"] = optvals.bool,
          "format.timeout_ms",
          ["format.bufnr"] = optvals.bufs,
          "format.filter",
          "format.async",
          "format.id",
          "format.name",
          "format.range",
          ["local"] = optvals.bool,
          ["global"] = optvals.bool,
        },
        ---@param args lsp_command_parsed_arg_t
        ---@param tbl table information passed to the command
        fn_override = function(args, tbl)
          local enabled = utils.classes.bufopt_t:new("lsp_autofmt_enabled") ---@type bufopt_t
          local fmtopts = utils.classes.bufopt_t:new("lsp_autofmt_opts") ---@type bufopt_t
          if tbl.bang or vim.tbl_contains(args, "toggle") then
            enabled:scope_action(args, "toggle")
          elseif tbl.fargs[1] == "&" or vim.tbl_contains(args, "reset") then
            enabled:scope_action(args, "reset")
            fmtopts:scope_action(args, "reset")
          elseif tbl.fargs[1] == "?" or vim.tbl_contains(args, "status") then
            enabled:scope_action(args, "print")
            fmtopts:scope_action(args, "print")
          elseif vim.tbl_contains(args, "enable") then
            enabled:scope_action(args, "set", true)
          elseif vim.tbl_contains(args, "disable") then
            enabled:scope_action(args, "set", false)
          end
          if args.format then
            fmtopts:scope_action(
              args,
              "set",
              vim.tbl_deep_extend(
                "force",
                fmtopts:scope_action(args, "get"),
                args.format
              )
            )
          end
        end,
      },
      code_action = {
        opts = {
          "context.diagnostics",
          "context.only",
          "context.triggerKind",
          "filter",
          ["apply"] = optvals.bool,
          "range",
        },
      },
      add_workspace_folder = {
        arg_handler = arg_handler_item,
        completion = function(arglead, _, _)
          local basedir = arglead == "" and vim.fn.getcwd() or arglead
          local incomplete = nil ---@type string|nil
          if not vim.uv.fs_stat(basedir) then
            basedir = vim.fn.fnamemodify(basedir, ":h")
            incomplete = vim.fn.fnamemodify(arglead, ":t")
          end
          local subdirs = {}
          for name, type in vim.fs.dir(basedir) do
            if type == "directory" and name ~= "." and name ~= ".." then
              table.insert(
                subdirs,
                vim.fn.fnamemodify(
                  vim.fn.resolve(vim.fs.joinpath(basedir, name)),
                  ":p:~:."
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
            local short = vim.fn.fnamemodify(path, ":p:~:.")
            return short ~= "" and short or "./"
          end, vim.lsp.buf.list_workspace_folders())
        end,
      },
      execute_command = { arg_handler = arg_handler_item },
      type_definition = {
        opts = {
          "reuse_win",
          ["on_list"] = optvals.bool,
        },
      },
      declaration = {
        opts = {
          "reuse_win",
          ["on_list"] = optvals.bool,
        },
      },
      definition = {
        opts = {
          "reuse_win",
          ["on_list"] = optvals.bool,
        },
      },
      document_symbol = {
        opts = {
          ["on_list"] = optvals.bool,
        },
      },
      implementation = {
        opts = {
          ["on_list"] = optvals.bool,
        },
      },
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
      signature_help = {},
    },
  },

  ---Diagnostic subcommands
  ---@type table<string, subcommand_info_t>
  diagnostic = {
    config = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.opts, args.namespace
      end,
      opts = {
        ["opts.underline"] = optvals.bool,
        ["opts.underline.severity"] = optvals.severity,
        ["opts.virtual_text"] = optvals.bool,
        ["opts.virtual_text.severity"] = optvals.severity,
        "opts.virtual_text.source",
        "opts.virtual_text.spacing",
        "opts.virtual_text.prefix",
        "opts.virtual_text.suffix",
        "opts.virtual_text.format",
        ["opts.signs"] = optvals.bool,
        ["opts.signs.severity"] = optvals.severity,
        "opts.signs.priority",
        "opts.float",
        ["opts.float.bufnr"] = optvals.bufs,
        "opts.float.namespace",
        "opts.float.scope",
        "opts.float.pos",
        "opts.float.severity_sort",
        ["opts.float.severity"] = optvals.severity,
        "opts.float.header",
        "opts.float.source",
        "opts.float.format",
        "opts.float.prefix",
        "opts.float.suffix",
        ["opts.update_in_insert"] = optvals.bool,
        "opts.severity_sort",
        ["opts.severity_sort.reverse"] = optvals.bool,
        "namespace",
      },
    },
    disable = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.namespace
      end,
      opts = {
        ["bufnr"] = optvals.bufs,
        "namespace",
      },
    },
    enable = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.namespace
      end,
      opts = {
        ["bufnr"] = optvals.bufs,
        "namespace",
      },
    },
    fromqflist = {
      arg_handler = arg_handler_item,
      opts = { "list" },
      fn_override = function(...)
        vim.diagnostic.show(nil, 0, vim.diagnostic.fromqflist(...))
      end,
    },
    get = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.opts
      end,
      opts = {
        ["bufnr"] = optvals.bufs,
        "opts.namespace",
        "opts.lnum",
        ["opts.severity"] = optvals.severity,
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get(...)))
      end,
    },
    get_namespace = {
      arg_handler = arg_handler_item,
      opts = { "namespace" },
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
        "namespace",
        "cursor_position",
        "wrap",
        ["severity"] = optvals.severity,
        ["float"] = optvals.bool,
        ["float.bufnr"] = optvals.bufs,
        "float.namespace",
        "float.scope",
        "float.pos",
        "float.severity_sort",
        ["float.severity"] = optvals.severity,
        "float.header",
        "float.source",
        "float.format",
        "float.prefix",
        "float.suffix",
        "win_id",
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_next(...)))
      end,
    },
    get_next_pos = {
      opts = {
        "namespace",
        "cursor_position",
        "wrap",
        ["severity"] = optvals.severity,
        ["float"] = optvals.bool,
        ["float.bufnr"] = optvals.bufs,
        "float.namespace",
        "float.scope",
        "float.pos",
        "float.severity_sort",
        ["float.severity"] = optvals.severity,
        "float.header",
        "float.source",
        "float.format",
        "float.prefix",
        "float.suffix",
        "win_id",
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_next_pos(...)))
      end,
    },
    get_prev = {
      opts = {
        "namespace",
        "cursor_position",
        "wrap",
        ["severity"] = optvals.severity,
        ["float"] = optvals.bool,
        ["float.bufnr"] = optvals.bufs,
        "float.namespace",
        "float.scope",
        "float.pos",
        "float.severity_sort",
        ["float.severity"] = optvals.severity,
        "float.header",
        "float.source",
        "float.format",
        "float.prefix",
        "float.suffix",
        "win_id",
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_prev(...)))
      end,
    },
    get_prev_pos = {
      opts = {
        "namespace",
        "cursor_position",
        "wrap",
        ["severity"] = optvals.severity,
        ["float"] = optvals.bool,
        ["float.bufnr"] = optvals.bufs,
        "float.namespace",
        "float.scope",
        "float.pos",
        "float.severity_sort",
        ["float.severity"] = optvals.severity,
        "float.header",
        "float.source",
        "float.format",
        "float.prefix",
        "float.suffix",
        "win_id",
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.get_prev_pos(...)))
      end,
    },
    goto_next = {
      opts = {
        "namespace",
        "cursor_position",
        "wrap",
        ["severity"] = optvals.severity,
        ["float"] = optvals.bool,
        ["float.bufnr"] = optvals.bufs,
        "float.namespace",
        "float.scope",
        "float.pos",
        "float.severity_sort",
        ["float.severity"] = optvals.severity,
        "float.header",
        "float.source",
        "float.format",
        "float.prefix",
        "float.suffix",
        "win_id",
      },
    },
    goto_prev = {
      opts = {
        "namespace",
        "cursor_position",
        "wrap",
        ["severity"] = optvals.severity,
        ["float"] = optvals.bool,
        ["float.bufnr"] = optvals.bufs,
        "float.namespace",
        "float.scope",
        "float.pos",
        "float.severity_sort",
        ["float.severity"] = optvals.severity,
        "float.header",
        "float.source",
        "float.format",
        "float.prefix",
        "float.suffix",
        "win_id",
      },
    },
    hide = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr
      end,
      opts = {
        "namespace",
        ["bufnr"] = optvals.bufs,
      },
    },
    is_disabled = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.bufnr, args.namespace
      end,
      opts = {
        "namespace",
        ["bufnr"] = optvals.bufs,
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.is_disabled(...)))
      end,
    },
    match = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.str,
          args.pat,
          args.groups,
          args.severity_map,
          args.defaults
      end,
      opts = {
        "str",
        "pat",
        "groups",
        "severity_map",
        "defaults",
      },
      fn_override = function(...)
        vim.notify(vim.inspect(vim.diagnostic.match(...)))
      end,
    },
    open_float = {
      opts = {
        ["bufnr"] = optvals.bufs,
        "namespace",
        "scope",
        "pos",
        ["severity_sort"] = optvals.bool,
        ["severity"] = optvals.severity,
        "header",
        ["source"] = optvals.bool,
        "format",
        "prefix",
        "suffix",
      },
    },
    reset = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr
      end,
      opts = {
        "namespace",
        ["bufnr"] = optvals.bufs,
      },
    },
    set = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr, args.diagnostics, args.opts
      end,
      opts = {
        "namespace",
        ["bufnr"] = optvals.bufs,
        "diagnostics",
        ["opts.underline"] = optvals.bool,
        ["opts.underline.severity"] = optvals.severity,
        ["opts.virtual_text"] = optvals.bool,
        ["opts.virtual_text.severity"] = optvals.severity,
        "opts.virtual_text.source",
        "opts.virtual_text.spacing",
        "opts.virtual_text.prefix",
        "opts.virtual_text.suffix",
        "opts.virtual_text.format",
        ["opts.signs"] = optvals.bool,
        ["opts.signs.severity"] = optvals.severity,
        "opts.signs.priority",
        "opts.float",
        ["opts.float.bufnr"] = optvals.bufs,
        "opts.float.namespace",
        "opts.float.scope",
        "opts.float.pos",
        "opts.float.severity_sort",
        ["opts.float.severity"] = optvals.severity,
        "opts.float.header",
        "opts.float.source",
        "opts.float.format",
        "opts.float.prefix",
        "opts.float.suffix",
        ["opts.update_in_insert"] = optvals.bool,
        "opts.severity_sort",
        ["opts.severity_sort.reverse"] = optvals.bool,
      },
    },
    setloclist = {
      opts = {
        "namespace",
        "winnr",
        "open",
        "title",
        ["severity"] = optvals.severity,
      },
    },
    setqflist = {
      opts = {
        "namespace",
        "open",
        "title",
        ["severity"] = optvals.severity,
      },
    },
    show = {
      ---@param args lsp_command_parsed_arg_t
      arg_handler = function(args)
        return args.namespace, args.bufnr, args.diagnostics, args.opts
      end,
      opts = {
        "namespace",
        ["bufnr"] = optvals.bufs,
        "diagnostics",
        ["opts.underline"] = optvals.bool,
        ["opts.underline.severity"] = optvals.severity,
        ["opts.virtual_text"] = optvals.bool,
        ["opts.virtual_text.severity"] = optvals.severity,
        "opts.virtual_text.source",
        "opts.virtual_text.spacing",
        "opts.virtual_text.prefix",
        "opts.virtual_text.suffix",
        "opts.virtual_text.format",
        ["opts.signs"] = optvals.bool,
        ["opts.signs.severity"] = optvals.severity,
        "opts.signs.priority",
        "opts.float",
        ["opts.float.bufnr"] = optvals.bufs,
        "opts.float.namespace",
        "opts.float.scope",
        "opts.float.pos",
        "opts.float.severity_sort",
        ["opts.float.severity"] = optvals.severity,
        "opts.float.header",
        "opts.float.source",
        "opts.float.format",
        "opts.float.prefix",
        "opts.float.suffix",
        ["opts.update_in_insert"] = optvals.bool,
        "opts.severity_sort",
        ["opts.severity_sort.reverse"] = optvals.bool,
      },
    },
    toqflist = {
      arg_handler = arg_handler_item,
      opts = { "diagnostics" },
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
    if not fn_name then
      return
    end
    local fn = subcommand_info_list[fn_name]
        and subcommand_info_list[fn_name].fn_override
      or fn_scope[fn_name]
    if not fn then
      return
    end
    local arg_handler = subcommand_info_list[fn_name].arg_handler
      or function(...)
        return ...
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
    if cmdline:sub(1, cursorpos):match("^%A*" .. meta .. "%s+%S*$") then
      return vim.tbl_filter(function(cmd)
        return cmd:find(arglead, 1, true) == 1
      end, vim.tbl_keys(subcommand_info_list))
    end
    -- If subcommand is specified, complete with its options or params
    local subcommand = utils.string.camel_to_snake(
      cmdline:match("^%s*" .. meta .. "(%w+)")
    ) or cmdline:match("^%s*" .. meta .. "%s+(%S+)")
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
    -- Complete with subcommand's options or params
    local subcommand_info = subcommand_info_list[subcommand]
    if subcommand_info then
      return utils.command.complete(
        subcommand_info.params,
        subcommand_info.opts
      )(arglead, cmdline, cursorpos)
    end
    return {}
  end
end

---Setup commands
---@param meta string meta command name
---@param subcommand_info_list table<string, subcommand_info_t> subcommands information
---@param fn_scope table scope of corresponding functions for subcommands
---@return nil
local function setup_commands(meta, subcommand_info_list, fn_scope)
  -- metacommand -> MetaCommand abbreviation
  utils.keymap.command_abbrev(meta:lower(), meta)
  -- Format: MetaCommand sub_command opts ...
  vim.api.nvim_create_user_command(
    meta,
    command_meta(subcommand_info_list, fn_scope),
    {
      bang = true,
      range = true,
      nargs = "*",
      complete = command_complete(meta, subcommand_info_list),
    }
  )
  -- Format: MetaCommandSubcommand opts ...
  for subcommand, _ in pairs(subcommand_info_list) do
    vim.api.nvim_create_user_command(
      meta .. utils.string.snake_to_camel(subcommand),
      command_meta(subcommand_info_list, fn_scope, subcommand),
      {
        bang = true,
        range = true,
        nargs = "*",
        complete = command_complete(meta, subcommand_info_list),
      }
    )
  end
end

---@return nil
local function setup_lsp_autoformat()
  ---@type bufopt_t
  local enabled = utils.classes.bufopt_t:new("lsp_autofmt_enabled", false)
  ---@type bufopt_t
  local fmtopts = utils.classes.bufopt_t:new("lsp_autofmt_opts", {
    async = true,
    timeout_ms = 500,
  })
  vim.api.nvim_create_autocmd("BufWritePre", {
    desc = "LSP format on save.",
    group = vim.api.nvim_create_augroup("LspAutoFmt", {}),
    callback = function(info)
      if enabled:get(info.buf) then
        vim.lsp.buf.format(fmtopts:get(info.buf))
      end
    end,
  })
end

local lsp_autostop_pending
---Automatically stop LSP servers that no longer attaches to any buffers
---
---  Once `BufDelete` is triggered, wait for 60s before checking and
---  stopping servers, in this way the callback will be invoked once
---  every 60 seconds at most and can stop multiple clients at once
---  if possible, which is more efficient than checking and stopping
---  clients on every `BufDelete` events
---
---@return nil
local function setup_lsp_autostop()
  vim.api.nvim_create_autocmd("BufDelete", {
    group = vim.api.nvim_create_augroup("LspAutoStop", {}),
    desc = "Automatically stop idle language servers.",
    callback = function()
      if lsp_autostop_pending then
        return
      end
      lsp_autostop_pending = true
      vim.defer_fn(function()
        lsp_autostop_pending = nil
        for _, client in ipairs(vim.lsp.get_clients()) do
          if vim.tbl_isempty(vim.lsp.get_buffers_by_client_id(client.id)) then
            vim.lsp.stop_client(client.id, true)
          end
        end
      end, 60000)
    end,
  })
end

---Set up diagnostic signs and virtual text
---@return nil
local function setup_diagnostic()
  local icons = utils.static.icons
  for _, severity in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    local sign_name = "DiagnosticSign" .. severity
    vim.fn.sign_define(sign_name, {
      text = icons[sign_name],
      texthl = sign_name,
      numhl = sign_name,
    })
  end
  vim.diagnostic.config({
    virtual_text = {
      spacing = 4,
      prefix = vim.trim(utils.static.icons.AngleLeft),
    },
  })
end

---Set up LSP and diagnostic
---@return nil
local function setup()
  if vim.g.loaded_lsp_diagnostics ~= nil then
    return
  end
  vim.g.loaded_lsp_diagnostics = true
  setup_keymaps()
  setup_lsp_overrides()
  setup_lsp_autoformat()
  setup_lsp_autostop()
  setup_diagnostic()
  setup_commands("Lsp", subcommands.lsp.buf, vim.lsp.buf)
  setup_commands("Diagnostic", subcommands.diagnostic, vim.diagnostic)
end

return {
  setup = setup,
}
