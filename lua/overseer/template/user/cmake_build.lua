return {
  name = "CMake Build",
  builder = function()
    local cmake_file = vim.fs.find("CMakeLists.txt", { upward = true })[1]
    if not cmake_file then
      vim.notify("CMakeLists.txt not found", vim.log.levels.ERROR)
      return
    end
    local root = vim.fs.dirname(cmake_file)
    local build_dir = root .. "\\build"
    return {
      cmd = { "cmd.exe", "/c" },
      args = {
        string.format(
          'cmake -S "%s" -B "%s" && cmake --build "%s"',
          root,
          build_dir,
          build_dir
        )
      },
      cwd = root,
      components = {
        { "on_output_quickfix", open = false },
        { "on_exit_set_status" },
        { "on_complete_notify", statuses = {} }
      },
    }
  end,
  condition = {
    filetype = { "c", "cpp", "cmake" },
    callback = function()
      return vim.fs.find("CMakeLists.txt", { upward = true })[1] ~= nil
    end,
  },
}
