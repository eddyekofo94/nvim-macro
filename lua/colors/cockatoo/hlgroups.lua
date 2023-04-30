package.loaded['colors.cockatoo.palette'] = nil
local plt = require('colors.cockatoo.palette')
local sch = {}

-- Common highlight groups
sch.Normal             = { fg = plt.smoke, bg = plt.jeans }
sch.NormalFloat        = { fg = plt.smoke, bg = plt.ocean }
sch.NormalNC           = { link = 'Normal' }
sch.ColorColumn        = { bg = plt.deepsea }
sch.Conceal            = { fg = plt.smoke }
sch.Cursor             = { fg = plt.space, bg = plt.white }
sch.CursorColumn       = { bg = plt.ocean_blend }
sch.CursorIM           = { fg = plt.space, bg = plt.flashlight }
sch.CursorLine         = { bg = plt.ocean_blend }
sch.CursorLineNr       = { fg = plt.orange, bold = true }
sch.DebugPC            = { bg = plt.purple_blend }
sch.lCursor            = { link = 'Cursor' }
sch.TermCursor         = { fg = plt.space, bg = plt.orange }
sch.TermCursorNC       = { fg = plt.orange, bg = plt.ocean }
sch.DiffAdd            = { bg = plt.aqua_blend }
sch.DiffAdded          = { fg = plt.tea, bg = plt.aqua_blend }
sch.DiffChange         = { bg = plt.purple_blend }
sch.DiffDelete         = { fg = plt.wine, bg = plt.wine_blend }
sch.DiffRemoved        = { fg = plt.scarlet, bg = plt.wine_blend }
sch.DiffText           = { bg = plt.lavender_blend }
sch.Directory          = { fg = plt.pigeon }
sch.EndOfBuffer        = { fg = plt.iron }
sch.ErrorMsg           = { fg = plt.scarlet }
sch.FoldColumn         = { fg = plt.steel }
sch.Folded             = { fg = plt.steel, bg = plt.ocean_blend }
sch.FloatBorder        = { fg = plt.smoke, bg = plt.ocean }
sch.FloatShadow        = { bg = plt.shadow, blend = 70 }
sch.FloatShadowThrough = { bg = plt.shadow, blend = 100 }
sch.Search             = { fg = plt.flashlight, bg = plt.thunder, bold = true }
sch.IncSearch          = { fg = plt.black, bg = plt.flashlight, bold = true }
sch.LineNr             = { fg = plt.steel }
sch.ModeMsg            = { fg = plt.smoke }
sch.MoreMsg            = { fg = plt.aqua }
sch.MsgArea            = { link = 'Normal' }
sch.MsgSeparator       = { link = 'StatusLine' }
sch.MatchParen         = { bg = plt.thunder, bold = true }
sch.NonText            = { fg = plt.iron }
sch.Pmenu              = { fg = plt.smoke, bg = plt.ocean }
sch.PmenuSbar          = { bg = plt.deepsea }
sch.PmenuSel           = { fg = plt.white, bg = plt.thunder }
sch.PmenuThumb         = { bg = plt.orange }
sch.Question           = { fg = plt.smoke }
sch.QuickFixLine       = { link = 'Visual' }
sch.SignColumn         = { fg = plt.smoke }
sch.SpecialKey         = { fg = plt.orange }
sch.SpellBad           = { underdotted = true }
sch.SpellCap           = { link = 'SpellBad' }
sch.SpellLocal         = { link = 'SpellBad' }
sch.SpellRare          = { link = 'SpellBad' }
sch.StatusLine         = { bg = plt.deepsea }
sch.StatusLineNC       = { bg = plt.space }
sch.Substitute         = { link = 'Search' }
sch.TabLine            = { link = 'StatusLine' }
sch.Title              = { fg = plt.pigeon, bold = true }
sch.VertSplit          = { fg = plt.deepsea }
sch.Visual             = { bg = plt.deepsea }
sch.VisualNOS          = { link = 'Visual' }
sch.WarningMsg         = { fg = plt.yellow }
sch.Whitespace         = { link = 'NonText' }
sch.WildMenu           = { link = 'PmenuSel' }
sch.Winseparator       = { link = 'VertSplit' }
sch.WinBar             = { fg = plt.pigeon }
sch.WinBarNC           = { fg = plt.steel }

-- Syntax highlighting
sch.Comment           = { fg = plt.steel, italic = true }
sch.Constant          = { fg = plt.ochre }
sch.String            = { fg = plt.turquoise }
sch.DocumentKeyword   = { fg = plt.tea }
sch.Character         = { fg = plt.orange }
sch.Number            = { fg = plt.purple }
sch.Boolean           = { fg = plt.ochre }
sch.Array             = { fg = plt.orange }
sch.Float             = { link = 'Number' }
sch.Identifier        = { fg = plt.smoke }
sch.Builtin           = { fg = plt.pink, italic = true }
sch.Field             = { fg = plt.pigeon }
sch.Enum              = { fg = plt.ochre }
sch.Namespace         = { fg = plt.ochre }
sch.Parameter         = { fg = plt.smoke }
sch.Function          = { fg = plt.yellow }
sch.Statement         = { fg = plt.lavender }
sch.Object            = { fg = plt.lavender }
sch.Conditional       = { fg = plt.magenta }
sch.Repeat            = { fg = plt.magenta }
sch.Label             = { fg = plt.magenta }
sch.Operator          = { fg = plt.orange }
sch.Keyword           = { fg = plt.cerulean }
sch.Exception         = { fg = plt.magenta }
sch.PreProc           = { fg = plt.turquoise }
sch.PreCondit         = { link = 'PreProc' }
sch.Include           = { link = 'PreProc' }
sch.Define            = { link = 'PreProc' }
sch.Macro             = { fg = plt.ochre }
sch.Type              = { fg = plt.lavender }
sch.StorageClass      = { link = 'Keyword' }
sch.Structure         = { link = 'Type' }
sch.Typedef           = { fg = plt.beige }
sch.Special           = { fg = plt.orange }
sch.SpecialChar       = { link = 'Special' }
sch.Tag               = { fg = plt.flashlight, underline = true }
sch.Delimiter         = { fg = plt.orange }
sch.Bracket           = { fg = plt.pigeon }
sch.SpecialComment    = { link = 'SpecialChar' }
sch.Debug             = { link = 'Special' }
sch.Underlined        = { underline = true }
sch.Ignore            = { fg = plt.iron }
sch.Error             = { fg = plt.scarlet }
sch.Todo              = { fg = plt.black, bg = plt.beige, bold = true }

-- LSP Highlighting
sch.LspReferenceText            = { link = 'Identifier' }
sch.LspReferenceRead            = { link = 'LspReferenceText' }
sch.LspReferenceWrite           = { link = 'LspReferenceText' }
sch.LspSignatureActiveParameter = { link = 'IncSearch' }
sch.LspInfoBorder               = { link = 'FloatBorder' }

-- Diagnostic highlighting
sch.DiagnosticOK               = { fg = plt.tea }
sch.DiagnosticError            = { fg = plt.wine }
sch.DiagnosticWarn             = { fg = plt.earth }
sch.DiagnosticInfo             = { fg = plt.smoke }
sch.DiagnosticHint             = { fg = plt.pigeon }
sch.DiagnosticVirtualTextOK    = { fg = plt.tea, bg = plt.tea_blend }
sch.DiagnosticVirtualTextError = { fg = plt.wine, bg = plt.wine_blend }
sch.DiagnosticVirtualTextWarn  = { fg = plt.earth, bg = plt.earth_blend }
sch.DiagnosticVirtualTextInfo  = { fg = plt.smoke, bg = plt.smoke_blend }
sch.DiagnosticVirtualTextHint  = { fg = plt.pigeon, bg = plt.pigeon_blend }
sch.DiagnosticUnderlineOK      = { underline = true, sp = plt.tea }
sch.DiagnosticUnderlineError   = { undercurl = true, sp = plt.wine }
sch.DiagnosticUnderlineWarn    = { undercurl = true, sp = plt.earth }
sch.DiagnosticUnderlineInfo    = { undercurl = true, sp = plt.flashlight }
sch.DiagnosticUnderlineHint    = { undercurl = true, sp = plt.pigeon }
sch.DiagnosticFloatingOK       = { link = 'DiagnosticOK' }
sch.DiagnosticFloatingError    = { link = 'DiagnosticError' }
sch.DiagnosticFloatingWarn     = { link = 'DiagnosticWarn' }
sch.DiagnosticFloatingInfo     = { link = 'DiagnosticInfo' }
sch.DiagnosticFloatingHint     = { link = 'DiagnosticHint' }
sch.DiagnosticSignOK           = { link = 'DiagnosticOK' }
sch.DiagnosticSignError        = { link = 'DiagnosticError' }
sch.DiagnosticSignWarn         = { link = 'DiagnosticWarn' }
sch.DiagnosticSignInfo         = { link = 'DiagnosticInfo' }
sch.DiagnosticSignHint         = { link = 'DiagnosticHint' }

sch['@field']                 = { link = 'Field' }
sch['@property']              = { link = 'Field' }
sch['@annotation']            = { link = 'Operator' }
sch['@comment']               = { link = 'Comment' }
sch['@none']                  = { link = 'None' }
sch['@preproc']               = { link = 'PreProc' }
sch['@define']                = { link = 'Define' }
sch['@operator']              = { link = 'Operator' }
sch['@punctuation.delimiter'] = { link = 'Delimiter' }
sch['@punctuation.bracket']   = { link = 'Bracket' }
sch['@punctuation.special']   = { link = 'Delimiter' }
sch['@string']                = { link = 'String' }
sch['@string.regex']          = { link = 'String' }
sch['@string.escape']         = { link = 'SpecialChar' }
sch['@string.special']        = { link = 'SpecialChar' }
sch['@character']             = { link = 'Character' }
sch['@character.special']     = { link = 'SpecialChar' }
sch['@boolean']               = { link = 'Boolean' }
sch['@number']                = { link = 'Number' }
sch['@float']                 = { link = 'Float' }
sch['@function']              = { link = 'Function' }
sch['@function.call']         = { link = 'Function' }
sch['@function.builtin']      = { link = 'Special' }
sch['@function.macro']        = { link = 'Macro' }
sch['@method']                = { link = 'Function' }
sch['@method.call']           = { link = 'Function' }
sch['@constructor']           = { link = 'Function' }
sch['@parameter']             = { link = 'Parameter' }
sch['@keyword']               = { link = 'Keyword' }
sch['@keyword.function']      = { link = 'Keyword' }
sch['@keyword.return']        = { link = 'Keyword' }
sch['@conditional']           = { link = 'Conditional' }
sch['@repeat']                = { link = 'Repeat' }
sch['@debug']                 = { link = 'Debug' }
sch['@label']                 = { link = 'Keyword' }
sch['@include']               = { link = 'Include' }
sch['@exception']             = { link = 'Exception' }
sch['@type']                  = { link = 'Type' }
sch['@type.Builtin']          = { link = 'Type' }
sch['@type.qualifier']        = { link = 'Type' }
sch['@type.definition']       = { link = 'Typedef' }
sch['@storageclass']          = { link = 'StorageClass' }
sch['@attribute']             = { link = 'Label' }
sch['@variable']              = { link = 'Identifier' }
sch['@variable.Builtin']      = { link = 'Builtin' }
sch['@constant']              = { link = 'Constant' }
sch['@constant.Builtin']      = { link = 'Constant' }
sch['@constant.macro']        = { link = 'Macro' }
sch['@namespace']             = { link = 'Namespace' }
sch['@symbol']                = { link = 'Identifier' }
sch['@text']                  = { link = 'String' }
sch['@text.title']            = { link = 'Title' }
sch['@text.literal']          = { link = 'String' }
sch['@text.uri']              = { link = 'htmlLink' }
sch['@text.math']             = { link = 'Special' }
sch['@text.environment']      = { link = 'Macro' }
sch['@text.environment.name'] = { link = 'Type' }
sch['@text.reference']        = { link = 'Constant' }
sch['@text.todo']             = { link = 'Todo' }
sch['@text.todo.unchecked']   = { link = 'Todo' }
sch['@text.todo.checked']     = { link = 'Done' }
sch['@text.note']             = { link = 'SpecialComment' }
sch['@text.warning']          = { link = 'WarningMsg' }
sch['@text.danger']           = { link = 'ErrorMsg' }
sch['@text.diff.add']         = { link = 'DiffAdded' }
sch['@text.diff.delete']      = { link = 'DiffRemoved' }
sch['@tag']                   = { link = 'Tag' }
sch['@tag.attribute']         = { link = 'Identifier' }
sch['@tag.delimiter']         = { link = 'Delimiter' }
sch['@text.strong']           = { bold = true }
sch['@text.strike']           = { strikethrough = true }
sch['@text.emphasis']         = { fg = plt.black, bg = plt.beige, bold = true, italic = true }
sch['@text.underline']        = { underline = true }
sch['@keyword.operator']      = { link = 'Operator' }

sch['@lsp.type.enum']                       = { link = 'Type' }
sch['@lsp.type.type']                       = { link = 'Type' }
sch['@lsp.type.class']                      = { link = 'Structure' }
sch['@lsp.type.struct']                     = { link = 'Structure' }
sch['@lsp.type.macro']                      = { link = 'Macro' }
sch['@lsp.type.method']                     = { link = 'Function' }
sch['@lsp.type.comment']                    = { link = 'Comment' }
sch['@lsp.type.function']                   = { link = 'Function' }
sch['@lsp.type.property']                   = { link = 'Field' }
sch['@lsp.type.variable']                   = { link = 'Variable' }
sch['@lsp.type.decorator']                  = { link = 'Label' }
sch['@lsp.type.interface']                  = { link = 'Structure' }
sch['@lsp.type.namespace']                  = { link = 'Namespace' }
sch['@lsp.type.parameter']                  = { link = 'Parameter' }
sch['@lsp.type.enumMember']                 = { link = 'Enum' }
sch['@lsp.type.typeParameter']              = { link = 'Parameter' }
sch['@lsp.typemod.keyword.documentation']   = { link = 'DocumentKeyword' }
sch['@lsp.typemod.function.defaultLibrary'] = { link = 'Special' }
sch['@lsp.typemod.variable.defaultLibrary'] = { link = 'Builtin' }
sch['@lsp.typemod.variable.global']         = { link = 'Identifier' }

-- HTML
sch.htmlArg            = { fg = plt.pigeon }
sch.htmlBold           = { bold = true }
sch.htmlBoldItalic     = { bold = true, italic = true }
sch.htmlTag            = { fg = plt.smoke }
sch.htmlTagName        = { link = 'Tag' }
sch.htmlSpecialTagName = { fg = plt.yellow }
sch.htmlEndTag         = { fg = plt.yellow }
sch.htmlH1             = { fg = plt.yellow, bold = true }
sch.htmlH2             = { fg = plt.ochre, bold = true }
sch.htmlH3             = { fg = plt.pink, bold = true }
sch.htmlH4             = { fg = plt.lavender, bold = true }
sch.htmlH5             = { fg = plt.cerulean, bold = true }
sch.htmlH6             = { fg = plt.aqua, bold = true }
sch.htmlItalic         = { italic = true }
sch.htmlLink           = { fg = plt.flashlight, underline = true }
sch.htmlSpecialChar    = { fg = plt.beige }
sch.htmlTitle          = { fg = plt.pigeon }
-- Json
sch.jsonKeyword        = { link = 'Keyword' }
sch.jsonBraces         = { fg = plt.smoke }
-- Markdown
sch.markdownBold       = { fg = plt.aqua, bold = true }
sch.markdownBoldItalic = { fg = plt.skyblue, bold = true, italic = true }
sch.markdownCode       = { fg = plt.pigeon }
sch.markdownError      = { link = 'None' }
sch.markdownEscape     = { link = 'None' }
sch.markdownListMarker = { fg = plt.orange }
-- Shell
sch.shDeref            = { link = 'Macro' }
sch.shDerefVar         = { link = 'Macro' }
-- Git
sch.gitHash = { fg = plt.pigeon }

-- Plugin highlights
-- nvim-cmp
sch.CmpItemAbbr            = { fg = plt.smoke }
sch.CmpItemAbbrDeprecated  = { strikethrough = true }
sch.CmpItemAbbrMatch       = { fg = plt.white }
sch.CmpItemAbbrMatchFuzzy  = { link = 'CmpItemAbbrMatch' }
sch.CmpItemKindText        = { link = 'String' }
sch.CmpItemKindMethod      = { link = 'Function' }
sch.CmpItemKindFunction    = { link = 'Function' }
sch.CmpItemKindConstructor = { link = 'Function' }
sch.CmpItemKindField       = { fg = plt.purple }
sch.CmpItemKindProperty    = { link = 'CmpItemKindField' }
sch.CmpItemKindVariable    = { fg = plt.aqua }
sch.CmpItemKindReference   = { link = 'CmpItemKindVariable' }
sch.CmpItemKindModule      = { fg = plt.magenta }
sch.CmpItemKindEnum        = { fg = plt.ochre }
sch.CmpItemKindEnumMember  = { link = 'CmpItemKindEnum' }
sch.CmpItemKindKeyword     = { link = 'Keyword' }
sch.CmpItemKindOperator    = { link = 'Operator' }
sch.CmpItemKindSnippet     = { fg = plt.tea }
sch.CmpItemKindColor       = { fg = plt.pink }
sch.CmpItemKindConstant    = { link = 'Constant' }
sch.CmpItemKindCopilot     = { fg = plt.magenta }
sch.CmpItemKindValue       = { link = 'Number' }
sch.CmpItemKindClass       = { link = 'Type' }
sch.CmpItemKindStruct      = { link = 'Type' }
sch.CmpItemKindEvent       = { fg = plt.flashlight }
sch.CmpItemKindInterface   = { fg = plt.flashlight }
sch.CmpItemKindFile        = { fg = plt.smoke }
sch.CmpItemKindFolder      = { fg = plt.pigeon }
sch.CmpItemKind            = { fg = plt.smoke }
sch.CmpItemMenu            = { fg = plt.smoke }
sch.CmpItemAbbrMatch       = { fg = plt.white, bold = true }
sch.CmpItemAbbrMatchFuzzy  = { link = 'CmpItemAbbrMatch' }

-- gitsigns
sch.GitSignsAdd                      = { fg = plt.tea_blend }
sch.GitSignsAddInline                = { fg = plt.tea, bg = plt.tea_blend }
sch.GitSignsAddLnInline              = { fg = plt.tea, bg = plt.tea_blend }
sch.GitSignsAddPreview               = { link = 'DiffAdded' }
sch.GitSignsChange                   = { fg = plt.lavender_blend }
sch.GitSignsChangeInline             = { fg = plt.lavender, bg = plt.lavender_blend }
sch.GitSignsChangeLnInline           = { fg = plt.lavender, bg = plt.lavender_blend }
sch.GitSignsCurrentLineBlame         = { fg = plt.smoke, bg = plt.smoke_blend }
sch.GitSignsDelete                   = { fg = plt.wine }
sch.GitSignsDeleteInline             = { fg = plt.scarlet, bg = plt.scarlet_blend }
sch.GitSignsDeleteLnInline           = { fg = plt.scarlet, bg = plt.scarlet_blend }
sch.GitSignsDeletePreview            = { fg = plt.scarlet, bg = plt.wine_blend }
sch.GitSignsDeleteVirtLnInLine       = { fg = plt.scarlet, bg = plt.scarlet_blend }
sch.GitSignsUntracked                = { fg = plt.scarlet_blend }
sch.GitSignsUntrackedLn              = { bg = plt.scarlet_blend }
sch.GitSignsUntrackedNr              = { fg = plt.pink }

-- fugitive
sch.fugitiveHash              = { link = 'gitHash' }
sch.fugitiveHeader            = { link = 'Title' }
sch.fugitiveHeading           = { fg = plt.orange, bold = true }
sch.fugitiveHelpTag           = { fg = plt.orange }
sch.fugitiveSymbolicRef       = { fg = plt.yellow }
sch.fugitiveStagedModifier    = { fg = plt.tea, bold = true }
sch.fugitiveUnstagedModifier  = { fg = plt.scarlet, bold = true }
sch.fugitiveUntrackedModifier = { fg = plt.pigeon, bold = true }
sch.fugitiveStagedHeading     = { fg = plt.aqua, bold = true }
sch.fugitiveUnstagedHeading   = { fg = plt.ochre, bold = true }
sch.fugitiveUntrackedHeading  = { fg = plt.lavender, bold = true }

-- barbar
sch.BufferCurrent        = { fg = plt.smoke }
sch.BufferCurrentIndex   = { fg = plt.orange, bold = true }
sch.BufferCurrentMod     = { fg = plt.orange }
sch.BufferCurrentSign    = { fg = plt.orange }
sch.BufferInactive       = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveIcon   = { link = 'StatusLine' }
sch.BufferInactiveIndex  = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveMod    = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveSign   = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferVisible        = { fg = plt.pigeon }
sch.BufferVisibleIndex   = { fg = plt.pigeon }
sch.BufferVisibleMod     = { fg = plt.yellow }
sch.BufferTabpageFill    = { fg = plt.pigeon, bg = plt.ocean }

-- telescope
sch.TelescopeNormal               = { link = 'NormalFloat' }
sch.TelescopePromptNormal         = { bg = plt.deepsea }
sch.TelescopeTitle                = { fg = plt.space, bg = plt.turquoise, bold = true }
sch.TelescopePromptTitle          = { fg = plt.space, bg = plt.yellow, bold = true }
sch.TelescopeBorder               = { fg = plt.smoke, bg = plt.ocean }
sch.TelescopePromptBorder         = { fg = plt.smoke, bg = plt.deepsea }
sch.TelescopeSelection            = { bg = plt.thunder }
sch.TelescopeMultiSelection       = { bg = plt.thunder, bold = true }
sch.TelescopePreviewLine          = { bg = plt.thunder }
sch.TelescopeMatching             = { link = 'Search' }
sch.TelescopePromptCounter        = { link = 'Comment' }
sch.TelescopePromptPrefix         = { fg = plt.orange }
sch.TelescopeSelectionCaret       = { fg = plt.orange, bg = plt.thunder }

-- nvim-navic
sch.NavicIconsFile          = { link = 'File' }
sch.NavicIconsModule        = { link = 'CmpItemKindModule' }
sch.NavicIconsNamespace     = { fg = plt.ochre }
sch.NavicIconsPackage       = { link = 'CmpItemKindModule' }
sch.NavicIconsClass         = { link = 'CmpItemKindClass' }
sch.NavicIconsMethod        = { link = 'CmpItemKindMethod' }
sch.NavicIconsProperty      = { link = 'CmpItemKindProperty' }
sch.NavicIconsField         = { link = 'CmpItemKindField' }
sch.NavicIconsConstructor   = { link = 'CmpItemKindConstructor' }
sch.NavicIconsEnum          = { link = 'CmpItemKindEnum' }
sch.NavicIconsInterface     = { link = 'CmpItemKindInterface' }
sch.NavicIconsFunction      = { link = 'Function' }
sch.NavicIconsVariable      = { link = 'CmpItemKindVariable' }
sch.NavicIconsConstant      = { link = 'Constant' }
sch.NavicIconsString        = { link = 'String' }
sch.NavicIconsNumber        = { link = 'Number' }
sch.NavicIconsBoolean       = { link = 'Boolean' }
sch.NavicIconsArray         = { link = 'Array' }
sch.NavicIconsObject        = { link = 'Object' }
sch.NavicIconsKey           = { link = 'Keyword' }
sch.NavicIconsNull          = { link = 'Constant' }
sch.NavicIconsEnumMember    = { link = 'CmpItemKindEnumMember' }
sch.NavicIconsStruct        = { link = 'CmpItemKindStruct' }
sch.NavicIconsEvent         = { link = 'CmpItemKindEvent' }
sch.NavicIconsOperator      = { link = 'Operator' }
sch.NavicIconsTypeParameter = { link = 'CmpItemKind' }
sch.NavicPath               = { fg = plt.smoke }
sch.NavicText               = { fg = plt.smoke }
sch.NavicSeparator          = { fg = plt.orange }

-- aerial
sch.AerialLine              = { fg = plt.white, bg = plt.thunder, bold = true }
sch.AerialArrayIcon         = { link = 'Array' }
sch.AerialBooleanIcon       = { link = 'Boolean' }
sch.AerialClassIcon         = { link = 'CmpItemKindClass' }
sch.AerialConstantIcon      = { link = 'CmpItemKindConstant' }
sch.AerialConstructorIcon   = { link = 'CmpItemKindConstructor' }
sch.AerialEnumIcon          = { link = 'CmpItemKindEnum' }
sch.AerialEnumMemberIcon    = { link = 'CmpItemKindEnumMember' }
sch.AerialEventIcon         = { link = 'CmpItemKindEvent' }
sch.AerialFieldIcon         = { link = 'CmpItemKindField' }
sch.AerialFileIcon          = { link = 'CmpItemKindFile' }
sch.AerialFunctionIcon      = { link = 'CmpItemKindFunction' }
sch.AerialGuide             = { link = 'Comment' }
sch.AerialInterfaceIcon     = { link = 'CmpItemKindInterface' }
sch.AerialKeyIcon           = { link = 'CmpItemKindKeyword' }
sch.AerialMethodIcon        = { link = 'CmpItemKindMethod' }
sch.AerialModuleIcon        = { link = 'CmpItemKindModule' }
sch.AerialNamespaceIcon     = { link = '@namespace' }
sch.AerialNullIcon          = { link = 'Boolean' }
sch.AerialNumberIcon        = { link = 'CmpItemKindValue' }
sch.AerialObjectIcon        = { link = 'Object' }
sch.AerialOperatorIcon      = { link = 'CmpItemKindOperator' }
sch.AerialPackageIcon       = { link = 'CmpItemKindModule' }
sch.AerialPropertyIcon      = { link = 'CmpItemKindProperty' }
sch.AerialStringIcon        = { link = 'CmpItemKindText' }
sch.AerialStructIcon        = { link = 'CmpItemKindStruct' }
sch.AerialTypeParameterIcon = { link = 'CmpItemKind' }
sch.AerialVariableIcon      = { link = 'CmpItemKindVariable' }

-- fidget
sch.FidgetTitle = { link = 'Title' }
sch.FidgetTask  = { link = 'Comment' }

-- nvim-dap-ui
sch.DapUIBreakpointsCurrentLine = { link = 'CursorLineNr' }
sch.DapUIBreakpointsInfo        = { fg = plt.tea }
sch.DapUIBreakpointsPath        = { link = 'Directory' }
sch.DapUICurrentFrameName       = { fg = plt.tea, bold = true }
sch.DapUIDecoration             = { fg = plt.yellow }
sch.DapUIFloatBorder            = { link = 'FloatBorder' }
sch.DapUINormalFloat            = { link = 'NormalFloat' }
sch.DapUILineNumber             = { link = 'LineNr' }
sch.DapUIModifiedValue          = { fg = plt.skyblue, bold = true }
sch.DapUIPlayPause              = { fg = plt.tea }
sch.DapUIPlayPauseNC            = { fg = plt.tea }
sch.DapUIRestart                = { fg = plt.tea }
sch.DapUIRestartNC              = { fg = plt.tea }
sch.DapUIScope                  = { fg = plt.orange }
sch.DapUISource                 = { link = 'Directory' }
sch.DapUIStepBack               = { fg = plt.lavender }
sch.DapUIStepBackRC             = { fg = plt.lavender }
sch.DapUIStepInto               = { fg = plt.lavender }
sch.DapUIStepIntoRC             = { fg = plt.lavender }
sch.DapUIStepOut                = { fg = plt.lavender }
sch.DapUIStepOutRC              = { fg = plt.lavender }
sch.DapUIStepOver               = { fg = plt.lavender }
sch.DapUIStepOverRC             = { fg = plt.lavender }
sch.DapUIStop                   = { fg = plt.scarlet }
sch.DapUIStopNC                 = { fg = plt.scarlet }
sch.DapUIStoppedThread          = { fg = plt.tea }
sch.DapUIThread                 = { fg = plt.aqua }
sch.DapUIType                   = { link = 'Type' }
sch.DapUIVariable               = { link = 'Identifier' }
sch.DapUIWatchesEmpty           = { link = 'Comment' }
sch.DapUIWatchesError           = { link = 'Error' }
sch.DapUIWatchesValue           = { fg = plt.orange }

-- vimtex
sch.texArg                = { fg = plt.pigeon }
sch.texArgNew             = { fg = plt.skyblue }
sch.texCmd                = { fg = plt.yellow }
sch.texCmdBib             = { link = 'texCmd' }
sch.texCmdClass           = { link = 'texCmd' }
sch.texCmdDef             = { link = 'texCmd' }
sch.texCmdE3              = { link = 'texCmd' }
sch.texCmdEnv             = { link = 'texCmd' }
sch.texCmdEnvM            = { link = 'texCmd' }
sch.texCmdError           = { link = 'ErrorMsg' }
sch.texCmdFatal           = { link = 'ErrorMsg' }
sch.texCmdGreek           = { link = 'texCmd' }
sch.texCmdInput           = { link = 'texCmd' }
sch.texCmdItem            = { link = 'texCmd' }
sch.texCmdLet             = { link = 'texCmd' }
sch.texCmdMath            = { link = 'texCmd' }
sch.texCmdNew             = { link = 'texCmd' }
sch.texCmdPart            = { link = 'texCmd' }
sch.texCmdRef             = { link = 'texCmd' }
sch.texCmdSize            = { link = 'texCmd' }
sch.texCmdStyle           = { link = 'texCmd' }
sch.texCmdTitle           = { link = 'texCmd' }
sch.texCmdTodo            = { link = 'texCmd' }
sch.texCmdType            = { link = 'texCmd' }
sch.texCmdVerb            = { link = 'texCmd' }
sch.texComment            = { link = 'Comment' }
sch.texDefParm            = { link = 'Keyword' }
sch.texDelim              = { fg = plt.pigeon }
sch.texE3Cmd              = { link = 'texCmd' }
sch.texE3Delim            = { link = 'texDelim' }
sch.texE3Opt              = { link = 'texOpt' }
sch.texE3Parm             = { link = 'texParm' }
sch.texE3Type             = { link = 'texCmd' }
sch.texEnvOpt             = { link = 'texOpt' }
sch.texError              = { link = 'ErrorMsg' }
sch.texFileArg            = { link = 'Directory' }
sch.texFileOpt            = { link = 'texOpt' }
sch.texFilesArg           = { link = 'texFileArg' }
sch.texFilesOpt           = { link = 'texFileOpt' }
sch.texLength             = { fg = plt.lavender }
sch.texLigature           = { fg = plt.pigeon }
sch.texOpt                = { fg = plt.smoke }
sch.texOptEqual           = { fg = plt.orange }
sch.texOptSep             = { fg = plt.orange }
sch.texParm               = { fg = plt.pigeon }
sch.texRefArg             = { fg = plt.lavender }
sch.texRefOpt             = { link = 'texOpt' }
sch.texSymbol             = { fg = plt.orange }
sch.texTitleArg           = { link = 'Title' }
sch.texVerbZone           = { fg = plt.pigeon }
sch.texZone               = { fg = plt.aqupigeon }
sch.texMathArg            = { fg = plt.pigeon }
sch.texMathCmd            = { link = 'texCmd' }
sch.texMathSub            = { fg = plt.pigeon }
sch.texMathOper           = { fg = plt.orange }
sch.texMathZone           = { fg = plt.yellow }
sch.texMathDelim          = { fg = plt.smoke }
sch.texMathError          = { link = 'Error' }
sch.texMathGroup          = { fg = plt.pigeon }
sch.texMathSuper          = { fg = plt.pigeon }
sch.texMathSymbol         = { fg = plt.yellow }
sch.texMathZoneLD         = { fg = plt.pigeon }
sch.texMathZoneLI         = { fg = plt.pigeon }
sch.texMathZoneTD         = { fg = plt.pigeon }
sch.texMathZoneTI         = { fg = plt.pigeon }
sch.texMathCmdText        = { link = 'texCmd' }
sch.texMathZoneEnv        = { fg = plt.pigeon }
sch.texMathArrayArg       = { fg = plt.yellow }
sch.texMathCmdStyle       = { link = 'texCmd' }
sch.texMathDelimMod       = { fg = plt.smoke }
sch.texMathSuperSub       = { fg = plt.smoke }
sch.texMathDelimZone      = { fg = plt.pigeon }
sch.texMathStyleBold      = { fg = plt.smoke, bold = true }
sch.texMathStyleItal      = { fg = plt.smoke, italic = true }
sch.texMathEnvArgName     = { fg = plt.lavender }
sch.texMathErrorDelim     = { link = 'Error' }
sch.texMathDelimZoneLD    = { fg = plt.steel }
sch.texMathDelimZoneLI    = { fg = plt.steel }
sch.texMathDelimZoneTD    = { fg = plt.steel }
sch.texMathDelimZoneTI    = { fg = plt.steel }
sch.texMathZoneEnsured    = { fg = plt.pigeon }
sch.texMathCmdStyleBold   = { fg = plt.yellow, bold = true }
sch.texMathCmdStyleItal   = { fg = plt.yellow, italic = true }
sch.texMathStyleConcArg   = { fg = plt.pigeon }
sch.texMathZoneEnvStarred = { fg = plt.pigeon }

-- lazy.nvim
sch.LazyDir           = { link = 'Directory' }
sch.LazyUrl           = { link = 'htmlLink' }
sch.LazySpecial       = { fg = plt.orange }
sch.LazyCommit        = { fg = plt.tea }
sch.LazyReasonFt      = { fg = plt.pigeon }
sch.LazyReasonCmd     = { fg = plt.yellow }
sch.LazyReasonPlugin  = { fg = plt.turquoise }
sch.LazyReasonSource  = { fg = plt.orange }
sch.LazyReasonRuntime = { fg = plt.lavender }
sch.LazyReasonEvent   = { fg = plt.flashlight }
sch.LazyReasonKeys    = { fg = plt.pink }
sch.LazyButton        = { bg = plt.ocean }
sch.LazyButtonActive  = { bg = plt.thunder, bold = true }
sch.LazyH1            = { fg = plt.space, bg = plt.yellow, bold = true }

-- mason.nivm
sch.masonDoc                         = { fg = plt.pigeon }
sch.masonPod                         = { fg = plt.pigeon }
sch.MasonLink                        = { link = 'htmlLink' }
sch.MasonError                       = { link = 'Error' }
sch.MasonMuted                       = { fg = plt.smoke }
sch.MasonHeader                      = { fg = plt.space, bg = plt.yellow, bold = true }
sch.MasonNormal                      = { link = 'NormalFloat' }
sch.MasonHeading                     = { link = 'Title' }
sch.MasonHighlight                   = { fg = plt.orange }
sch.MasonMutedBlock                  = { fg = plt.smoke, bg = plt.ocean }
sch.MasonPerlComment                 = { link = 'Comment' }
sch.MasonHighlightBlock              = { bg = plt.thunder }
sch.MasonMutedBlockBold              = { fg = plt.smoke, bg = plt.ocean, bold = true }
sch.MasonHeaderSecondary             = { fg = plt.space, bg = plt.turquoise, bold = true }
sch.MasonHighlightBlockBold          = { bg = plt.thunder, bold = true }
sch.MasonHighlightSecondary          = { fg = plt.turquoise }
sch.MasonHighlightBlockSecondary     = { fg = plt.space, bg = plt.turquoise }
sch.MasonHighlightBlockBoldSecondary = { bg = plt.thunder, bold = true }

-- vim-floaterm
sch.Floaterm       = { bg = plt.ocean }
sch.FloatermBorder = { fg = plt.smoke, bg = plt.ocean }

-- copilot.lua
sch.CopilotSuggestion = { fg = plt.steel, italic = true }
sch.CopilotAnnotation = { fg = plt.steel, italic = true }

-- Extra highlight groups
sch.Yellow     = { fg = plt.yellow }
sch.Earth      = { fg = plt.earth }
sch.Orange     = { fg = plt.orange }
sch.Scarlet    = { fg = plt.scarlet }
sch.Ochre      = { fg = plt.ochre }
sch.Wine       = { fg = plt.wine }
sch.Pink       = { fg = plt.pink }
sch.Tea        = { fg = plt.tea }
sch.Flashlight = { fg = plt.flashlight }
sch.Aqua       = { fg = plt.aqua }
sch.Cerulean   = { fg = plt.cerulean }
sch.SkyBlue    = { fg = plt.skyblue }
sch.Turquoise  = { fg = plt.turquoise }
sch.Lavender   = { fg = plt.lavender }
sch.Magenta    = { fg = plt.magenta }
sch.Purple     = { fg = plt.purple }
sch.Thunder    = { fg = plt.thunder }
sch.White      = { fg = plt.white }
sch.Beige      = { fg = plt.beige }
sch.Pigeon     = { fg = plt.pigeon }
sch.Steel      = { fg = plt.steel }
sch.Smoke      = { fg = plt.smoke }
sch.Iron       = { fg = plt.iron }
sch.Deepsea    = { fg = plt.deepsea }
sch.Ocean      = { fg = plt.ocean }
sch.Space      = { fg = plt.space }
sch.Black      = { fg = plt.black }
sch.None       = { fg = 'NONE', bg = 'NONE' }
sch.Ghost      = { fg = plt.steel, italic = true }

return sch
