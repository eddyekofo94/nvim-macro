return {
  analyses = {
    shadow = true,
    nilness = true,
    unusedparams = true,
    unusedwrite = true,
    useany = true,
  },
  experimentalPostfixCompletions = true,
  gofumpt = true,
  workspace = {
    didChangeWatchedFiles = {
      dynamicRegistration = false,
    },
  },
  setting = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
    },
  },
  usePlaceholders = true,
  hints = {
    assignVariableTypes = true,
    compositeLiteralFields = true,
    compositeLiteralTypes = true,
    constantValues = true,
    functionTypeParameters = true,
    parameterNames = true,
    rangeVariableTypes = true,
  },
  staticcheck = true,
}
