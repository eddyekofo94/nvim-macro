local execute = vim.cmd

function Open()
  local bb_ready, bb_st = pcall(require, 'bufferline.state')
  local tree_ready, tree = pcall(require, 'nvim-tree')
  local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
  if tree_ready then
    tree.open()
  end
  if bb_ready and tree_view_ready then
    bb_st.set_offset(tree_view.View.width , 'NvimTree')
  end
end

function Close()
  local bb_ready, bb_st = pcall(require, 'bufferline.state')
  local tree_ready, tree = pcall(require, 'nvim-tree')
  if tree_ready then
    tree.close()
  end
  if bb_ready then
    bb_st.set_offset(0)
  end
end

function Toggle(find_file)
  local bb_ready, bb_st = pcall(require, 'bufferline.state')
  local tree_ready, tree = pcall(require, 'nvim-tree')
  local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
  if tree_ready then
    tree.toggle(find_file)
  end
  if bb_ready and tree_view_ready and tree_view.win_open() then
    bb_st.set_offset(tree_view.View.width , 'NvimTree')
  elseif bb_ready and tree_view_ready and not tree_view.win_open() then
    bb_st.set_offset(0)
  end
end

function Focus()
  local bb_ready, bb_st = pcall(require, 'bufferline.state')
  local tree_ready, tree = pcall(require, 'nvim-tree')
  local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
  if tree_ready then
    tree.focus()
  end
  if bb_ready and tree_view_ready then
    bb_st.set_offset(tree_view.View.width , 'NvimTree')
  end
end

function Resize(size)
  local bb_ready, bb_st = pcall(require, 'bufferline.state')
  local tree_ready, tree = pcall(require, 'nvim-tree')
  local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
  if tree_ready then
    tree.resize(size)
  end
  if tree_view_ready and tree_view.win_open() and bb_ready then
    bb_st.set_offset(tree_view.View.width , 'NvimTree')
  end
end

function Find_file(with_open)
  local bb_ready, bb_st = pcall(require, 'bufferline.state')
  local tree_ready, tree = pcall(require, 'nvim-tree')
  local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
  if tree_ready then
    tree.find_file(with_open)
  end
  if with_open and bb_ready and tree_view_ready and tree_view.win_open() then
    bb_st.set_offset(tree_view.View.width , 'NvimTree')
  end
end

execute
[[ command TC lua require('nvim-tree.actions.copy-paste').print_clipboard() ]]
execute
[[ command TQ lua Close()<CR> ]]
execute
[[ command TFF lua Find_file(true)<CR> ]]
execute
[[ command TFFT lua Toggle(true)<CR> ]]
execute
[[ command TF lua Focus()<CR> ]]
execute
[[ command TO lua Open()<CR> ]]
execute
[[ command TR lua Refresh()<CR> ]]
execute
[[ command -nargs=1 TS lua Resize(<args>) ]]
execute
[[ command TT lua Toggle(false) ]]

-- Refresh tree after opening new file or write to files
execute [[ autocmd BufEnter,BufAdd,BufWritePost * lua require('nvim-tree.lib').refresh_tree() ]]

local g = vim.g
g.nvim_tree_highlight_opened_files = 2
g.nvim_tree_indent_markers = 1
g.nvim_tree_icons = {
  git = {
    unstaged = 'M ',
    staged = 'S ',
    unmerged = 'C ',
    renamed = 'R ﰲ',
    deleted = 'D 﫧',
    untracked = 'U ',
    ignored = 'i '
  },
  lsp = {
    error = '',
    warn = '',
    hint = '',
    info = ''
  }
}

local tree_cb = require 'nvim-tree.config'.nvim_tree_callback
require 'nvim-tree'.setup {
  view = {
    auto_resize = true,
    mappings = {
      list = {
        { key = {'<CR>', 'o',
          '<2-LeftMouse>'},             cb = tree_cb('edit') },
        { key = {'<2-RightMouse>',
          '<C-]>'},                     cb = tree_cb('cd') },
        { key = '<C-[>',                cb = tree_cb('dir_up') },
        { key = '<M-v>',                cb = tree_cb('vsplit') },
        { key = '<M-x>',                cb = tree_cb('split') },
        { key = '<M-t>',                cb = tree_cb('tabnew') },
        { key = '<',                    cb = tree_cb('prev_sibling') },
        { key = '>',                    cb = tree_cb('next_sibling') },
        { key = 'P',                    cb = tree_cb('parent_node') },
        { key = '<BS>',                 cb = tree_cb('close_node') },
        { key = '<Tab>',                cb = tree_cb('preview') },
        { key = '{',                    cb = tree_cb('first_sibling') },
        { key = '}',                    cb = tree_cb('last_sibling') },
        { key = 'I',                    cb = tree_cb('toggle_ignored') },
        { key = 'H',                    cb = tree_cb('toggle_dotfiles') },
        { key = '<C-r>',                cb = tree_cb('refresh') },
        { key = 'a',                    cb = tree_cb('create') },
        { key = 'X',                    cb = tree_cb('remove') },
        { key = 'T',                    cb = tree_cb('trash') },
        { key = 'r',                    cb = tree_cb('rename') },
        { key = 'R',                    cb = tree_cb('full_rename') },
        { key = 'x',                    cb = tree_cb('cut') },
        { key = 'yy',                   cb = tree_cb('copy') },
        { key = 'p',                    cb = tree_cb('paste') },
        { key = 'yn',                   cb = tree_cb('copy_name') },
        { key = 'yp',                   cb = tree_cb('copy_path') },
        { key = 'yap',                  cb = tree_cb('copy_absolute_path') },
        { key = '[c',                   cb = tree_cb('prev_git_item') },
        { key = ']c',                   cb = tree_cb('next_git_item') },
        { key = 's',                    cb = tree_cb('system_open') },
        { key = 'q',                    cb = tree_cb('close') },
        { key = 'g?',                   cb = tree_cb('toggle_help') },
      }
    }
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      error = '',
      warning = '',
      hint = '',
      info = ''
    }
  },
}
