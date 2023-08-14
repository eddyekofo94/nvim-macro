local utils = require('utils')

return {
  init_options = { documentFormatting = true },
  filetypes = { 'lua', 'python', 'sh', 'fish' },
  single_file_support = false,
  root_dir = function(startpath)
    return utils.fs.proj_dir(startpath) or vim.fs.dirname(startpath)
  end,
  settings = {
    rootMarkers = utils.fs.root_patterns,
    languages = {
      lua = {
        {
          formatStdin = true,
          formatCanRange = true,
          formatCommand = 'stylua ${--indent-width:tabSize} ${--range-start:charStart} ${--range-end:charEnd} --color Never -',
          rootMarkers = { 'stylua.toml', '.stylua.toml' },
        },
      },
      python = {
        {
          formatCommand = 'black --no-color -q -',
          formatStdin = true,
        },
      },
      sh = {
        {
          formatCommand = 'shfmt -filename ${INPUT} -',
          formatStdin = true,
        },
      },
      fish = {
        {
          formatCommand = 'fish_indent ${INPUT}',
          formatStdin = true,
        },
      },
    },
  },
}
