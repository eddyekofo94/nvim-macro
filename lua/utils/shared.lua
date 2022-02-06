local M = {}

M.langs = {
  bash = { ft = 'bash', lsp_server = 'bashls' },
  bibtex = { ts = 'bibtex', ft = 'bib', lsp_server = 'texlab' },
  c = { ts = 'c', ft = 'c', lsp_server = 'clangd' },
  cpp = { ts = 'cpp', ft = 'cpp', lsp_server = 'clangd' },
  html = { ts = 'html', ft = 'html', lsp_server = 'html' },
  latex = { ts = 'latex', ft = 'tex', lsp_server = 'texlab' },
  lua = { ts = 'lua', ft = 'lua', lsp_server = 'sumneko_lua' },
  make = { ts = 'make', ft = 'make' },
  markdown = { ts = 'markdown', ft = 'markdown', lsp_server = 'remark_ls' },
  python = { ts = 'python', ft = 'python', lsp_server = 'pylsp' },
  vim = { ts = 'vim', ft = 'vim', lsp_server = 'vimls' }
}

M.borders = {
  rounded = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  single = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
  double = { '═', '║', '═', '║', '╔', '╗', '╝', '╚' },
  vintage = { '-', '|', '-', '|', '+', '+', '+', '+' }
}

return M
