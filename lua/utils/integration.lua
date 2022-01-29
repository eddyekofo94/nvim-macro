local integration = {}

integration.tree_set_barbar = {

  open = function ()
    local bb_ready, bb_st = pcall(require, 'bufferline.state')
    local tree_ready, tree = pcall(require, 'nvim-tree')
    local tree_view_ready, tree_view = pcall(require, 'nvim-tree.view')
    if tree_ready then
      tree.open()
    end
    if bb_ready and tree_view_ready then
      bb_st.set_offset(tree_view.View.width + 1, 'NvimTree')
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
      bb_st.set_offset(tree_view.View.width + 1, 'NvimTree')
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
      bb_st.set_offset(tree_view.View.width + 1, 'NvimTree')
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
      bb_st.set_offset(tree_view.View.width + 1, 'NvimTree')
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
      bb_st.set_offset(tree_view.View.width + 1, 'NvimTree')
    end
  end,
}

return integration
