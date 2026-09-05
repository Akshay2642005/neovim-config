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
}

return config
