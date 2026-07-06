--- @class vim.lsp.Config
local config = {
  filetypes = { 'zig' },
  settings = {
    zls = {
      enable_semantic_tokens = true,
      enable_inlay_hints = true,
      warn_style = true
    }
  },
}

return config
