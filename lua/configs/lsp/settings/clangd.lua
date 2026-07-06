--- @class vim.lsp.Config
local config = {
  cmd = {
    "clangd",
    "--query-driver=**",
    "--compile-commands-dir=target/debug",
  },
  workspace_required = true,
  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },
}

return config
