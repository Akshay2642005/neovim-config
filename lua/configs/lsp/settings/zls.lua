--- @class vim.lsp.Config
local config = {
  filetypes = { 'zig' },
  cmd = {
    '/Users/akshay/.zvm/bin/zls',
  },
  settings = {
    zls = {
      enable_semantic_tokens = true,
      enable_inlay_hints = true,
      warn_style = true,
    },
  },
}

return config
