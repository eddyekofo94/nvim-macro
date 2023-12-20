return {
  {
    'kdheepak/lazygit.nvim',
    enabled = true,
    keys = {
      {
        '<leader>G',
        function()
          return vim.cmd([[LazyGit]])
        end,
        desc = 'Lazygit',
      },
    },
    event = 'VeryLazy',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
}
