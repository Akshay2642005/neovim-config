local handlers = require 'lsp.handlers'

--- @class vim.lsp.Config
local config = {
  cmd = {
    'neocmakelsp',
    'stdio',
  },

  filetypes = {
    'cmake',
  },

  root_markers = {
    'CMakeLists.txt',
    '.git',
  },

  settings = {
    line_max_words = 9999,
  },

  handlers = {
    ['textDocument/publishDiagnostics'] = handlers.filter_diagnostics,
  },
}

return config
