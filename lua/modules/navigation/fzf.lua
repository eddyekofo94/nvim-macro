return {
  "ibhagwan/fzf-lua",
  cmd = {
    "FzfLua",
    "F",
    "Ls",
    "Args",
    "Tabs",
    "Tags",
    "Files",
    "Marks",
    "Jumps",
    "Autocmd",
    "Buffers",
    "Changes",
    "Display",
    "Oldfiles",
    "Registers",
    "Highlight",
  },
  keys = {
    -- "<Leader>.",
    "<Leader>,",
    -- '<Leader>/',
    "<Leader>?",
    '<Leader>"',
    -- '<Leader>o',
    -- "<Leader>'",
    -- "<Leader>-",
    -- "<Leader>=",
    "<Leader>R",
    "<Leader>F",
    "<Leader>f",
    "<Leader>ff",
    -- { "<Leader>*", mode = { "n", "x" } },
    { "<Leader>#", mode = { "n", "x" } },
  },
  event = "LspAttach",
  build = "fzf --version",
  init = vim.schedule_wrap(function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      local fzf_ui = require "fzf-lua.providers.ui_select"
      -- Register fzf as custom `vim.ui.select()` function if not yet
      -- registered
      if not fzf_ui.is_registered() then
        local _ui_select = fzf_ui.ui_select
        ---Overriding fzf-lua's default `ui_select()` function to use a
        ---custom prompt
        ---@diagnostic disable-next-line: duplicate-set-field
        fzf_ui.ui_select = function(items, opts, on_choice)
          -- Hack: use nbsp after ':' here because currently fzf-lua does
          -- not allow custom prompt and force substitute pattern ':%s?$'
          -- in `opts.prompt` to '> ' as the fzf prompt. We WANT the column
          -- in the prompt, so use nbsp to avoid this substitution.
          -- Also, don't use `opts.prompt:gsub(':?%s*$', ':\xc2\xa0')` here
          -- because it does a non-greedy match and will not substitute
          -- ':' at the end of the prompt, e.g. if `opts.prompt` is
          -- 'foobar: ' then result will be 'foobar: : ', interestingly
          -- this behavior changes in Lua 5.4, where the match becomes
          -- greedy, i.e. given the same string and substitution above the
          -- result becomes 'foobar> ' as expected.
          opts.prompt = opts.prompt and vim.fn.substitute(opts.prompt, ":\\?\\s*$", ":\xc2\xa0", "")
          _ui_select(items, opts, on_choice)
        end

        -- Use the register function provided by fzf-lua. We are using this
        -- wrapper instead of directly replacing `vim.ui.selct()` with fzf
        -- select function because in this way we can pass a callback to this
        -- `register()` function to generate fzf opts in different contexts,
        -- see https://github.com/ibhagwan/fzf-lua/issues/755
        -- Here we use the callback to achieve adaptive height depending on
        -- the number of items, with a max height of 10, the `split` option
        -- is basically the same as that used in fzf config file:
        -- lua/configs/fzf-lua.lua
        fzf_ui.register(function(_, items)
          return {
            winopts = {
              split = string.format(
                [[
                    let tabpage_win_list = nvim_tabpage_list_wins(0) |
                    \ call v:lua.require'utils.win'.saveheights(tabpage_win_list) |
                    \ call v:lua.require'utils.win'.saveviews(tabpage_win_list) |
                    \ unlet tabpage_win_list |
                    \ let g:_fzf_vim_lines = &lines |
                    \ let g:_fzf_leave_win = win_getid(winnr()) |
                    \ let g:_fzf_splitkeep = &splitkeep | let &splitkeep = "topline" |
                    \ let g:_fzf_cmdheight = &cmdheight | let &cmdheight = 0 |
                    \ let g:_fzf_laststatus = &laststatus | let &laststatus = 0 |
                    \ botright %dnew |
                    \ let w:winbar_no_attach = v:true |
                    \ setlocal bt=nofile bh=wipe nobl noswf wfh
                  ]],
                math.min(10 + vim.go.ch + (vim.go.ls == 0 and 0 or 1), #items + 1)
              ),
            },
          }
        end)
      end
      vim.ui.select(...)
    end
    vim.api.nvim_create_autocmd("CmdlineEnter", {
      group = vim.api.nvim_create_augroup("FzfLuaCreateCmdAbbr", {}),
      once = true,
      callback = function(info)
        local keymap = require "utils.keymap.keymaps"
        keymap.command_abbrev("ls", "Ls")
        keymap.command_abbrev("tabs", "Tabs")
        keymap.command_abbrev("tags", "Tags")
        keymap.command_abbrev("files", "Files")
        keymap.command_abbrev("marks", "Marks")
        keymap.command_abbrev("buffers", "Buffers")
        keymap.command_abbrev("changes", "Changes")
        keymap.command_abbrev({ "ar", "args" }, "Args")
        keymap.command_abbrev({ "ju", "jumps" }, "Jumps")
        keymap.command_abbrev({ "au", "autocmd" }, "Autocmd")
        keymap.command_abbrev({ "di", "display" }, "Display")
        keymap.command_abbrev({ "o", "oldfiles" }, "Oldfiles")
        keymap.command_abbrev({ "hi", "highlight" }, "Highlight")
        keymap.command_abbrev({ "reg", "registers" }, "Registers")
        vim.api.nvim_del_augroup_by_id(info.group)
        return true
      end,
    })
  end),
  config = function()
    require "modules.configs.fzf-lua"
  end,
}
