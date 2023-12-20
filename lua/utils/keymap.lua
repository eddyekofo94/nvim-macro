local M = {}
-- normal, visual, operator (for motion mappings)

M.nxo = { 'n', 'x', 'o' }

-- move over a closing element in insert mode
M.escapePair = function()
  local closers = { ')', ']', '}', '>', "'", '"', '`', ',' }
  local line = vim.api.nvim_get_current_line()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local after = line:sub(col + 1, -1)
  local closer_col = #after + 1
  local closer_i = nil
  for i, closer in ipairs(closers) do
    local cur_index, _ = after:find(closer)
    if cur_index and (cur_index < closer_col) then
      closer_col = cur_index
      closer_i = i
    end
  end
  if closer_i then
    vim.api.nvim_win_set_cursor(0, { row, col + closer_col })
  else
    vim.api.nvim_win_set_cursor(0, { row, col + 1 })
  end
end

--- If you don't pass the modes, it is normal and execute
function M.set_keymap(modes, lhs, rhs, opts)
  if type(opts) == 'string' then
    opts = { desc = opts }
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

function M.set_buf_keymap(mode, key, rhs, opts)
  vim.keymap.set(mode, key, rhs, { buffer = 0 })
end

---Set abbreviation that only expand when the trigger is at the position of
---a command
---@param trig string
---@param command string
---@param opts table?
function M.command_abbrev(trig, command, opts)
  vim.keymap.set('ca', trig, function()
    return vim.fn.getcmdcompltype() == 'command' and command or trig
  end, vim.tbl_deep_extend('keep', { expr = true }, opts or {}))
end

---@class keymap_def_t
---@field lhs string
---@field lhsraw string
---@field rhs string?
---@field callback function?
---@field expr boolean?
---@field desc string?
---@field noremap boolean?
---@field script boolean?
---@field silent boolean?
---@field nowait boolean?
---@field buffer boolean?
---@field replace_keycodes boolean?

---Get keymap definition
---@param mode string
---@param lhs string
---@return keymap_def_t
function M.get(mode, lhs)
  local lhs_keycode = vim.keycode(lhs)
  for _, map in ipairs(vim.api.nvim_buf_get_keymap(0, mode)) do
    if vim.keycode(map.lhs) == lhs_keycode then
      return {
        lhs = map.lhs,
        rhs = map.rhs,
        expr = map.expr == 1,
        callback = map.callback,
        desc = map.desc,
        noremap = map.noremap == 1,
        script = map.script == 1,
        silent = map.silent == 1,
        nowait = map.nowait == 1,
        buffer = true,
        replace_keycodes = map.replace_keycodes == 1,
      }
    end
  end
  for _, map in ipairs(vim.api.nvim_get_keymap(mode)) do
    if vim.keycode(map.lhs) == lhs_keycode then
      return {
        lhs = map.lhs,
        rhs = map.rhs or '',
        expr = map.expr == 1,
        callback = map.callback,
        desc = map.desc,
        noremap = map.noremap == 1,
        script = map.script == 1,
        silent = map.silent == 1,
        nowait = map.nowait == 1,
        buffer = false,
        replace_keycodes = map.replace_keycodes == 1,
      }
    end
  end
  return {
    lhs = lhs,
    rhs = lhs,
    expr = false,
    noremap = true,
    script = false,
    silent = true,
    nowait = false,
    buffer = false,
    replace_keycodes = true,
  }
end

---@param def keymap_def_t
---@return function
function M.fallback_fn(def)
  local modes = def.noremap and 'in' or 'im'
  ---@param keys string
  ---@return nil
  local function feed(keys)
    local keycode = vim.keycode(keys)
    local keyseq = vim.v.count > 0 and vim.v.count .. keycode or keycode
    vim.api.nvim_feedkeys(keyseq, modes, false)
  end
  if not def.expr then
    return def.callback or function()
      feed(def.rhs)
    end
  end
  if def.callback then
    return function()
      feed(def.callback())
    end
  else
    -- Escape rhs to avoid nvim_eval() interpreting
    -- special characters
    local rhs = vim.fn.escape(def.rhs, '\\')
    return function()
      feed(vim.api.nvim_eval(rhs))
    end
  end
end

---Amend keymap
---Caveat: currently cannot amend keymap with <Cmd>...<CR> rhs
---@param modes string[]|string
---@param lhs string
---@param rhs function(fallback: function)
---@param opts table?
---@return nil
function M.amend(modes, lhs, rhs, opts)
  modes = type(modes) ~= 'table' and { modes } or modes --[=[@as string[]]=]
  for _, mode in ipairs(modes) do
    local fallback = M.fallback_fn(M.get(mode, lhs))
    vim.keymap.set(mode, lhs, function()
      rhs(fallback)
    end, opts)
  end
end

---Wrap a function so that it repeats the original function multiple times
---according to v:count or v:count1
---@generic T
---@param fn fun(): T?
---@param count? 0|1 count given for the last normal mode command, see `:h v:count` or `:h v:count1`, default to 1
---@return fun(): T[]
function M.count_wrap(fn, count)
  return function()
    if count == 0 and vim.v.count0 == 0 then
      return {}
    end
    local result = {}
    for _ = 1, vim.v.count1 do
      vim.list_extend(result, { fn() })
    end
    return unpack(result)
  end
end

return M
