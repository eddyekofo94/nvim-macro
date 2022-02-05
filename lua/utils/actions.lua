local M = {}

M.tree_set_barbar = {

  open = function ()
    local bb_ready, bb_st = pcall(require, 'bufferline.state')
    local tree_ready, tree = pcall(require, 'nvim-tree')
    local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
    if tree_ready then
      tree.open()
    end
    if bb_ready and tree_view_ready then
      bb_st.set_offset(tree_view.View.width , 'NvimTree')
    end
  end,

  close = function ()
    local bb_ready, bb_st = pcall(require, 'bufferline.state')
    local tree_ready, tree = pcall(require, 'nvim-tree')
    if tree_ready then
      tree.close()
    end
    if bb_ready then
      bb_st.set_offset(0)
    end
  end,

  toggle = function (find_file)
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
  end,

  focus = function ()
    local bb_ready, bb_st = pcall(require, 'bufferline.state')
    local tree_ready, tree = pcall(require, 'nvim-tree')
    local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
    if tree_ready then
      tree.focus()
    end
    if bb_ready and tree_view_ready then
      bb_st.set_offset(tree_view.View.width , 'NvimTree')
    end
  end,

  resize = function (size)
    local bb_ready, bb_st = pcall(require, 'bufferline.state')
    local tree_ready, tree = pcall(require, 'nvim-tree')
    local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
    if tree_ready then
      tree.resize(size)
    end
    if tree_view_ready and tree_view.win_open() and bb_ready then
      bb_st.set_offset(tree_view.View.width , 'NvimTree')
    end
  end,

  find_file = function (with_open)
    local bb_ready, bb_st = pcall(require, 'bufferline.state')
    local tree_ready, tree = pcall(require, 'nvim-tree')
    local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
    if tree_ready then
      tree.find_file(with_open)
    end
    if with_open and bb_ready and tree_view_ready and tree_view.win_open() then
      bb_st.set_offset(tree_view.View.width , 'NvimTree')
    end
  end,
}

M.win = {
  -- From https://github.com/wookayin/dotfiles/commit/96d935515486f44ec361db3df8ab9ebb41ea7e40
  close_all_floatings = function ()
    local closed_windows = {}
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local config = vim.api.nvim_win_get_config(win)
      if config.relative ~= "" then         -- is_floating_window?
        vim.api.nvim_win_close(win, false)  -- do not force
        table.insert(closed_windows, win)
      end
    end
    print(string.format ('Closed %d windows: %s', #closed_windows,
                         vim.inspect(closed_windows)))
  end
}

return M
