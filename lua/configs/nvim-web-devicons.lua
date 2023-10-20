local icons = require('utils.static').icons

require('nvim-web-devicons').setup({
  override = {
    default_icon = {
      color = '#b4b4b9',
      cterm_color = '249',
      icon = vim.trim(icons.File),
      name = 'Default',
    },
    desktop = {
      color = '#563d7c',
      cterm_color = '60',
      icon = vim.trim(icons.Desktop),
      name = 'DesktopEntry',
    },
  },
  override_by_extension = {
    cu = {
      color = '#76b900',
      cterm_color = '2',
      icon = vim.trim(icons.Cuda),
      name = 'Cuda',
    },
    raw = {
      color = '#ff9800',
      cterm_color = '208',
      icon = vim.trim(icons.Raw),
      name = 'Raw',
    },
    dat = {
      color = '#6dcde8',
      cterm_color = '81',
      icon = vim.trim(icons.Data),
      name = 'Data',
    },
    el = {
      color = '#a374ea',
      cterm_color = '61',
      icon = vim.trim(icons.Elisp),
      name = 'Elisp',
    }
  },
  override_by_filename = {
    run_datasets = {
      color = '#65767a',
      cterm_color = '238',
      icon = vim.trim(icons.Sh),
      name = 'ShellRunDatasets',
    },
  },
})
