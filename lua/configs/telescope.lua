local telescope = require('telescope')
local builtin = require('telescope.builtin')
local actions = require('telescope.actions')
local static = require('utils.static')

---Record buffers whose LSP clients are ready for 'textDocument/documentSymbol'
---requests
---@type table<integer, boolean>
local buf_client_ready = {}

vim.api.nvim_create_autocmd('LspDetach', {
  group = vim.api.nvim_create_augroup('TelescopeClearBufClientCache', {}),
  callback = function(info)
    buf_client_ready[info.buf] = nil
  end,
  desc = 'Clear buf_client_ready cache on LspDetach.',
})

---Override builtin.lsp_document_symbols, builtin.lsp_workspace_symbols, and
---builtin.lsp_dynamic_workspace_symbols to fallback to use treesitter picker
---if the language server is not ready
---@param name string
---@param lsp_method string
local function override_lsp_picker(name, lsp_method)
  local orig_picker = builtin[name]
  builtin[name] = function(...)
    local buf = vim.api.nvim_get_current_buf()
    if buf_client_ready[buf] then
      orig_picker(...)
      return
    end
    local client = vim.tbl_filter(
      function(client)
        return client.supports_method(lsp_method)
      end,
      vim.lsp.get_clients({
        bufnr = buf,
      })
    )[1]
    if not client then
      builtin.treesitter(...)
      return
    end
    local client_ok = client.request_sync(lsp_method, {
      textDocument = vim.lsp.util.make_text_document_params(buf),
    }, 32, buf)
    if client_ok then
      buf_client_ready[buf] = true
      orig_picker(...)
    else
      builtin.treesitter(...)
    end
  end
end

override_lsp_picker('lsp_document_symbols', 'textDocument/documentSymbol')
override_lsp_picker('lsp_workspace_symbols', 'workspace/symbol')
override_lsp_picker('lsp_dynamic_workspace_symbols', 'workspace/symbol')

-- stylua: ignore start
vim.keymap.set('n', '<Leader>F',  function() builtin.builtin() end)
vim.keymap.set('n', '<Leader>f',  function() builtin.builtin() end)
vim.keymap.set('n', '<Leader>ff', function() builtin.find_files() end)
vim.keymap.set('n', '<Leader>fo', function() builtin.oldfiles() end)
vim.keymap.set('n', '<Leader>f;', function() builtin.live_grep() end)
vim.keymap.set('n', '<Leader>f:', function() builtin.commands() end)
vim.keymap.set('n', '<Leader>fq', function() builtin.command_history() end)
vim.keymap.set('n', '<Leader>f*', function() builtin.grep_string() end)
vim.keymap.set('n', '<Leader>fh', function() builtin.help_tags() end)
vim.keymap.set('n', '<Leader>f/', function() builtin.current_buffer_fuzzy_find() end)
vim.keymap.set('n', '<Leader>fb', function() builtin.buffers() end)
vim.keymap.set('n', '<Leader>fr', function() builtin.lsp_references() end)
vim.keymap.set('n', '<Leader>fd', function() builtin.lsp_definitions() end)
vim.keymap.set('n', '<Leader>fD', function() builtin.lsp_type_definitions() end)
vim.keymap.set('n', '<Leader>fe', function() builtin.diagnostics() end)
vim.keymap.set('n', '<Leader>fp', function() builtin.treesitter() end)
vim.keymap.set('n', '<Leader>fs', function() builtin.lsp_document_symbols() end)
vim.keymap.set('n', '<Leader>fS', function() builtin.lsp_workspace_symbols() end)
vim.keymap.set('n', '<Leader>fg', function() builtin.git_status() end)
vim.keymap.set('n', '<Leader>fm', function() builtin.marks() end)
vim.keymap.set('n', '<Leader>fu', function() telescope.extensions.undo.undo() end)
vim.keymap.set('n', '<Leader>f<Esc>', '<Ignore>')
-- stylua: ignore end

-- Workaround for nvim-telescope/telescope.nvim #2501
-- to prevent opening files in insert mode
vim.api.nvim_create_autocmd('WinLeave', {
  group = vim.api.nvim_create_augroup('TelescopeConfig', {}),
  callback = function(info)
    if
      vim.bo[info.buf].ft == 'TelescopePrompt'
      and vim.startswith(vim.fn.mode(), 'i')
    then
      vim.api.nvim_feedkeys(
        vim.api.nvim_replace_termcodes('<Esc>', true, false, true),
        'in',
        false
      )
    end
  end,
})

-- Mimic fzf.vim's :FZF command
vim.api.nvim_create_user_command('FZF', function(info)
  builtin.find_files({ cwd = info.fargs[1] })
end, {
  nargs = '?',
  complete = 'dir',
  desc = 'Fuzzy find files.',
})

-- Dropdown layout for telescope
local layout_dropdown = {
  previewer = false,
  layout_config = {
    width = 0.65,
    height = 0.65,
  },
}

telescope.setup({
  defaults = {
    prompt_prefix = '/ ',
    selection_caret = static.icons.ArrowRight,
    borderchars = static.borders.empty,
    dynamic_preview_title = true,
    layout_strategy = 'flex',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        width = 0.8,
        height = 0.8,
        preview_width = 0.5,
      },
      vertical = {
        prompt_position = 'top',
        width = 0.8,
        height = 0.8,
        mirror = true,
      },
    },
    vimgrep_arguments = {
      'rg',
      '--hidden',
      '--vimgrep',
      '--column',
      '--line-number',
      '--smart-case',
      '--with-filename',
      '--no-heading',
      '--color=never',
      '-g=!*$*',
      '-g=!*%*',
      '-g=!*.bkp',
      '-g=!*.bz2',
      '-g=!*.db',
      '-g=!*.directory',
      '-g=!*.dll',
      '-g=!*.doc',
      '-g=!*.docx',
      '-g=!*.drawio',
      '-g=!*.gif',
      '-g=!*.git/',
      '-g=!*.gz',
      '-g=!*.ico',
      '-g=!*.ipynb',
      '-g=!*.iso',
      '-g=!*.jar',
      '-g=!*.jpeg',
      '-g=!*.jpg',
      '-g=!*.mp3',
      '-g=!*.mp4',
      '-g=!*.o',
      '-g=!*.otf',
      '-g=!*.out',
      '-g=!*.pdf',
      '-g=!*.pickle',
      '-g=!*.png',
      '-g=!*.ppt',
      '-g=!*.pptx',
      '-g=!*.pyc',
      '-g=!*.rar',
      '-g=!*.so',
      '-g=!*.svg',
      '-g=!*.tar',
      '-g=!*.ttf',
      '-g=!*.venv/',
      '-g=!*.xls',
      '-g=!*.xlsx',
      '-g=!*.zip',
      '-g=!*Cache*/',
      '-g=!*\\~',
      '-g=!*cache*/',
      '-g=!.*Cache*/',
      '-g=!.*cache*/',
      '-g=!.*wine/',
      '-g=!.cargo/',
      '-g=!.conda/',
      '-g=!.dot/',
      '-g=!.fonts/',
      '-g=!.ipython/',
      '-g=!.java/',
      '-g=!.jupyter/',
      '-g=!.luarocks/',
      '-g=!.mozilla/',
      '-g=!.npm/',
      '-g=!.nvm/',
      '-g=!.steam*/',
      '-g=!.thunderbird/',
      '-g=!.tmp/',
      '-g=!__pycache__/',
      '-g=!dosdevices/',
      '-g=!events.out.tfevents.*',
      '-g=!node_modules/',
      '-g=!vendor/',
      '-g=!venv/',
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<M-c>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
        ['<M-l>'] = actions.smart_add_to_loclist + actions.open_loclist,
        ['<S-up>'] = actions.preview_scrolling_up,
        ['<S-down>'] = actions.preview_scrolling_down,
        ['<C-f>'] = false,
        ['<C-d>'] = false,
        ['<C-a>'] = false,
        ['<C-e>'] = false,
        ['<C-y>'] = false,
        ['<C-b>'] = false,
        ['<C-k>'] = false,
        ['<M-b>'] = false,
        ['<C-t>'] = false,
        ['<C-u>'] = false,
        ['<M-f>'] = false,
        ['<M-d>'] = false,
        ['<C-BS>'] = false,
        ['<M-BS>'] = false,
        ['<M-Del>'] = false,
      },

      n = {
        ['q'] = actions.close,
        ['<esc>'] = actions.close,
        ['<C-n>'] = actions.move_selection_next,
        ['<C-p>'] = actions.move_selection_previous,
        ['<M-c>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
        ['<M-l>'] = actions.smart_add_to_loclist + actions.open_loclist,
        ['<S-up>'] = actions.preview_scrolling_up,
        ['<S-down>'] = actions.preview_scrolling_down,
      },
    },
  },
  pickers = {
    colorscheme = { enable_preview = true },
    command_history = layout_dropdown,
    commands = layout_dropdown,
    filetypes = layout_dropdown,
    find_files = {
      find_command = {
        'fd',
        '-p',
        '-H',
        '-L',
        '-tf',
        '-tl',
        '-d10',
        '--mount',
        '-c=never',
        '-E=*$*',
        '-E=*%*',
        '-E=*.bkp',
        '-E=*.bz2',
        '-E=*.db',
        '-E=*.directory',
        '-E=*.dll',
        '-E=*.doc',
        '-E=*.docx',
        '-E=*.drawio',
        '-E=*.gif',
        '-E=*.git/',
        '-E=*.gz',
        '-E=*.ico',
        '-E=*.ipynb',
        '-E=*.iso',
        '-E=*.jar',
        '-E=*.jpeg',
        '-E=*.jpg',
        '-E=*.mp3',
        '-E=*.mp4',
        '-E=*.o',
        '-E=*.otf',
        '-E=*.out',
        '-E=*.pdf',
        '-E=*.pickle',
        '-E=*.png',
        '-E=*.ppt',
        '-E=*.pptx',
        '-E=*.pyc',
        '-E=*.rar',
        '-E=*.so',
        '-E=*.svg',
        '-E=*.tar',
        '-E=*.ttf',
        '-E=*.venv/',
        '-E=*.xls',
        '-E=*.xlsx',
        '-E=*.zip',
        '-E=*Cache*/',
        '-E=*~',
        '-E=*cache*/',
        '-E=.*Cache*/',
        '-E=.*cache*/',
        '-E=.*wine/',
        '-E=.cargo/',
        '-E=.conda/',
        '-E=.dot/',
        '-E=.fonts/',
        '-E=.ipython/',
        '-E=.java/',
        '-E=.jupyter/',
        '-E=.luarocks/',
        '-E=.mozilla/',
        '-E=.npm/',
        '-E=.nvm/',
        '-E=.steam*/',
        '-E=.thunderbird/',
        '-E=.tmp/',
        '-E=__pycache__/',
        '-E=dosdevices/',
        '-E=events.out.tfevents.*',
        '-E=node_modules/',
        '-E=vendor/',
        '-E=venv/',
      },
    },
    grep_string = { additional_args = { '--hidden' } },
    keymaps = layout_dropdown,
    live_grep = {
      additional_args = { '--hidden' },
      mappings = {
        i = {
          ['<C-/>'] = actions.to_fuzzy_refine,
          ['<C-_>'] = actions.to_fuzzy_refine,
        },
        n = {
          ['<C-/>'] = actions.to_fuzzy_refine,
          ['<C-_>'] = actions.to_fuzzy_refine,
        },
      },
    },
    lsp_definitions = { jump_type = 'never' },
    lsp_dynamic_workspace_symbols = {
      mappings = {
        i = {
          ['<C-/>'] = actions.to_fuzzy_refine,
          ['<C-_>'] = actions.to_fuzzy_refine,
        },
        n = {
          ['<C-/>'] = actions.to_fuzzy_refine,
          ['<C-_>'] = actions.to_fuzzy_refine,
        },
      },
    },
    lsp_references = {
      include_current_line = true,
      jump_type = 'never',
    },
    lsp_type_definitions = { jump_type = 'never' },
    registers = layout_dropdown,
    reloader = layout_dropdown,
    search_history = layout_dropdown,
    spell_suggest = layout_dropdown,
    vim_options = layout_dropdown,
  },
  extensions = {
    undo = {
      use_delta = true,
      mappings = {
        i = {
          ['<CR>'] = require('telescope-undo.actions').restore,
        },
        n = {
          ['<CR>'] = require('telescope-undo.actions').restore,
          ['ya'] = require('telescope-undo.actions').yank_additions,
          ['yd'] = require('telescope-undo.actions').yank_deletions,
        },
      },
    },
  },
})

-- load telescope extensions
if
  not vim.tbl_isempty(vim.fs.find({ 'libfzf.so' }, {
    path = vim.g.package_path,
    type = 'file',
  }))
then
  telescope.load_extension('fzf')
else
  vim.notify_once('[telescope] libfzf.so not found', vim.log.levels.WARN)
end
telescope.load_extension('undo')
