local icons = require('utils.static').icons
local default_config = require('configs.lsp-server-configs.shared.default')

require('clangd_extensions').setup({
  server = default_config,
  extensions = {
    ast = {
      role_icons = {
        ['type'] = icons.Type,
        ['declaration'] = icons.Function,
        ['expression'] = icons.Snippet,
        ['specifier'] = icons.Specifier,
        ['statement'] = icons.Statement,
        ['template argument'] = icons.TypeParameter,
      },
      kind_icons = {
        ['Compound'] = icons.Namespace,
        ['Recovery'] = icons.DiagnosticSignError,
        ['TranslationUnit'] = icons.Unit,
        ['PackExpansion'] = icons.Ellipsis,
        ['TemplateTypeParm'] = icons.TypeParameter,
        ['TemplateTemplateParm'] = icons.TypeParameter,
        ['TemplateParamObject'] = icons.TypeParameter,
      },
    },
    memory_usage = {
      border = 'single',
    },
    symbol_info = {
      border = 'single',
    },
  },
})
