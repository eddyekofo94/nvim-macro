return {
  'iamcco/markdown-preview.nvim',
  run = 'cd app && npm install',
  setup = function()
    vim.g.mkdp_filetypes = { 'markdown' }
    vim.g.mkdp_auto_close = 0
  end,
  ft = { 'markdown' }
}

-- Troubleshooting
-- If `MarkdownPreview` does not open the browser, find and run
-- '~/.local/share/nvim/site/pack/.../[opt/start]/markdown-preview.nvim/app/install.sh'
