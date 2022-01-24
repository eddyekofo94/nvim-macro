local langs = {}

langs.bash = {
  ft = 'bash',
  lsp_server = 'bashls'
}

langs.bibtex = {
  ts = 'bibtex',
  ft = 'bib',
  lsp_server = 'texlab'
}

langs.c = {
  ts = 'c',
  ft = 'c',
  lsp_server = 'clangd'
}

langs.cpp = {
  ts = 'cpp',
  ft = 'cpp',
  lsp_server = 'clangd'
}

langs.html = {
  ts = 'html',
  ft = 'html',
  lsp_server = 'html'
}

langs.latex = {
  ts = 'latex',
  ft = 'tex',
  lsp_server = 'texlab'
}

langs.lua = {
  ts = 'lua',
  ft = 'lua',
  lsp_server = 'sumneko_lua'
}

langs.make = {
  ts = 'make',
  ft = 'make',
}

langs.markdown = {
  ts = 'markdown',
  ft = 'markdown',
  lsp_server = 'remark_ls'
}

langs.python = {
  ts = 'python',
  ft = 'python',
  lsp_server = 'pylsp'
}

langs.vim = {
  ts = 'vim',
  ft = 'vim',
  lsp_server = 'vimls'
}

return langs
