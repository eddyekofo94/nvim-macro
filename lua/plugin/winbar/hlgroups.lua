---Initialize highlight groups for winbar
local function init()
  -- stylua: ignore start
  local hlgroups = {
    WinBarIconKindArray             = { link = 'Array' },
    WinBarIconKindBoolean           = { link = 'Boolean' },
    WinBarIconKindBreakStatement    = { link = 'Error' },
    WinBarIconKindCall              = { link = 'Function' },
    WinBarIconKindCaseStatement     = { link = 'Conditional' },
    WinBarIconKindClass             = { link = 'CmpItemKindClass' },
    WinBarIconKindConstant          = { link = 'Constant' },
    WinBarIconKindConstructor       = { link = 'CmpItemKindConstructor' },
    WinBarIconKindContinueStatement = { link = 'Repeat' },
    WinBarIconKindDeclaration       = { link = 'CmpItemKindSnippet' },
    WinBarIconKindDelete            = { link = 'Error' },
    WinBarIconKindDoStatement       = { link = 'Repeat' },
    WinBarIconKindElseStatement     = { link = 'Conditional' },
    WinBarIconKindEnum              = { link = 'CmpItemKindEnum' },
    WinBarIconKindEnumMember        = { link = 'CmpItemKindEnumMember' },
    WinBarIconKindEvent             = { link = 'CmpItemKindEvent' },
    WinBarIconKindField             = { link = 'CmpItemKindField' },
    WinBarIconKindFile              = { link = 'NormalFloat' },
    WinBarIconKindFolder            = { link = 'Directory' },
    WinBarIconKindForStatement      = { link = 'Repeat' },
    WinBarIconKindFunction          = { link = 'Function' },
    WinBarIconKindIdentifier        = { link = 'CmpItemKindVariable' },
    WinBarIconKindIfStatement       = { link = 'Conditional' },
    WinBarIconKindInterface         = { link = 'CmpItemKindInterface' },
    WinBarIconKindKeyword           = { link = 'Keyword' },
    WinBarIconKindList              = { link = 'Array' },
    WinBarIconKindMacro             = { link = 'Macro' },
    WinBarIconKindMethod            = { link = 'CmpItemKindMethod' },
    WinBarIconKindModule            = { link = 'CmpItemKindModule' },
    WinBarIconKindNamespace         = { link = 'NameSpace' },
    WinBarIconKindNull              = { link = 'Constant' },
    WinBarIconKindNumber            = { link = 'Number' },
    WinBarIconKindObject            = { link = 'Statement' },
    WinBarIconKindOperator          = { link = 'Operator' },
    WinBarIconKindPackage           = { link = 'CmpItemKindModule' },
    WinBarIconKindProperty          = { link = 'CmpItemKindProperty' },
    WinBarIconKindReference         = { link = 'CmpItemKindReference' },
    WinBarIconKindRepeat            = { link = 'Repeat' },
    WinBarIconKindScope             = { link = 'NameSpace' },
    WinBarIconKindSpecifier         = { link = 'Specifier' },
    WinBarIconKindStatement         = { link = 'Statement' },
    WinBarIconKindString            = { link = 'String' },
    WinBarIconKindStruct            = { link = 'CmpItemKindStruct' },
    WinBarIconKindSwitchStatement   = { link = 'Conditional' },
    WinBarIconKindType              = { link = 'CmpItemKindClass' },
    WinBarIconKindTypeParameter     = { link = 'CmpItemKindTypeParameter' },
    WinBarIconKindUnit              = { link = 'CmpItemKindUnit' },
    WinBarIconKindValue             = { link = 'Number' },
    WinBarIconKindVariable          = { link = 'CmpItemKindVariable' },
    WinBarIconKindWhileStatement    = { link = 'Repeat' },
    WinBarIconUIIndicator           = { link = 'SpecialChar' },
    WinBarIconUISeparator           = { link = 'SpecialChar' },
    WinBarMenuCurrentContext        = { link = 'PmenuSel' },
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
