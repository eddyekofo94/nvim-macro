local M = {}

M.mason = require('mason')

M.settings = {
  ui = {
    border = 'double',
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
}

M.mason.setup(M.settings)

return M
