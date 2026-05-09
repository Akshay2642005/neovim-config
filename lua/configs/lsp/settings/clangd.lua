--- @class vim.lsp.Config
local config = {
  cmd = {
    "clangd",
    "--query-driver=C:/msys64/ucrt64/bin/*",
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
