local fn = vim.fn
local ls = require('luasnip')
local ls_types = require('luasnip.util.types')
local icons = require('utils.static').icons

local function lazy_load_snippets()
  local snippets_path
    = vim.split(fn.globpath(fn.stdpath('config') .. '/lua/snippets', '*.lua'), '\n')
  for _, path in ipairs(snippets_path) do
    local ft = fn.fnamemodify(path, ':t:r')
    vim.api.nvim_create_autocmd('FileType', {
      pattern = ft,
      once = true,
      callback = function()
        local snip_groups = require('snippets.' .. ft)
        for _, snip_group in pairs(snip_groups) do
          ls.add_snippets(ft, snip_group.snip or snip_group, snip_group.opts or {})
        end
      end
    })
  end
end

local function set_keymap()
  vim.keymap.set('s', '<Tab>', function() ls.jump(1) end, { noremap = false })
  vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end, { noremap = false })
  vim.keymap.set('s', '<C-n>', '<Plug>luasnip-next-choice', {})
  vim.keymap.set('s', '<C-p>', '<Plug>luasnip-prev-choice', {})
end

local function set_ls_region_check_autocmd()
  vim.api.nvim_create_autocmd('CursorMovedI', {
    pattern = '*',
    callback = function(ev)
      if not ls.session
        or not ls.session.current_nodes[ev.buf]
        or ls.session.jump_active
      then
        return
      end

      local current_node = ls.session.current_nodes[ev.buf]
      local current_start, current_end = current_node:get_buf_position()
      current_start[1] = current_start[1] + 1 -- (1, 0) indexed
      current_end[1] = current_end[1] + 1     -- (1, 0) indexed
      local cursor = vim.api.nvim_win_get_cursor(0)

      if (cursor[1] < current_start[1]
          or cursor[1] > current_end[1]
          or cursor[2] < current_start[2]
          or cursor[2] > current_end[2])
        or (current_start[1] == current_end[1]
            and current_start[2] == current_end[2]
            and current_node:get_jump_index() == 0)
      then
        ls.unlink_current()
      end
    end
  })
end

ls.setup({
  history = true,
  region_check_events = 'CursorMoved,CursorMovedI',
  delete_check_events = 'TextChanged,TextChangedI',
  update_events = 'TextChanged,TextChangedI,InsertLeave',
  enable_autosnippets = true,
  store_selection_keys = '<Tab>',
  ext_opts = {
    [ls_types.choiceNode] = {
      active = {
        virt_text = { { icons.Enum, 'Ochre' } },
      },
    },
    [ls_types.insertNode] = {
      active = {
        virt_text = { { icons.Snippet, 'Tea' } },
      },
    },
  },
})

lazy_load_snippets()
set_keymap()
set_ls_region_check_autocmd()
