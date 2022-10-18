return {
  'zbirenbaum/copilot-cmp',
  after = 'copilot.lua',
  requires ={
    require('plugin-specs.nvim-cmp'),
    require('plugin-specs.copilot')
  },
  config = function() require('copilot_cmp').setup() end
}
