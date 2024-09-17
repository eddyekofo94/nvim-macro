local ls = require "luasnip"
local parse = ls.parser.parse_snippet
local s, t, i, c, r, f, sn =
  ls.snippet, ls.text_node, ls.insert_node, ls.choice_node, ls.restore_node, ls.function_node, ls.snippet_node
local fmt = require("luasnip.extras.fmt").fmt
local u = require("utils.snippets").luasnip
local today = u.today
local time = u.time
local comment_open = u.comment_open
local comment_close = u.comment_close

local snippets = {}

local todos = {
  "fix",
  "break",
  "todo",
  "info",
  "disabled",
  "hack",
  "example",
  "warn",
  "clean_up",
  "debug",
  "perf",
  "review",
  "note",
  "test",
  "bug",
  "refc",
  "question",
}
for _, todo in ipairs(todos) do
  table.insert(
    snippets,
    s(
      todo,
      fmt([[
      {} ]] .. string.upper(todo) .. [[: {} {}- {}
      ]], {
        f(comment_open),
        f(today),
        -- f(time),
        f(comment_close),
        i(1),
      })
    )
  )
end

return snippets
