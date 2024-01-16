require('utils.lsp').launch(0, { 'clangd' }, {
  '.clangd',
  '.clang-tidy',
  '.clang-format',
  'compile_commands.json',
  'compile_flags.txt',
  'configure.ac',
}, {
  capabilities = {
    offsetEncoding = {
      'utf-16',
    },
  },
})
