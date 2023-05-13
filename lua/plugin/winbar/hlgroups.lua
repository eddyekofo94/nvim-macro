---Initialize highlight groups for winbar
local function init()
  -- stylua: ignore start
  local hlgroups = {
    WinBarIconKindArray         = { link = 'Array' },
    WinBarIconKindBoolean       = { link = 'Boolean' },
    WinBarIconKindClass         = { link = 'CmpItemKindClass' },
    WinBarIconKindConstant      = { link = 'Constant' },
    WinBarIconKindConstructor   = { link = 'CmpItemKindConstructor' },
    WinBarIconKindEnum          = { link = 'CmpItemKindEnum' },
    WinBarIconKindEnumMember    = { link = 'CmpItemKindEnumMember' },
    WinBarIconKindEvent         = { link = 'CmpItemKindEvent' },
    WinBarIconKindField         = { link = 'CmpItemKindField' },
    WinBarIconKindFile          = { link = 'NonText' },
    WinBarIconKindFunction      = { link = 'Function' },
    WinBarIconKindIdentifier    = { link = 'CmpItemKindVariable' },
    WinBarIconKindInterface     = { link = 'CmpItemKindInterface' },
    WinBarIconKindKeyword       = { link = 'Keyword' },
    WinBarIconKindList          = { link = 'Array' },
    WinBarIconKindMacro         = { link = 'Macro' },
    WinBarIconKindMethod        = { link = 'CmpItemKindMethod' },
    WinBarIconKindModule        = { link = 'CmpItemKindModule' },
    WinBarIconKindNamespace     = { link = 'CmpItemKindNamespace' },
    WinBarIconKindNull          = { link = 'Constant' },
    WinBarIconKindNumber        = { link = 'Number' },
    WinBarIconKindObject        = { link = 'Object' },
    WinBarIconKindOperator      = { link = 'Operator' },
    WinBarIconKindPackage       = { link = 'CmpItemKindModule' },
    WinBarIconKindProperty      = { link = 'CmpItemKindProperty' },
    WinBarIconKindSpecifier     = { link = 'Specifier' },
    WinBarIconKindStatement     = { link = 'Statement' },
    WinBarIconKindString        = { link = 'String' },
    WinBarIconKindStruct        = { link = 'CmpItemKindStruct' },
    WinBarIconKindType          = { link = 'CmpItemKindClass' },
    WinBarIconKindTypeParameter = { link = 'CmpItemKindTypeParameter' },
    WinBarIconKindVariable      = { link = 'CmpItemKindVariable' },
    WinBarIconSeparator         = { link = 'SpecialChar' },
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
