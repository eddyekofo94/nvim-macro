local M = {}

---Recursively build a nested table from a list of keys and a value
---@param key_parts string[] list of keys
---@param val any
---@return table
function M.build_nested(key_parts, val)
  return key_parts[1]
      and { [key_parts[1]] = M.build_nested({ unpack(key_parts, 2) }, val) }
    or val
end

---Parse arguments from the command line into a table
---@param fargs string[] list of arguments
---@return table
function M.parse_cmdline_args(fargs)
  local parsed = {}
  -- First pass: parse arguments into a plain table
  for _, arg in ipairs(fargs) do
    local key, val = arg:match('^%-%-(%S+)=(.*)$')
    if not key then
      key = arg:match('^%-%-(%S+)$')
    end
    local val_expanded = vim.fn.expand(val)
    if type(val) == 'string' and vim.loop.fs_stat(val_expanded) then
      val = val_expanded
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
        vim.tbl_deep_extend('force', parsed, M.build_nested(key_parts, val))
      if #key_parts > 1 then
        parsed[key] = nil -- Remove the original dot-separated key
      end
    end
  end
  return parsed
end

---options command accepts, in the format of <opt>=<val> or <opt>
---@class opts_t

---Get option keys / option names from opts table
---@param opts opts_t
---@return string[]
function M.optkeys(opts)
  local optkeys = {}
  for key, val in pairs(opts) do
    if type(key) == 'number' then
      table.insert(optkeys, val)
    elseif type(key) == 'string' then
      table.insert(optkeys, key)
    end
  end
  return optkeys
end

---Returns a function that can be used to complete the options of a command
---An option must be in the format of --<opt> or --<opt>=<val>
---@param opts opts_t
---@return fun(arglead: string, cmdline: string, cursorpos: integer[]): string[]
function M.complete_opts(opts)
  ---@param arglead string leading portion of the argument being completed
  ---@return string[] completion completion results
  return function(arglead, _, _)
    -- Complete with option values
    local optkey, optval = arglead:match('^--([^%s=]+)=?([^%s=]*)$')
    if optkey and optval then
      local candidate_vals = vim.tbl_map(
        tostring,
        type(opts[optkey]) == 'function' and opts[optkey]() or opts[optkey]
      )
      return candidate_vals
          and vim.tbl_filter(function(val)
            return val:find(optval, 1, true) == 1
          end, candidate_vals)
        or {}
    end
    -- Complete with command's options
    if arglead == '' then
      return M.optkeys(opts)
    end
    if arglead:match('^%-%-') then
      return vim.tbl_filter(function(opt)
        return opt:find(arglead, 1, true) == 1
      end, M.optkeys(opts))
    end
    return {}
  end
end

return M
