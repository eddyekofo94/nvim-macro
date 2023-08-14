return {
  init_options = { documentFormatting = true },
  filetypes = { 'lua', 'python', 'sh' },
  single_file_support = false,
  settings = {
    rootMarkers = { '.git/' },
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
    },
  },
}
