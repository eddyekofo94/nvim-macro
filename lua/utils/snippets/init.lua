return setmetatable({}, {
  __index = function(self, key)
    self[key] = require('utils.snippets.' .. key)
    return self[key]
  end,
})
