require('mason').setup({
  ui = {
    border = 'single',
    width = 0.7,
    height = 0.74,
    icons = {
      package_installed = '',
      package_pending = '',
      package_uninstalled = '',
    },
    keymaps = {
      -- Keymap to expand a package
      toggle_package_expand = '<Tab>',
      -- Keymap to uninstall a package
      uninstall_package = 'x',
    },
  },
})
