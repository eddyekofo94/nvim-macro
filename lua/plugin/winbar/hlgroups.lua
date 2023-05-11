---Initialize highlight groups for winbar
local function init()
  -- stylua: ignore start
  local hlgroups = {
    WinBarIconKindArray       = { link = 'Array' },
    WinBarIconKindBoolean     = { link = 'Boolean' },
    WinBarIconKindClass       = { link = 'CmpItemKindClass' },
    WinBarIconKindConstant    = { link = 'Constant' },
    WinBarIconKindConstructor = { link = 'CmpItemKindConstructor' },
    WinBarIconKindEnum        = { link = 'CmpItemKindEnum' },
    WinBarIconKindEnumMember  = { link = 'CmpItemKindEnumMember' },
    WinBarIconKindEvent       = { link = 'CmpItemKindEvent' },
    WinBarIconKindField       = { link = 'CmpItemKindField' },
    WinBarIconKindFile        = { link = 'File' },
    WinBarIconKindFunction    = { link = 'Function' },
    WinBarIconKindInterface   = { link = 'CmpItemKindInterface' },
    WinBarIconKindKey         = { link = 'Keyword' },
    WinBarIconKindMethod      = { link = 'CmpItemKindMethod' },
    WinBarIconKindModule      = { link = 'CmpItemKindModule' },
    WinBarIconKindNamespace   = { link = 'CmpItemKindNamespace' },
    WinBarIconKindNull        = { link = 'Constant' },
    WinBarIconKindNumber      = { link = 'Number' },
    WinBarIconKindObject      = { link = 'Object' },
    WinBarIconKindOperator    = { link = 'Operator' },
    WinBarIconKindPackage     = { link = 'CmpItemKindModule' },
    WinBarIconKindProperty    = { link = 'CmpItemKindProperty' },
    WinBarIconKindString      = { link = 'String' },
    WinBarIconKindStruct      = { link = 'CmpItemKindStruct' },
    WinBarIconKindVariable    = { link = 'CmpItemKindVariable' },
    WinBarIconSeparator       = { link = 'SpecialChar' },
    WinBarIconTypeParameter   = { link = 'CmpItemKind' },
  }
  -- stylua: ignore end
  for hl_name, hl_settings in pairs(hlgroups) do
    hl_settings.default = true
    vim.api.nvim_set_hl(0, hl_name, hl_settings)
  end
end

return {
  init = init,
}
