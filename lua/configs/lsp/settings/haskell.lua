--- @class vim.lsp.Config
local config = {
  settings = {
    filetypes = { "haskell" },
    haskell = {
      formattingProvider = "ormolu", -- or "fourmolu", "stylish-haskell"

      plugin = {
        -- Diagnostics / linting
        hlint = {
          globalOn = true,
        },

        -- Type lenses (top-level type signatures)
        typeLenses = {
          globalOn = true,
        },

        -- Imports & code actions
        importLens = {
          globalOn = true,
        },

        -- Tactics / refactors
        tactics = {
          globalOn = true,
        },

        -- Evaluation via ghci
        eval = {
          globalOn = true,
        },

        -- Explicit fields in records
        recordDot = {
          globalOn = true,
        },
      },
    },
  },
}

return config
