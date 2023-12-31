local Util = require('utils').telescope
return {
  {
    'nvim-telescope/telescope.nvim',
    lazy = false,
    keys = {
      -- {
      --   '<leader><space>',
      --   Util.telescope('files', { cwd = '%:p:h' }),
      --   desc = 'Find Files (current)',
      -- },
      {
        --  BUG: 2023-11-22 09:08 AM - This is somehow not working,
        -- it is listing the branches instead
        '<Leader>gwc',
        function()
          return require('telescope').extensions.git_worktree.create_git_worktree()
        end,
        desc = 'create worktree',
      },
      {
        '<Leader>gww',
        function()
          return require('telescope').extensions.git_worktree.git_worktrees()
        end,
        desc = 'Git worktree list',
      },
      {
        '<leader>sk',
        '<cmd>Telescope keymaps<cr>',
        desc = 'Keymaps',
      },
      {
        '<leader>st',
        '<cmd>Telescope help_tags<cr>',
        desc = 'Vim Help Tags',
      },
      {
        '<leader>:',
        '<cmd>Telescope command_history<cr>',
        desc = 'Command History',
      },
      -- {
      --   '<leader>p',
      --   Util.telescope('files'),
      --   desc = 'Find Files (root dir)',
      -- },
      -- {
      --   '<leader>sF',
      --   Util.telescope('files', { cwd = false }),
      --   desc = 'Find Files (cwd)',
      -- },
      -- {
      --   '<leader>ss',
      --   Util.telescope('live_grep'),
      --   desc = 'Live Grep (root dir)',
      -- },
      -- {
      --   '<leader>sH',
      --   Util.telescope('live_grep', { cwd = false }),
      --   desc = 'Live Grep (cwd)',
      -- },
      -- {
      --   '<leader>sg',
      --   Util.telescope('grep_string'),
      --   desc = 'Grep String (root dir)',
      --   mode = {
      --     'n',
      --     'x',
      --   },
      -- },
      { 'sk', '<cmd>Telescope keymaps<cr>', desc = 'Keymaps' },
      -- {
      --   '<leader>sG',
      --   Util.telescope('grep_string', { cwd = false }),
      --   desc = 'Grep String',
      --   mode = {
      --     'n',
      --     'x',
      --   },
      -- },
      -- Git
      {
        '<leader>sx',
        '<cmd>Telescope git_status<cr>',
        desc = 'Open changed file',
      },
      {
        '<leader>sB',
        '<cmd>Telescope git_branches<cr>',
        desc = 'Checkout branch',
      },
      {
        '<leader>so',
        '<cmd>Telescope git_commits<cr>',
        desc = 'Checkout commit',
      },
      {
        '<leader>sh',
        '<cmd>Telescope harpoon marks<cr>',
        desc = 'Harpoon menu',
      },
      {

        '<leader>sR',
        '<cmd>Telescope oldfiles<cr>',
        desc = 'Recent File',
      },
      {
        '<leader>sr',
        '<cmd>Telescope resume<cr>',
        desc = 'Resume search',
      },
      { '<leader>sS', '<cmd>Telescope persisted<cr>', desc = 'Sessions' },
      { '<leader>g.', '<cmd>Telescope git_status<cr>', desc = 'git status' },
    },
    dependencies = {
      'nvim-lua/popup.nvim',
      'nvim-lua/plenary.nvim',
      -- {
      --   "jay-babu/mason-nvim-dap.nvim",
      --   config = function()
      --     require("telescope").load_extension("dap")
      --   end,
      -- },
      {

        'ThePrimeagen/git-worktree.nvim',
        config = function()
          require('telescope').load_extension('git_worktree')
        end,
      },
      {
        'nvim-telescope/telescope-fzy-native.nvim',
        config = function()
          require('telescope').load_extension('fzy_native')
        end,
      },
      {
        'nvim-telescope/telescope-project.nvim',
        config = function()
          require('telescope').load_extension('project')
        end,
      },
      -- {
      --   "nvim-telescope/telescope-frecency.nvim",
      --   config = function()
      --     require("telescope").load_extension("frecency")
      --   end,
      -- },
      {
        'jvgrootveld/telescope-zoxide',
        config = function()
          require('telescope').load_extension('zoxide')
        end,
      },
      'tami5/sql.nvim',
    },
    version = false, -- telescope did only one release, so use HEAD for now
    config = function()
      local cfg_telescope = require('telescope')
      local actions = require('telescope.actions')

      -- cfg_telescope.load_extension("git_worktree")

      cfg_telescope.setup({
        defaults = {
          vimgrep_arguments = {
            'rg',
            '-L',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
          },
          prompt_prefix = '   ',
          selection_caret = '  ',
          path_display = { 'truncate' },
          selection_strategy = 'reset',
          initial_mode = 'insert',
          sorting_strategy = 'ascending',
          layout_strategy = 'horizontal',
          layout_config = {
            horizontal = {
              prompt_position = 'top',
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          pickers = {
            buffers = {
              sort_mru = true,
              ignore_current_buffer = true,
              mappings = {
                i = {
                  ['<c-d>'] = 'delete_buffer', -- this overrides the built in preview scroller
                  ['<c-b>'] = 'preview_scrolling_down',
                },
                n = {
                  ['<c-d>'] = 'delete_buffer', -- this overrides the built in preview scroller
                  ['<c-b>'] = 'preview_scrolling_down',
                },
              },
            },
          },
          scroll_strategy = 'cycle',
          dynamic_preview_title = true,
          file_sorter = require('telescope.sorters').get_fzy_sorter, -- TODO: find a better file sorter (if possible)
          generic_sorter = require('telescope.sorters').fuzzy_with_index_bias,
          winblend = 0, -- transparency
          use_less = true,
          set_env = { ['COLORTERM'] = 'truecolor' }, -- default { }, currently unsupported for shells like cmd.exe / powershell.exe
          file_previewer = require('telescope.previewers').vim_buffer_cat.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_cat.new`
          grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_vimgrep.new`
          qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new, -- For buffer previewer use `require'telescope.previewers'.vim_buffer_qflist.new`
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['<esc>'] = actions.close,
              ['<C-x>'] = actions.select_horizontal,
              ['<C-v>'] = actions.select_vertical,
              ['<C-Down>'] = require('telescope.actions').cycle_history_next,
              ['<C-Up>'] = require('telescope.actions').cycle_history_prev,
              ['<C-t>'] = actions.select_tab,
              ['<C-f>'] = actions.preview_scrolling_down,
              ['<C-b>'] = actions.preview_scrolling_up,
              -- Add up multiple actions
              ['<CR>'] = actions.select_default + actions.center,
              ['<a-i>'] = function()
                Util.telescope('find_files', { no_ignore = true })()
              end,
              ['<a-h>'] = function()
                Util.telescope('find_files', { hidden = true })()
              end,
            },
            n = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['H'] = actions.move_to_top,
              ['M'] = actions.move_to_middle,
              ['L'] = actions.move_to_bottom,
              ['gg'] = actions.move_to_top,
              ['G'] = actions.move_to_bottom,
              ['q'] = actions.close,
            },
          },
          extensions_list = { 'zoxide', 'projects', 'themes', 'fzf' },
          extensions = {
            fzf = {
              fuzzy = true,
              override_generic_sorter = true,
              override_file_sorter = true,
              case_mode = 'smart_case',
            },
          },
        },
      })

      -- local styles = {
      --   borderless = {
      --     TelescopeBorder = { fg = colors.darker_black, bg = colors.darker_black },
      --     TelescopePromptBorder = { fg = colors.black2, bg = colors.black2 },
      --     TelescopePromptNormal = { fg = colors.white, bg = colors.black2 },
      --     TelescopeResultsTitle = { fg = colors.darker_black, bg = colors.darker_black },
      --     TelescopePromptPrefix = { fg = colors.red, bg = colors.black2 },
      --   }
    end,
  },
}
