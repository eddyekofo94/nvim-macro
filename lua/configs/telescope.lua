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
    sorting_strategy = 'ascending',
    file_ignore_patterns = {
      '%.back$',
      '%.bak$',
      '%.bkp$',
      '%.bz2$',
      '%.directory$',
      '%.doc$',
      '%.docx$',
      '%.drawio$',
      '%.gif$',
      '%.git/',
      '%.gz$',
      '%.ico$',
      '%.ipynb$',
      '%.iso$',
      '%.jar$',
      '%.jpeg$',
      '%.jpg$',
      '%.mp3$',
      '%.mp4$',
      '%.o$',
      '%.otf$',
      '%.out$',
      '%.pdf$',
      '%.pickle$',
      '%.png$',
      '%.ppt$',
      '%.pptx$',
      '%.so$',
      '%.svg$',
      '%.tar$',
      '%.ttf$',
      '%.venv/',
      '%.xls$',
      '%.xlsx$',
      '%.zip$',
      '__pycache__/',
      'events%.out%.tfevents%.%d+',
      'node_modules/',
      'vendor/',
      'venv/',
      '~$',
    },
    mappings = {
      i = {
        ['<M-c>'] = actions.close,
        ['<M-s>'] = actions.select_horizontal,
        ['<M-v>'] = actions.select_vertical,
        ['<M-t>'] = actions.select_tab,
        ['<M-q>'] = actions.smart_add_to_qflist + actions.open_qflist,
        ['<M-l>'] = actions.smart_add_to_loclist + actions.open_loclist,
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
      },
    },
  },
  pickers = {
    colorscheme = { enable_preview = true },
    command_history = layout_dropdown,
    commands = layout_dropdown,
    filetypes = layout_dropdown,
    find_files = { hidden = true, follow = true },
    grep_string = { additional_args = { '--hidden' } },
    keymaps = layout_dropdown,
    live_grep = { additional_args = { '--hidden' } },
    lsp_definitions = { jump_type = 'never' },
    lsp_references = { include_current_line = true, jump_type = 'never' },
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
