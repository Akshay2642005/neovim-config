--- @class vim.lsp.Config
local config = {
  cmd = { 'terraform-ls', 'serve' },

  filetypes = {
    'terraform',
    'terraform-vars',
  },

  root_markers = {
    '.terraform',
    '.git',
  },

  settings = {
    ['terraform-ls'] = {
      experimentalFeatures = {
        prefillRequiredFields = true,
      },
    },
  },
}

return config
