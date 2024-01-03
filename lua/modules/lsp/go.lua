-- local icons = require("utils.icons")
local set_keymap = require("utils.keymap").set_keymap
local go_cfg = require("go")

-- INFO: don't know if this is working :(
set_keymap(
  "n",
  "<leader>f",
  "<cmd>lua require('go.format').goimport()<CR>",
  { desc = "Format" }
)
-- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "go",
  callback = function()
    require("go.format").goimport()
  end,
  group = format_sync_grp,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "go",
  callback = function()
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeimports" } },
      apply = true,
    })
  end,
})

go_cfg.setup({

  disable_defaults = false, -- true|false when true set false to all boolean settings and replace all table
  -- settings with {}
  go = "go", -- go command, can be go[default] or go1.18beta1
  goimport = "gopls", -- goimport command, can be gopls[default] or goimport
  fillstruct = "gopls", -- can be nil (use fillstruct, slower) and gopls
  gofmt = "gofumpt", --gofmt cmd,
  max_line_len = 128, -- max line length in golines format, Target maximum line length for golines
  tag_transform = false, -- can be transform option("snakecase", "camelcase", etc) check gomodifytags for details and more options
  tag_options = "json=omitempty", -- sets options sent to gomodifytags, i.e., json=omitempty
  gotests_template = "", -- sets gotests -template parameter (check gotests for details)
  gotests_template_dir = "", -- sets gotests -template_dir parameter (check gotests for details)
  comment_placeholder = "", -- comment_placeholder your cool placeholder e.g. 󰟓       
  icons = { breakpoint = "", currentpos = "🏃" }, -- setup to `false` to disable icons setup
  verbose = false, -- output loginf in messages
  lsp_cfg = true, -- true: use non-default gopls setup specified in go/lsp.lua

  -- false: do nothing
  -- if lsp_cfg is a table, merge table with with non-default gopls setup in go/lsp.lua, e.g.
  --   lsp_cfg = {settings={gopls={matcher='CaseInsensitive', ['local'] = 'your_local_module_path', gofumpt = true }}}
  lsp_gofumpt = false, -- true: set default gofmt in gopls format to gofumpt
  lsp_on_attach = function(client, bufnr)
    -- attach my LSP configs keybindings
    require("plugins.lsp.keys").on_attach(client, bufnr)
    local wk = require("which-key")
    local default_options = { silent = true }
    wk.register({
      c = {
        name = "Coding",
        a = { "<cmd>GoCodeAction<cr>", "Code action" },
        e = { "<cmd>GoIfErr<cr>", "Add if err" },
        h = {
          name = "Helper",
          a = { "<cmd>GoAddTag<cr>", "Add tags to struct" },
          r = { "<cmd>GoRMTag<cr>", "Remove tags to struct" },
          c = { "<cmd>GoCoverage<cr>", "Test coverage" },
          g = {
            "<cmd>lua require('go.comment').gen()<cr>",
            "Generate comment",
          },
          v = { "<cmd>GoVet<cr>", "Go vet" },
          t = { "<cmd>GoModTidy<cr>", "Go mod tidy" },
          i = { "<cmd>GoModInit<cr>", "Go mod init" },
        },
        i = { "<cmd>GoToggleInlay<cr>", "Toggle inlay" },
        l = { "<cmd>GoLint<cr>", "Run linter" },
        o = { "<cmd>GoPkgOutline<cr>", "Outline" },
        r = { "<cmd>GoRun<cr>", "Run" },
        s = { "<cmd>GoFillStruct<cr>", "Autofill struct" },
        t = {
          name = "Tests",
          r = { "<cmd>GoTest<cr>", "Run tests" },
          a = { "<cmd>GoAlt!<cr>", "Open alt file" },
          s = { "<cmd>GoAltS!<cr>", "Open alt file in split" },
          v = { "<cmd>GoAltV!<cr>", "Open alt file in vertical split" },
          u = { "<cmd>GoTestFunc<cr>", "Run test for current func" },
          f = { "<cmd>GoTestFile<cr>", "Run test for current file" },
        },
        x = {
          name = "Code Lens",
          l = { "<cmd>GoCodeLenAct<cr>", "Toggle Lens" },
          a = { "<cmd>GoCodeAction<cr>", "Code Action" },
        },
      },
    }, { prefix = "<leader>", mode = "n", default_options })
    wk.register({
      c = {
        -- name = "Coding",
        j = { "<cmd>'<,'>GoJson2Struct<cr>", "Json to struct" },
      },
    }, { prefix = "<leader>", mode = "v", default_options })
  end, -- nil: use on_attach function defined in go/lsp.lua,
  --      when lsp_cfg is true
  -- if lsp_on_attach is a function: use this function as on_attach function for gopls
  lsp_keymaps = false, -- set to false to disable gopls/lsp keymap
  lsp_codelens = true, -- set to false to disable codelens, true by default, you can use a function
  -- function(bufnr)
  --    vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>F", "<cmd>lua vim.lsp.buf.formatting()<CR>", {noremap=true, silent=true})
  -- end
  -- to setup a table of codelens
  diagnostic = { -- set diagnostic to false to disable vim.diagnostic setup
    hdlr = true, -- hook lsp diag handler
    underline = true,
    -- virtual text setup
    virtual_text = { space = 0, prefix = "" },
    signs = true,
    update_in_insert = false,
  },
  -- virtual text setup
  lsp_document_formatting = true,
  -- set to true: use gopls to format
  -- false if you want to use other formatter tool(e.g. efm, nulls)
  lsp_inlay_hints = {
    enable = false,
    -- Only show inlay hints for the current line
    only_current_line = true,
    -- Event which triggers a refersh of the inlay hints.
    -- You can make this "CursorMoved" or "CursorMoved,CursorMovedI" but
    -- not that this may cause higher CPU usage.
    -- This option is only respected when only_current_line and
    -- autoSetHints both are true.
    only_current_line_autocmd = "CursorHold",
    -- whether to show variable name before type hints with the inlay hints or not
    -- default: false
    show_variable_name = true,
    -- prefix for parameter hints
    parameter_hints_prefix = "󰊕 ",
    show_parameter_hints = true,
    -- prefix for all the other hints (type, chaining)
    other_hints_prefix = "=> ",
    -- whether to align to the length of the longest line in the file
    max_len_align = false,
    -- padding from the left if max_len_align is true
    max_len_align_padding = 1,
    -- whether to align to the extreme right or not
    right_align = false,
    -- padding from the right if right_align is true
    right_align_padding = 6,
    -- The color of the hints
    highlight = "Comment",
  },
  gopls_cmd = nil, -- if you need to specify gopls path and cmd, e.g {"/home/user/lsp/gopls", "-logfile","/var/log/gopls.log" }
  gopls_remote_auto = true, -- add -remote=auto to gopls
  gocoverage_sign = "│",
  sign_priority = 5, -- change to a higher number to override other signs
  dap_debug = true, -- set to false to disable dap
  dap_debug_keymap = true, -- true: use keymap for debugger defined in go/dap.lua
  -- false: do not use keymap in go/dap.lua.  you must define your own.
  -- windows: use visual studio keymap
  dap_debug_gui = {}, -- bool|table put your dap-ui setup here set to false to disable
  dap_debug_vt = { enabled_commands = true, all_frames = true }, -- bool|table put your dap-virtual-text setup here set to false to disable

  dap_port = 38697, -- can be set to a number, if set to -1 go.nvim will pickup a random port
  dap_timeout = 15, --  see dap option initialize_timeout_sec = 15,
  dap_retries = 20, -- see dap option max_retries
  build_tags = "tag1,tag2", -- set default build tags
  textobjects = false, -- enable default text jobects through treesittter-text-objects
  test_runner = "go", -- one of {`go`, `richgo`, `dlv`, `ginkgo`, `gotestsum`}
  verbose_tests = true, -- set to add verbose flag to tests deprecated, see '-v' option
  run_in_floaterm = false, -- set to true to run in float window. :GoTermClose closes the floatterm
  -- float term recommend if you use richgo/ginkgo with terminal color

  floaterm = { -- position
    posititon = "auto", -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
    width = 0.45, -- width of float window if not auto
    height = 0.98, -- height of float window if not auto
  },
  trouble = false, -- true: use trouble to open quickfix
  test_efm = false, -- errorfomat for quickfix, default mix mode, set to true will be efm only
  luasnip = true, -- enable included luasnip snippets. you can also disable while add lua/snips folder to luasnip load
  --  Do not enable this if you already added the path, that will duplicate the entries
  on_jobstart = function(cmd)
    _ = cmd
  end, -- callback for stdout
  on_stdout = function(err, data)
    _, _ = err, data
  end, -- callback when job started
  on_stderr = function(err, data)
    _, _ = err, data
  end, -- callback for stderr
  on_exit = function(code, signal, output)
    _, _, _ = code, signal, output
  end, -- callback for jobexit, output : string
  iferr_vertical_shift = 4, -- defines where the cursor will end up vertically from the beginning of if err statement
})

return go_cfg
