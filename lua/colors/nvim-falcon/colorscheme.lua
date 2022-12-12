local plt = require('colors.nvim-falcon.palette')
local sch = {}

-- Common highlight groups
sch.Normal       = { fg = plt.smoke } -- Normal text
sch.NormalFloat  = { fg = sch.smoke } -- Normal text in floating windows.
sch.NormalNC     = { link = 'Normal' } -- normal text in non-current windows
sch.ColorColumn  = { link = 'CursorColumn' } -- Columns set with 'colorcolumn'
sch.Conceal      = { fg = plt.smoke } -- Placeholder characters substituted for concealed text (see 'conceallevel')
sch.Cursor       = { bg = plt.white } -- Character under the cursor
sch.CursorColumn = { bg = plt.deepsea } -- Screen-column at the cursor, when 'cursorcolumn' is set.
sch.CursorIM     = { bg = plt.flashlight, fg = plt.black } -- Like Cursor, but used when in IME mode |CursorIM|
sch.CursorLine   = { bg = plt.deepsea } -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
sch.CursorLineNr = { fg = plt.orange } -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
sch.lCursor      = { link = 'Cursor' } -- Character under the cursor when |language-mapping| is used (see 'guicursor')
sch.TermCursor   = { reverse = true } -- Cursor in a focused terminal
sch.TermCursorNC = { bg = plt.smoke } -- Cursor in an unfocused terminal
sch.DiffAdd      = { fg = plt.tea } -- Diff mode: Added line |diff.txt|
sch.DiffChange   = {} -- Diff mode: Changed line |diff.txt|
sch.DiffDelete   = { fg = plt.wine } -- Diff mode: Deleted line |diff.txt|
sch.DiffText     = { fg = plt.aqua } -- Diff mode: Changed text within a changed line |diff.txt|
sch.Directory    = { fg = plt.pigeon } -- Directory names (and other special names in listings)
sch.EndOfBuffer  = { fg = plt.iron } -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
sch.ErrorMsg     = { fg = plt.scarlet } -- Error messages on the command line
sch.FoldColumn   = { fg = plt.purple, italic = true } -- 'foldcolumn'
sch.Folded       = { fg = plt.purple, bg = plt.space, italic = true } -- Line used for closed folds
sch.Search       = { fg = plt.flashlight, bold = true } -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
sch.IncSearch    = { fg = plt.black, bg = plt.flashlight, bold = true } -- 'incsearch' highlighting; also used for the text replaced with ':s///c'
sch.LineNr       = { fg = plt.steel } -- Line number for ':number' and ':#' commands, and when 'number' or 'relativenumber' option is set.
sch.ModeMsg      = { fg = plt.smoke } -- 'showmode' message (e.g., '-- INSERT -- ')
sch.MoreMsg      = { fg = plt.turquoise } -- |more-prompt|
sch.MsgArea      = { link = 'Normal' } -- Area for messages and cmdline
sch.MsgSeparator = { link = 'StatusLine' } -- Separator for scrolled messages, `msgsep` flag of 'display'
sch.NonText      = { fg = plt.iron } -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., '>' displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
sch.Pmenu        = { fg = sch.smoke } -- Popup menu: Normal item.
sch.PmenuSbar    = {} -- Popup menu: Scrollbar.
sch.PmenuSel     = { fg = plt.white, bg = plt.thunder } -- Popup menu: Selected item.
sch.PmenuThumb   = { bg = plt.orange } -- Popup menu: Thumb of the scrollbar.
sch.Question     = { fg = plt.smoke } -- |hit-enter| prompt and yes/no questions
sch.QuickFixLine = { link = 'Visual' } -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
sch.SignColumn   = { fg = plt.smoke } -- Column where |signs| are displayed
sch.SpecialKey   = { fg = plt.iron } -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
sch.SpellBad     = { underdashed = true } -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
sch.SpellCap     = { link = 'SpellBad' } -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
sch.SpellLocal   = { link = 'SpellBad' } -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
sch.SpellRare    = { link = 'SpellBad' } -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
sch.StatusLine   = { bg = plt.deepsea } -- Status line of current window
sch.StatusLineNC = { bg = plt.space } -- Status lines of not-current windows. Note: If this is equal to 'StatusLine' Vim will use '^^^' in the status line of the current window.
sch.Substitute   = { link = 'Search' } -- |:substitute| replacement text highlighting
sch.TabLine      = { link = 'StatusLine' } -- Tab pages line, not active tab page label
sch.Title        = { fg = plt.pigeon, bold = true } -- Titles for output from ':set all', ':autocmd' etc.
sch.VertSplit    = { fg = plt.smoke } -- Column separating vertically split windows
sch.Visual       = { fg = plt.smoke, bg = plt.thunder } -- Visual mode selection
sch.VisualNOS    = { link = 'Visual' } -- Visual mode selection when vim is 'Not Owning the Selection'.
sch.WarningMsg   = { fg = plt.yellow } -- Warning messages
sch.Whitespace   = { link = 'SpecialKey' } -- 'nbsp', 'space', 'tab' and 'trail' in 'listchars'
sch.WildMenu     = { link = 'PmenuSel' } -- Current match in 'wildmenu' completion
sch.Winseparator = { link = 'VertSplit' } -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.

-- Syntax highlighting
sch.Comment        = { fg = plt.steel } -- Any comment
sch.Constant       = { fg = plt.beige, bold = true } -- (*) Any constant
sch.String         = { fg = plt.beige } --   A string constant: 'this is a string'
sch.Character      = { fg = plt.orange } --   A character constant: 'c', '\n'
sch.Number         = { fg = plt.smoke } --   A number constant: 234, 0xff
sch.Boolean        = { link = 'Constant' } --   A boolean     constant: TRUE, false
sch.Array          = { fg = plt.orange }
sch.Float          = { link = 'Number' } --   A floating point constant: 2.3e10
sch.Identifier     = { fg = plt.pigeon } -- (*) Any variable name
sch.Function       = { fg = plt.yellow } --   Function name (also: methods for classes)
sch.Statement      = { fg = plt.pigeon } -- (*) Any statement
sch.Object         = { fg = plt.lavender } -- (*) Any statement
sch.Conditional    = { fg = plt.magenta } --   if, then, else, endif, switch, etc.
sch.Repeat         = { fg = plt.cerulean } --   for, do, while, etc.
sch.Label          = { fg = plt.magenta } --   case, default, etc.
sch.Operator       = { fg = plt.orange } --   'sizeof', '+', '*', etc.
sch.Keyword        = { fg = plt.lavender } --   any other keyword
sch.Exception      = { fg = plt.pigeon } --   try, catch, throw
sch.PreProc        = { fg = plt.beige, bold = true } -- (*) Generic Preprocessor
sch.PreCondit      = { link = 'PreProc' } --   Preprocessor #if, #else, #endif, etc.
sch.Include        = { link = 'PreProc' } --   Preprocessor #include
sch.Define         = { link = 'PreProc' } --   Preprocessor #define
sch.Macro          = { link = 'PreProc' } --   Same as Define
sch.Type           = { fg = plt.white } -- (*) int, long, char, etc.
sch.StorageClass   = { link = 'Type' } --   static, register, volatile, etc.
sch.Structure      = { link = 'Type' } --   struct, union, enum, etc.
sch.Typedef        = { fg = plt.beige } --   A typedef
sch.Special        = { fg = plt.orange } -- (*) Any special symbol
sch.SpecialChar    = { link = 'Special' } --   Special character in a constant
sch.Tag            = { fg = plt.flashlight, underline = true } --   You can use CTRL-] on this
sch.Delimiter      = { fg = plt.pigeon } --   Character that needs attention
sch.SpecialComment = { link = 'SpecialChar' } --   Special things inside a comment (e.g. '\n')
sch.Debug          = { link = 'Special' } --   Debugging statements
sch.Underlined     = { underline = true } -- Text that stands out, HTML links
sch.Ignore         = { fg = plt.iron } -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
sch.Error          = { fg = plt.scarlet } -- Any erroneous construct
sch.Todo           = { fg = plt.black, bg = plt.beige, bold = true } -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

-- LSP Highlighting
sch.LspReferenceText            = { link = 'Identifier' } -- Used for highlighting 'text' references
sch.LspReferenceRead            = { link = 'LspReferenceText' } -- Used for highlighting 'read' references
sch.LspReferenceWrite           = { link = 'LspReferenceText' } -- Used for highlighting 'write' references
sch.LspSignatureActiveParameter = { link = 'IncSearch' } -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

-- Diagnostic highlighting
sch.DiagnosticError            = { fg = plt.wine } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticWarn             = { fg = plt.earth } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticInfo             = { fg = plt.flashlight } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticHint             = { fg = plt.white } -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
sch.DiagnosticVirtualTextError = { link = 'DiagnosticError' } -- Used for 'Error' diagnostic virtual text.
sch.DiagnosticVirtualTextWarn  = { link = 'DiagnosticWarn' } -- Used for 'Warn' diagnostic virtual text.
sch.DiagnosticVirtualTextInfo  = { link = 'DiagnosticInfo' } -- Used for 'Info' diagnostic virtual text.
sch.DiagnosticVirtualTextHint  = { link = 'DiagnosticHint' } -- Used for 'Hint' diagnostic virtual text.
sch.DiagnosticUnderlineError   = { undercurl = true, sp = plt.wine } -- Used to underline 'Error' diagnostics.
sch.DiagnosticUnderlineWarn    = { undercurl = true, sp = plt.earth } -- Used to underline 'Warn' diagnostics.
sch.DiagnosticUnderlineInfo    = { undercurl = true, sp = plt.flashlight } -- Used to underline 'Info' diagnostics.
sch.DiagnosticUnderlineHint    = { undercurl = true, sp = plt.white } -- Used to underline 'Hint' diagnostics.
sch.DiagnosticFloatingError    = { link = 'DiagnosticError' } -- Used to color 'Error' diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
sch.DiagnosticFloatingWarn     = { link = 'DiagnosticWarn' } -- Used to color 'Warn' diagnostic messages in diagnostics float.
sch.DiagnosticFloatingInfo     = { link = 'DiagnosticInfo' } -- Used to color 'Info' diagnostic messages in diagnostics float.
sch.DiagnosticFloatingHint     = { link = 'DiagnosticHint' } -- Used to color 'Hint' diagnostic messages in diagnostics float.
sch.DiagnosticSignError        = { link = 'DiagnosticError' } -- Used for 'Error' signs in sign column.
sch.DiagnosticSignWarn         = { link = 'DiagnosticWarn' } -- Used for 'Warn' signs in sign column.
sch.DiagnosticSignInfo         = { link = 'DiagnosticInfo' } -- Used for 'Info' signs in sign column.
sch.DiagnosticSignHint         = { link = 'DiagnosticHint' } -- Used for 'Hint' signs in sign column.

-- Tree-Sitter syntax groups. Most link to corresponding
sch.TSAttribute          = { fg = plt.beige } -- Annotations that can be attached to the code to denote some kind of meta information. e.g. C++/Dart attributes.
sch.TSBoolean            = { link = 'Boolean' } -- Boolean literals: `True` and `False` in Python.
sch.TSCharacter          = { link = 'Character' } -- Character literals: `'a'` in C.
sch.TSCharacterSpecial   = { link = 'SpecialChar' } -- Special characters.
sch.TSComment            = { link = 'Comment' } -- Line comments and block comments.
sch.TSConditional        = { link = 'Conditional' } -- Keywords related to conditionals: `if`, `when`, `cond`, etc.
sch.TSConstant           = { link = 'Constant' } -- Constants identifiers. These might not be semantically constant. E.g. uppercase variables in Python.
sch.TSConstBuiltin       = { link = 'Constant' } -- Built-in constant values: `nil` in Lua.
sch.TSConstMacro         = { link = 'Macro' } -- Constants defined by macros: `NULL` in C.
sch.TSConstructor        = { link = 'Constructor' } -- Constructor calls and definitions: `{}` in Lua, and Java constructors.
sch.TSDebug              = { link = 'Debug' } -- Debugging statements.
sch.TSDefine             = { link = 'Define' } -- Preprocessor #define statements.
sch.TSError              = {} -- Syntax/parser errors. This might highlight large sections of code while the user is typing still incomplete code, use a sensible highlight.
sch.TSException          = { link = 'Exception' } -- Exception related keywords: `try`, `except`, `finally` in Python.
sch.TSField              = { fg = plt.pink } -- Object and struct fields.
sch.TSFloat              = { link = 'Float' } -- Floating-point number literals.
sch.TSFunction           = { link = 'Function' } -- Function calls and definitions.
sch.TSFuncBuiltin        = { link = 'Special' } -- Built-in functions: `print` in Lua.
sch.TSFuncMacro          = { link = 'Macro' } -- Macro defined functions (calls and definitions): each `macro_rules` in Rust.
sch.TSInclude            = { link = 'Include' } -- File or module inclusion keywords: `#include` in C, `use` or `extern crate` in Rust.
sch.TSKeyword            = { link = 'Keyword' } -- Keywords that don't fit into other categories.
sch.TSKeywordFunction    = { fg = plt.beige } -- Keywords used to define a function: `function` in Lua, `def` and `lambda` in Python.
sch.TSKeywordOperator    = { link = 'Operator' } -- Unary and binary operators that are English words: `and`, `or` in Python; `sizeof` in C.
sch.TSKeywordReturn      = { link = 'Special' } -- Keywords like `return` and `yield`.
sch.TSLabel              = { link = 'Label' } -- GOTO labels: `label:` in C, and `::label::` in Lua.
sch.TSMethod             = { link = 'Function' } -- Method calls and definitions.
sch.TSNamespace          = { fg = plt.beige } -- Identifiers referring to modules and namespaces.
sch.TSNone               = {} -- No highlighting (sets all highlight arguments to `NONE`). this group is used to clear certain ranges, for example, string interpolations. Don't change the values of this highlight group.
sch.TSNumber             = { link = 'Number' } -- Numeric literals that don't fit into other categories.
sch.TSOperator           = { link = 'Operator' } -- Binary or unary operators: `+`, and also `->` and `*` in C.
sch.TSParameter          = { link = 'Identifier' } -- Parameters of a function.
sch.TSParameterReference = { link = 'TSParameter' } -- References to parameters of a function.
sch.TSPreCondit          = { link = 'PreCondit' } --   Preprocessor #if, #else, #endif, etc.
sch.TSPreProc            = { link = 'PreProc' } -- Preprocessor #if, #else, #endif, etc.
sch.TSProperty           = { link = 'TSField' } -- Same as `TSField`.
sch.TSPunctDelimiter     = { fg = plt.white } -- Punctuation delimiters: Periods, commas, semicolons, etc.
sch.TSPunctBracket       = { fg = plt.smoke } -- Brackets, braces, parentheses, etc.
sch.TSPunctSpecial       = { fg = plt.beige } -- Special punctuation that doesn't fit into the previous categories.
sch.TSRepeat             = { link = 'Repeat' } -- Keywords related to loops: `for`, `while`, etc.
sch.TSStorageClass       = { fg = plt.steel } -- Keywords that affect how a variable is stored: `static`, `comptime`, `extern`, etc.
sch.TSString             = { link = 'String' } -- String literals.
sch.TSStringRegex        = { link = 'String' } -- Regular expression literals.
sch.TSStringEscape       = { link = 'SpecialChar' } -- Escape characters within a string: `\n`, `\t`, etc.
sch.TSStringSpecial      = { link = 'SpecialChar' } -- Strings with special meaning that don't fit into the previous categories.
sch.TSSymbol             = { link = 'Identifier' } -- Identifiers referring to symbols or atoms.
sch.TSTag                = { link = 'Tag' } -- Tags like HTML tag names.
sch.TSTagAttribute       = { link = 'TSField' } -- HTML tag attributes.
sch.TSTagDelimiter       = { link = 'TSPunctBracket' } -- Tag delimiters like `<` `>` `/`.
sch.TSText               = { fg = plt.smoke } -- Non-structured text. Like text in a markup language.
sch.TSStrong             = { bold = true } -- Text to be represented in bold.
sch.TSEmphasis           = { fg = plt.white, italic = true } -- Text to be represented with emphasis.
sch.TSUnderline          = { underline = true } -- Text to be represented with an underline.
sch.TSStrike             = { strikethrough = true } -- Strikethrough text.
sch.TSTitle              = { link = 'Title' } -- Text that is part of a title.
sch.TSLiteral            = { link = 'String' } -- Literal or verbatim text.
sch.TSURI                = { fg = plt.aqua, underline = true } -- URIs like hyperlinks or email addresses.
sch.TSMath               = { fg = plt.magenta, italic = true } -- Math environments like LaTeX's `$ ... $`
sch.TSTextReference      = { fg = plt.pigeon } -- Footnotes, text references, citations, etc.
sch.TSEnvironment        = { link = 'TSNamespace' } -- Text environments of markup languages.
sch.TSEnvironmentName    = { link = 'TSEnvironment' } -- Text/string indicating the type of text environment. Like the name of a `\begin` block in LaTeX.
sch.TSNote               = { link = 'SpecialChar' } -- Text representation of an informational note.
sch.TSWarning            = { link = 'WarningMsg' } -- Text representation of a warning note.
sch.TSDanger             = { link = 'ErrorMsg' } -- Text representation of a danger note.
sch.TSType               = { link = 'Type' } -- Type (and class) definitions and annotations.
sch.TSTypeBuiltin        = { link = 'Type' } -- Built-in types: `i32` in Rust.
sch.TSVariable           = { link = 'Identifier' } -- Variable names that don't fit into other categories.
sch.TSVariableBuiltin    = { fg = plt.pigeon, italic = true } -- Variable names defined by the language: `this` or `self` in Javascript.
sch.rainbowcol1          = { fg = plt.smoke } -- default light is too bright

-- HTML
sch.htmlArg            = { fg = plt.pigeon }
sch.htmlBold           = { bold = true }
sch.htmlTag            = { fg = plt.smoke }
sch.htmlTagName        = { link = 'Tag' }
sch.htmlSpecialTagName = { fg = plt.yellow }
sch.htmlEndTag         = { fg = plt.yellow }
sch.htmlH1             = { fg = plt.tea, bold = true }
sch.htmlH2             = { fg = plt.aqua, bold = true }
sch.htmlH3             = { fg = plt.turquoise, bold = true }
sch.htmlH4             = { fg = plt.lavender, bold = true }
sch.htmlH5             = { fg = plt.purple, bold = true }
sch.htmlH6             = { fg = plt.pink, bold = true }
sch.htmlItalic         = { italic = true }
sch.htmlLink           = { fg = plt.flashlight, underline = true }
sch.htmlSpecialChar    = { fg = plt.beige }
sch.htmlTitle          = { fg = plt.pigeon }

-- Plugin highlights
-- nvim-cmp
sch.CmpItemAbbr             = { fg = plt.smoke }
sch.CmpItemAbbrDeprecated   = { fg = plt.iron }
sch.CmpItemAbbrMatch        = { fg = plt.white }
sch.CmpItemAbbrMatchFuzzy   = { link = 'CmpItemAbbrMatch' }
sch.CmpItemKindText         = { link = 'String' }
sch.CmpItemKindMethod       = { link = 'TSMethod' }
sch.CmpItemKindFunction     = { link = 'TSFunction' }
sch.CmpItemKindConstructor  = { link = 'TSConstructor' }
sch.CmpItemKindField        = { link = 'TSField' }
sch.CmpItemKindProperty     = { link = 'CmpItemKindField' }
sch.CmpItemKindVariable     = { fg = plt.turquoise }
sch.CmpItemKindReference    = { link = 'CmpItemKindVariable' }
sch.CmpItemKindModule       = { fg = plt.magenta }
sch.CmpItemKindEnum         = { fg = plt.ochre }
sch.CmpItemKindEnumMember   = { link = 'CmpItemKindEnum' }
sch.CmpItemKindKeyword      = { link = 'Keyword' }
sch.CmpItemKindOperator     = { link = 'Operator' }
sch.CmpItemKindSnippet      = { fg = plt.tea }
sch.CmpItemKindColor        = { fg = plt.pink }
sch.CmpItemKindConstant     = { link = 'Constant' }
sch.CmpItemKindCopilot      = { fg = plt.magenta }
sch.CmpItemKindValue        = { link = 'Number' }
sch.CmpItemKindClass        = { fg = plt.aqua }
sch.CmpItemKindStruct       = { fg = plt.cerulean }
sch.CmpItemKindEvent        = { fg = plt.flashlight }
sch.CmpItemKindInterface    = { fg = plt.flashlight }
sch.CmpItemKindFile         = { fg = plt.smoke }
sch.CmpItemKindFolder       = { fg = plt.pigeon }
sch.CmpItemKind             = { fg = plt.iron }
sch.CmpItemMenu             = { fg = plt.smoke }
-- gitsigns
sch.GitSignsAdd             = { fg = plt.tea }
sch.GitSignsDelete          = { fg = plt.scarlet }
sch.GitSignsChange          = { fg = plt.aqua }
sch.GitSignsCurrentLineBlame= { fg = plt.turquoise }
-- barbar
sch.BufferCurrent           = { fg = plt.white, bold = true }
sch.BufferCurrentIndex      = { fg = plt.orange, bold = true }
sch.BufferCurrentMod        = { fg = plt.orange, bold = true }
sch.BufferCurrentSign       = { fg = plt.orange }
sch.BufferInactive          = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveIcon      = { bg = sch.StatusLine.bg }
sch.BufferInactiveIndex     = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveMod       = { fg = plt.wine, bg = plt.deepsea }
sch.BufferInactiveSign      = { fg = plt.pigeon, bg = plt.deepsea }
sch.BufferInactiveTarget    = { fg = plt.wine, bg = plt.deepsea }
sch.BufferVisible           = { fg = plt.pigeon }
sch.BufferVisibleMod        = { fg = plt.orange }
sch.BufferTabpageFill       = { fg = plt.pigeon, bg = plt.deepsea }
-- telescope
sch.TelescopeNormal         = { link = 'NormalFloat' }
sch.TelescopeBorder         = { link = 'NormalFloat' }
sch.TelescopeSelection      = { bg = plt.thunder }
sch.TelescopeMultiSelection = { bg = plt.thunder }
sch.TelescopeMatching       = { link = 'Search' }
sch.TelescopePromptCounter  = { link = 'Comment' }
sch.TelescopePromptPrefix   = { fg = plt.orange }
sch.TelescopeSelectionCaret = { fg = plt.orange, bg = plt.thunder }
-- symbols-outline
sch.FocusedSymbol = { fg = plt.white, bold = true }
-- nvim-navic
sch.NavicIconsFile = { link = 'File' }
sch.NavicIconsModule = { link = 'CmpItemKindModule' }
sch.NavicIconsNamespace = { link = 'TSNamespace' }
sch.NavicIconsPackage = { link = 'CmpItemKindModule' }
sch.NavicIconsClass = { link = 'CmpItemKindClass' }
sch.NavicIconsMethod = { link = 'CmpItemKindMethod' }
sch.NavicIconsProperty = { link = 'CmpItemKindProperty' }
sch.NavicIconsField = { link = 'CmpItemKindField' }
sch.NavicIconsConstructor = { link = 'CmpItemKindConstructor' }
sch.NavicIconsEnum = { link = 'CmpItemKindEnum' }
sch.NavicIconsInterface = { link = 'CmpItemKindInterface' }
sch.NavicIconsFunction = { link = 'Function' }
sch.NavicIconsVariable = { link = 'CmpItemKindVariable' }
sch.NavicIconsConstant = { link = 'Constant' }
sch.NavicIconsString = { link = 'String' }
sch.NavicIconsNumber = { link = 'Number' }
sch.NavicIconsBoolean = { link = 'Boolean' }
sch.NavicIconsArray = { link = 'Array' }
sch.NavicIconsObject = { link = 'Object' }
sch.NavicIconsKey = { link = 'Keyword' }
sch.NavicIconsNull = { link = 'Constant' }
sch.NavicIconsEnumMember = { link = 'CmpItemKindEnumMember' }
sch.NavicIconsStruct = { link = 'CmpItemKindStruct' }
sch.NavicIconsEvent = { link = 'CmpItemKindEvent' }
sch.NavicIconsOperator = { link = 'Operator' }
sch.NavicIconsTypeParameter = { link = 'CmpItemKind' }
sch.NavicText = { fg = plt.smoke, italic = true }
sch.NavicSeparator = { fg = plt.orange }

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

return sch
