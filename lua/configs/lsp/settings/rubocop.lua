local handlers = require 'lsp.handlers'

--- @class vim.lsp.Config
local config = {
  cmd = {
    'rubocop',
    '--lsp',
  },

  filetypes = {
    'ruby',
  },

  root_markers = {
    '.rubocop.yml',
    'Gemfile',
    '*.gemspec',
    '.git',
  },

  handlers = {
    ['textDocument/publishDiagnostics'] = handlers.filter_diagnostics,
  },
}

return config
