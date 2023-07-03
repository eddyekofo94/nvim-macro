return setmetatable({}, {
  __index = function(self, key)
    self[key] = require('utils.funcs.' .. key)
    return self[key]
  end,
})
