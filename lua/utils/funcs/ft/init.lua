return setmetatable({}, {
  __index = function(self, key)
    self[key] = require('utils.funcs.ft.' .. key)
    return self[key]
  end,
})
