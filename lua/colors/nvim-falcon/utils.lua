local M = {}

function M.reload(module)
  package.loaded[module] = nil
  return require(module)
end

return M
