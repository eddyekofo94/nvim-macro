return setmetatable({}, {
  __index = function(_, k)
    vim.deprecate("require('health')", 'vim.health', '0.9')
    return vim.health[k]
  end,
})
