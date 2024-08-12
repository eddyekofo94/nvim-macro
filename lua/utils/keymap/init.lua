return setmetatable({}, {
  __index = function(self, key)
    self[key] = require('utils.keymap.' .. key)
    return self[key]
  end,
})
