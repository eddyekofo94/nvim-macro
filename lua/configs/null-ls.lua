local null_ls = require('null-ls')

---Toggle format-on-save functionality for null-ls
---@param tbl table
local function null_ls_set_format_on_save(tbl)
  if vim.tbl_contains(tbl.fargs, '?') then
    vim.notify(
      '[null-ls] format-on-save: turned '
        .. (vim.b.null_ls_format_on_save and 'on' or 'off')
        .. ' locally, '
        .. (vim.g.null_ls_format_on_save and 'enabled' or 'disabled')
        .. ' globally',
      vim.log.levels.INFO
    )
    return
  end

  local global = not vim.tbl_contains(tbl.fargs, '--local')

  if vim.tbl_contains(tbl.fargs, 'on') then
    vim.b.null_ls_format_on_save = true
    if global then
      vim.g.null_ls_format_on_save = true
    end
  elseif vim.tbl_contains(tbl.fargs, 'off') then
    vim.b.null_ls_format_on_save = false
    if global then
      vim.g.null_ls_format_on_save = false
    end
  else -- toggle
    vim.b.null_ls_format_on_save = not vim.b.null_ls_format_on_save
    vim.g.null_ls_format_on_save = vim.b.null_ls_format_on_save
  end

  vim.notify(
    '[null-ls] format-on-save: '
      .. (vim.b.null_ls_format_on_save and 'on' or 'off'),
    vim.log.levels.INFO
  )
end

---Null-ls on-attach function
---@param client table LSP client
---@param bufnr integer buffer number
local function null_ls_on_attach(client, bufnr)
  if not client.supports_method('textDocument/formatting') then
    return
  end

  vim.api.nvim_create_augroup('NullLsFormatOnSave', { clear = false })
  vim.api.nvim_create_autocmd('BufWritePre', {
    buffer = bufnr,
    group = 'NullLsFormatOnSave',
    callback = function()
      if vim.b.null_ls_format_on_save then
        vim.lsp.buf.format({ bufnr = bufnr })
      end
    end,
  })
  vim.b.null_ls_format_on_save = vim.g.null_ls_format_on_save
  vim.api.nvim_buf_create_user_command(
    bufnr,
    'NullLsFormatOnSave',
    null_ls_set_format_on_save,
    {
      nargs = '*',
      complete = function(arg_before, _, _)
        local completion = {
          [''] = {
            'on',
            'off',
            'toggle',
            '--local',
          },
          ['--'] = {
            'local',
          },
        }
        return completion[arg_before] or {}
      end,
      desc = 'Toggle Null-ls format-on-save functionality.',
    }
  )
end

local formatters = vim.tbl_map(
  function(formatter_name)
    return null_ls.builtins.formatting[formatter_name]
  end,
  vim.tbl_map(function(formatter)
    return formatter:gsub('-', '_')
  end, require('utils.static').langs:list('formatter'))
)

null_ls.setup({
  sources = formatters,
  on_attach = null_ls_on_attach,
})
