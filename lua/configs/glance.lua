local glance = require('glance')
local actions = glance.actions
local utils = require('utils')
local horiz = vim.opt.fillchars:get().horiz

glance.setup({
  height = 16,
  detached = function(win)
    return vim.api.nvim_win_get_width(win) < 80
  end,
  folds = {
    fold_closed = utils.static.icons.AngleRight,
    fold_open = utils.static.icons.AngleDown,
  },
  indent_lines = {
    enable = true,
    icon = ' ',
  },
  theme = {
    enable = false,
  },
  border = {
    enable = true,
    top_char = horiz,
    bottom_char = horiz,
  },
  hooks = {
    before_open = function(results, open, jump)
      if #results == 0 then
        vim.notify('[glance.nvim] no results found', vim.log.levels.INFO)
        return
      end
      if #results > 1 then
        open(results)
        return
      end
      -- Only one result
      vim.notify('[glance.nvim] only one result found', vim.log.levels.INFO)
      jump(results[1])
    end,
  },
  mappings = {
    ---@type table<string, function|boolean|string>
    list = {
      ['j'] = utils.keymap.count_wrap(actions.next),
      ['k'] = utils.keymap.count_wrap(actions.previous),
      ['<Down>'] = utils.keymap.count_wrap(actions.next),
      ['<Up>'] = utils.keymap.count_wrap(actions.previous),
      ['<C-n>'] = utils.keymap.count_wrap(actions.next_location),
      ['<C-p>'] = utils.keymap.count_wrap(actions.previous_location),
      ['<C-u>'] = actions.preview_scroll_win(5),
      ['<C-d>'] = actions.preview_scroll_win(-5),
      ['<C-f>'] = actions.preview_scroll_win(10),
      ['<C-b>'] = actions.preview_scroll_win(-10),
      ['<S-Up>'] = actions.preview_scroll_win(5),
      ['<S-Down>'] = actions.preview_scroll_win(-5),
      ['<M-v>'] = actions.jump_vsplit,
      ['<C-v>'] = actions.jump_vsplit,
      ['<M-s>'] = actions.jump_split,
      ['<C-s>'] = actions.jump_split,
      ['<M-t>'] = actions.jump_tab,
      ['<C-t>'] = actions.jump_tab,
      ['<M-q>'] = actions.quickfix,
      ['<C-q>'] = actions.quickfix,
      ['zo'] = actions.open_fold,
      ['zc'] = actions.close_fold,
      ['za'] = actions.toggle_fold,
      ['<Tab>'] = actions.toggle_fold,
      ['<CR>'] = actions.jump,
      ['<C-w><C-h>'] = actions.enter_win('preview'),
      ['<C-w><C-p>'] = actions.enter_win('preview'),
      ['<C-w><C-w>'] = actions.enter_win('preview'),
      ['<C-w>h'] = actions.enter_win('preview'),
      ['<C-w>p'] = actions.enter_win('preview'),
      ['<C-w>w'] = actions.enter_win('preview'),
      ['<M-h>'] = actions.enter_win('preview'),
      ['<M-p>'] = actions.enter_win('preview'),
      ['<M-w>'] = actions.enter_win('preview'),
      ['<C-w>+'] = '<Ignore>',
      ['<C-w>,'] = '<Ignore>',
      ['<C-w>-'] = '<Ignore>',
      ['<C-w>.'] = '<Ignore>',
      ['<C-w><'] = '<Ignore>',
      ['<C-w><C-j>'] = '<Ignore>',
      ['<C-w><C-k>'] = '<Ignore>',
      ['<C-w><C-l>'] = '<Ignore>',
      ['<C-w><C-s>'] = '<Ignore>',
      ['<C-w><C-v>'] = '<Ignore>',
      ['<C-w>>'] = '<Ignore>',
      ['<C-w>_'] = '<Ignore>',
      ['<C-w>j'] = '<Ignore>',
      ['<C-w>k'] = '<Ignore>',
      ['<C-w>l'] = '<Ignore>',
      ['<C-w>s'] = '<Ignore>',
      ['<C-w>v'] = '<Ignore>',
      ['<C-w>|'] = '<Ignore>',
      ['<M-+>'] = '<Ignore>',
      ['<M-,>'] = '<Ignore>',
      ['<M-->'] = '<Ignore>',
      ['<M-.>'] = '<Ignore>',
      ['<M-<>'] = '<Ignore>',
      ['<M->>'] = '<Ignore>',
      ['<M-_>'] = '<Ignore>',
      ['<M-j>'] = '<Ignore>',
      ['<M-k>'] = '<Ignore>',
      ['<M-l>'] = '<Ignore>',
      ['<M-|>'] = '<Ignore>',
      ['q'] = actions.close,
      ['<S-Tab>'] = false,
      ['v'] = false,
      ['s'] = false,
      ['t'] = false,
      ['l'] = false,
      ['h'] = false,
      ['Q'] = false,
      ['o'] = false,
      ['<Leader>l'] = false,
    },
    ---@type table<string, function|boolean|string>
    preview = {
      ['q'] = actions.close,
      ['<C-n>'] = utils.keymap.count_wrap(actions.next_location),
      ['<C-p>'] = utils.keymap.count_wrap(actions.previous_location),
      ['<C-w><C-l>'] = actions.enter_win('list'),
      ['<C-w><C-p>'] = actions.enter_win('list'),
      ['<C-w><C-w>'] = actions.enter_win('list'),
      ['<C-w>l'] = actions.enter_win('list'),
      ['<C-w>p'] = actions.enter_win('list'),
      ['<C-w>w'] = actions.enter_win('list'),
      ['<M-l>'] = actions.enter_win('list'),
      ['<M-p>'] = actions.enter_win('list'),
      ['<M-w>'] = actions.enter_win('list'),
      ['<C-w>+'] = '<Ignore>',
      ['<C-w>,'] = '<Ignore>',
      ['<C-w>-'] = '<Ignore>',
      ['<C-w>.'] = '<Ignore>',
      ['<C-w><'] = '<Ignore>',
      ['<C-w><C-h>'] = '<Ignore>',
      ['<C-w><C-j>'] = '<Ignore>',
      ['<C-w><C-k>'] = '<Ignore>',
      ['<C-w><C-s>'] = '<Ignore>',
      ['<C-w><C-v>'] = '<Ignore>',
      ['<C-w>>'] = '<Ignore>',
      ['<C-w>_'] = '<Ignore>',
      ['<C-w>h'] = '<Ignore>',
      ['<C-w>j'] = '<Ignore>',
      ['<C-w>k'] = '<Ignore>',
      ['<C-w>s'] = '<Ignore>',
      ['<C-w>v'] = '<Ignore>',
      ['<C-w>|'] = '<Ignore>',
      ['<M-+>'] = '<Ignore>',
      ['<M-,>'] = '<Ignore>',
      ['<M-->'] = '<Ignore>',
      ['<M-.>'] = '<Ignore>',
      ['<M-<>'] = '<Ignore>',
      ['<M->>'] = '<Ignore>',
      ['<M-_>'] = '<Ignore>',
      ['<M-h>'] = '<Ignore>',
      ['<M-j>'] = '<Ignore>',
      ['<M-k>'] = '<Ignore>',
      ['<M-s>'] = '<Ignore>',
      ['<M-v>'] = '<Ignore>',
      ['<M-|>'] = '<Ignore>',
      ['Q'] = false,
      ['<Tab>'] = false,
      ['<S-Tab>'] = false,
      ['<Leader>l'] = false,
    },
  },
})

---@return nil
local function set_default_hlgroups()
  utils.hl.set(0, 'GlanceBorderTop', { link = 'WinSeparator' })
  utils.hl.set(0, 'GlancePreviewBorderBottom', { link = 'GlanceBorderTop' })
  utils.hl.set(0, 'GlanceListBorderBottom', { link = 'GlanceBorderTop' })
end

set_default_hlgroups()

vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('GlanceSetDefaultHlgroups', {}),
  desc = 'Set default hlgroups for glance.nvim.',
  callback = set_default_hlgroups,
})

---@diagnostic disable: duplicate-set-field
-- Override LSP handler functions
-- stylua: ignore start
vim.lsp.buf.references = function() glance.open('references') end
vim.lsp.buf.definition = function() glance.open('definitions') end
vim.lsp.buf.type_definition = function() glance.open('type_definitions') end
vim.lsp.buf.implementations = function() glance.open('implementations') end
-- stylua: ignore end
---@diagnostic enable: duplicate-set-field
