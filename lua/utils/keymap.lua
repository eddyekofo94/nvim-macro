local M = {}

---Set abbreviation that only expand when the trigger is at the start of the
---command line or after a pipe "|"
---(i.e. only when the trigger is at the position of a command)
---@param trig string
---@param command string
---@param opts table?
function M.command_abbrev(trig, command, opts)
  vim.keymap.set('ca', trig, function()
    local cmdline_before = vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1)
    local trig_escaped = vim.pesc(trig)
    -- stylua: ignore start
    return vim.fn.getcmdtype() == ':'
        and (cmdline_before:find('^%s*' .. trig_escaped .. '$')
          or cmdline_before:find('|%s*' .. trig_escaped .. '$'))
        and command
      or trig
    -- stylua: ignore end
  end, vim.tbl_deep_extend('keep', { expr = true }, opts or {}))
end

return M
