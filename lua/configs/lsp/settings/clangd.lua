--- @class vim.lsp.Config
local config = {
  cmd = {
    "clangd",
    "--compile-commands-dir=build",
    "--background-index",
    "--clang-tidy",
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
}

return config
