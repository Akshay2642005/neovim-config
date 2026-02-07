-- https://rust-analyzer.github.io/manual.html#configuration

--- @class vim.lsp.Config
local config = {
  settings = {
    ['rust-analyzer'] = {
      check = {
        command = 'clippy',
      },
      cargo = {
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

return config
