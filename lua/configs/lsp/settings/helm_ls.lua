---@type vim.lsp.Config
local config = {
  cmd = {
    'helm_ls',
    'serve',
  },

  filetypes = {
    'helm',
  },

  root_markers = {
    'Chart.yaml',
  },

  settings = {
    ['helm-ls'] = {
      yamlls = {
        enabled = true,
      },
    },
  },
}

return config
