local M = {}

local langs_mt = {}
langs_mt.__index = langs_mt
function langs_mt:list(field)
  local deduplist = {}
  local result = {}
  -- deduplication
  for _, info in pairs(self) do
    if type(info[field]) == 'string' then
      deduplist[info[field]] = true
    end
  end
  for name, _ in pairs(deduplist) do
    table.insert(result, name)
  end
  return result
end

M.langs = setmetatable({
  bash = {
    ft = 'sh',
    lsp_server = 'bashls',
    dap = 'bashdb',
    formatting = 'shfmt',
  },
  c = {
    ts = 'c',
    ft = 'c',
    lsp_server = 'clangd',
    dap = 'codelldb',
    formatting = 'clang-format',
  },
  cpp = {
    ts = 'cpp',
    ft = 'cpp',
    lsp_server = 'clangd',
    dap = 'codelldb',
    formatting = 'clang-format',
  },
  help = {
    ts = 'vimdoc',
    ft = 'help',
  },
  lua = {
    ts = 'lua',
    ft = 'lua',
    lsp_server = 'lua_ls',
    formatting = 'stylua',
  },
  rust = {
    ts = 'rust',
    ft = 'rust',
    lsp_server = 'rust_analyzer',
    formatting = 'rustfmt',
  },
  make = {
    ts = 'make',
    ft = 'make',
  },
  python = {
    ts = 'python',
    ft = 'python',
    lsp_server = 'pylsp',
    dap = 'debugpy',
    formatting = 'black',
  },
  vim = {
    ts = 'vim',
    ft = 'vim',
    lsp_server = 'vimls',
  },
  latex = {
    ft = 'tex',
    lsp_server = 'texlab',
    formatting = 'latexindent',
  },
}, langs_mt)

M.borders = {
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  double_header = { '═', '│', '─', '│', '╒', '╕', '┘', '└' },
  double_bottom = { '─', '│', '═', '│', '┌', '┐', '╛', '╘' },
  double_horizontal = { '═', '│', '═', '│', '╒', '╕', '╛', '╘' },
  double_left = { '─', '│', '─', '│', '╓', '┐', '┘', '╙' },
  double_right = { '─', '│', '─', '│', '┌', '╖', '╜', '└' },
  double_vertical = { '─', '│', '─', '│', '╓', '╖', '╜', '╙' },
  vintage = { '-', '|', '-', '|', '+', '+', '+', '+' },
  rounded_clc = { '╭', '─', '╮', '│', '╯', '─', '╰', '│' },
  single_clc = { '┌', '─', '┐', '│', '┘', '─', '└', '│' },
  double_clc = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' },
  double_header_clc = { '╒', '═', '╕', '│', '┘', '─', '└', '│' },
  double_bottom_clc = { '┌', '─', '┐', '│', '╛', '═', '╘', '│' },
  double_horizontal_clc = { '╒', '═', '╕', '│', '╛', '═', '╘', '│' },
  double_left_clc = { '╓', '─', '┐', '│', '┘', '─', '╙', '│' },
  double_right_clc = { '┌', '─', '╖', '│', '╜', '─', '└', '│' },
  double_vertical_clc = { '╓', '─', '╖', '│', '╜', '─', '╙', '│' },
  vintage_clc = { '+', '-', '+', '|', '+', '-', '+', '|' },
  empty = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' }
}

M.icons = {
  Array = ' ',
  Boolean = ' ',
  Calculator = ' ',
  Class = ' ',
  Collapsed = ' ',
  Color = ' ',
  Constant = ' ',
  Constructor = ' ',
  Copilot = ' ',
  DiagnosticSignError = ' ',
  DiagnosticSignHint = ' ',
  DiagnosticSignInfo = ' ',
  DiagnosticSignOk = ' ',
  DiagnosticSignWarn = ' ',
  Ellipsis = '… ',
  Enum = ' ',
  EnumMember = ' ',
  Event = ' ',
  Field = ' ',
  File = ' ',
  Folder = ' ',
  Format = '󰗈 ',
  Function = ' ',
  Interface = ' ',
  Keyword = ' ',
  Lsp = ' ',
  Method = ' ',
  Module = ' ',
  Namespace = ' ',
  Number = ' ',
  Object = ' ',
  Operator = ' ',
  Package = ' ',
  Property = ' ',
  Reference = ' ',
  Regex = ' ',
  Repeat = ' ',
  Snippet = ' ',
  Specifier = ' ',
  Statement = ' ',
  String = ' ',
  Struct = ' ',
  Terminal = ' ',
  Text = ' ',
  Type = ' ',
  TypeParameter = ' ',
  Unit = '塞 ',
  Value = ' ',
  Variable = ' ',
}

return M
