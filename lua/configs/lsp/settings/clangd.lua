--- @class vim.lsp.Config
local config = {
  cmd = {
    "clangd",
    "--query-driver=**",
  },

  init_options = {
    clangdFileStatus = true,
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
  },

  on_init = function(client)
    local root_dir = client.config.root_dir

    if root_dir and vim.uv.fs_stat(root_dir .. "/sdkconfig") then
      client:stop()

      vim.schedule(function()
        vim.lsp.start({
          name = "esp-clangd",

          cmd = {
            "/Users/akshay/.espressif/tools/esp-clang/esp-20.1.1_20250829/esp-clang/bin/clangd",
            "--query-driver=**",
          },

          root_dir = root_dir,

          init_options = {
            clangdFileStatus = true,
          },

          filetypes = {
            "c",
            "cpp",
            "objc",
            "objcpp",
            "cuda",
          },
        })
      end)

      return
    end
  end,
}

return config
