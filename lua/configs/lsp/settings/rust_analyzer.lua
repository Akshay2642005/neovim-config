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
        features = { "ssr" },
        loadOutDirsFromCheck = true,
        buildScripts = {
          enable = true,
        },
        check = {
          features = { "ssr" },
        },
        checkOnSave = {
          features = { "ssr" },
          command = "clippy",
          extraArgs = { "--no-deps" },
        },
        extraEnv = {
          CMAKE = [[C:\Program Files\CMake\bin\cmake.exe]],
        },
      },
      procMacro = {
        enable = true,
      },
    },
  },
}

return config
