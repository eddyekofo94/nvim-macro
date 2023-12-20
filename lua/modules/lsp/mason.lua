return {
  {
    'williamboman/mason.nvim',
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local ensure_installed = {
        'eslint',
        'jsonls',
        'marksman',
        'lua_ls',
        'vimls',
        'rust_analyzer',
        'yamlls',
        'gopls',
        'pylsp',
        'clangd',
        'bashls',
        'sqlls',
        'cmake',
        'glint',
        'dockerls',
      }
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = ensure_installed,
      })
    end,
  },
}
