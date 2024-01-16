if vim.fn.executable('fish_indent') == 1 then
  require('utils.lsp').launch(0, { 'efm-langserver' }, {}, {
    name = 'efm-formatter-fish_indent',
    init_options = { documentFormatting = true },
    settings = {
      languages = {
        fish = {
          {
            formatCommand = 'fish_indent ${INPUT}',
            formatStdin = true,
          },
        },
      },
    },
  })
end
