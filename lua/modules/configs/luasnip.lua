local fn = vim.fn
local ls = require "luasnip"
local vsc = require "luasnip.loaders.from_vscode"
local lua = require "luasnip.loaders.from_lua"
local ls_types = require "luasnip.util.types"
local static = require "utils.static"

---Load snippets for a given filetype
---@param ft string
---@return nil
local function load_snippets(ft)
  local ok, snip_groups = pcall(require, "snippets." .. ft)
  if ok and type(snip_groups) == "table" then
    for _, snip_group in pairs(snip_groups) do
      ls.add_snippets(ft, snip_group.snip or snip_group, snip_group.opts or {})
    end
  end
end

---@return nil
local function lazy_load_snippets()
  local snippets_path = vim.split(fn.globpath(fn.stdpath "config" .. "/lua/snippets", "*.lua"), "\n")
  -- Record filetypes of all opened buffers
  local opened_file_ftlist = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    local ft = vim.bo[buf].ft
    if ft ~= "" then
      opened_file_ftlist[ft] = true
    end
  end
  local groupid = vim.api.nvim_create_augroup("LuaSnipLazyLoadSnippets", {})
  for _, path in ipairs(snippets_path) do
    local ft = fn.fnamemodify(path, ":t:r")
    -- Load snippet immediately if ft matches the filetype of any opened buffer
    if opened_file_ftlist[ft] then
      print("ft: " .. ft)
      load_snippets(ft)
    else -- Otherwise, load snippet when filetype is detected
      vim.api.nvim_create_autocmd("FileType", {
        once = true,
        pattern = ft,
        group = groupid,
        callback = function()
          print("ft: 44 - " .. ft)
          load_snippets(ft)
          return true
        end,
      })
    end
  end
end

---@return nil
local function set_keymaps()
  -- stylua: ignore start
  vim.keymap.set('s', '<Tab>',   function() ls.jump(1) end)
  vim.keymap.set('s', '<S-Tab>', function() ls.jump(-1) end)
  vim.keymap.set('s', '<C-n>',   function() return ls.choice_active() and '<Plug>luasnip-next-choice' or '<C-n>' end, { expr = true })
  vim.keymap.set('s', '<C-p>',   function() return ls.choice_active() and '<Plug>luasnip-prev-choice' or '<C-p>' end, { expr = true })
  -- stylua: ignore end
end

SNIP_ENV = {
  s = require("luasnip.nodes.snippet").S,
  sn = require("luasnip.nodes.snippet").SN,
  t = require("luasnip.nodes.textNode").T,
  f = require("luasnip.nodes.functionNode").F,
  i = require("luasnip.nodes.insertNode").I,
  c = require("luasnip.nodes.choiceNode").C,
  d = require("luasnip.nodes.dynamicNode").D,
  r = require("luasnip.nodes.restoreNode").R,
  l = require("luasnip.extras").lambda,
  rep = require("luasnip.extras").rep,
  p = require("luasnip.extras").partial,
  m = require("luasnip.extras").match,
  n = require("luasnip.extras").nonempty,
  dl = require("luasnip.extras").dynamic_lambda,
  fmt = require("luasnip.extras.fmt").fmt,
  fmta = require("luasnip.extras.fmt").fmta,
  conds = require "luasnip.extras.expand_conditions",
  types = require "luasnip.util.types",
  events = require "luasnip.util.events",
  parse = require("luasnip.util.parser").parse_snippet,
  ai = require "luasnip.nodes.absolute_indexer",
}

ls.config.set_config { history = true, updateevents = "TextChanged,TextChangedI" }

-- load lua snippets
lua.load { paths = vim.fn.stdpath "config" .. "/lua/snippets/" }

-- load friendly-snippets
-- this must be loaded after custom snippets or they get overwritte!
-- https://github.com/L3MON4D3/LuaSnip/blob/b5a72f1fbde545be101fcd10b70bcd51ea4367de/Examples/snippets.lua#L497
vsc.lazy_load()

-- expansion key
-- this will expand the current item or jump to the next item within the snippet.
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- jump backwards key.
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- selecting within a list of options.
vim.keymap.set("i", "<c-h>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

ls.setup {
  keep_roots = true,
  link_roots = false,
  link_children = true,
  region_check_events = "CursorMoved,CursorMovedI",
  delete_check_events = "TextChanged,TextChangedI",
  enable_autosnippets = true,
  store_selection_keys = "<Tab>",
  ext_opts = {
    [ls_types.choiceNode] = {
      active = {
        virt_text = { { static.icons.Enum, "Number" } },
      },
    },
    [ls_types.insertNode] = {
      unvisited = {
        virt_text = { { static.box.single.vt, "NonText" } },
        virt_text_pos = "inline",
      },
    },
    [ls_types.exitNode] = {
      unvisited = {
        virt_text = { { static.box.single.vt, "NonText" } },
        virt_text_pos = "inline",
      },
    },
  },
}

lazy_load_snippets()
set_keymaps()
