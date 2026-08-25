---@class vim.lsp.Config
local config = {
  filetypes = { 'haskell' },
  settings = {
    haskell = {
      formattingProvider = 'ormolu',

      plugin = {
        hlint = {
          globalOn = true,
        },
        typeLenses = {
          globalOn = true,
        },
        importLens = {
          globalOn = true,
        },
        tactics = {
          globalOn = true,
        },
        eval = {
          globalOn = true,
        },
        recordDot = {
          globalOn = true,
        },
      },
    },
  },
}

return config
