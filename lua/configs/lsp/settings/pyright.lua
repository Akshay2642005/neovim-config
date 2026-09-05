--- @class vim.lsp.Config
local config = {
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false,
    },

    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = 'workspace',
        typeCheckingMode = 'basic',
        useLibraryCodeForTypes = true,

        extraPaths = {
          '/Users/akshay/.local/share/uv/tools/conan/lib/python3.12/site-packages',
        },
      },
    },
  },

  single_file_support = true,
}

return config
