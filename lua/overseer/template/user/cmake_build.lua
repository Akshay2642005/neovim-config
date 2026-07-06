return {
  name = "CMake Build (Visual Studio Debug)",
  builder = function()
    local cmake_file = vim.fs.find("CMakeLists.txt", { upward = true })[1]
    if not cmake_file then
      vim.notify("CMakeLists.txt not found", vim.log.levels.ERROR)
      return
    end
    local root = vim.fs.dirname(cmake_file)

    local vcvars = "C:\\Program Files\\Microsoft Visual Studio\\18\\Insiders\\VC\\Auxiliary\\Build\\vcvarsall.bat"

    local config = vim.g.cmake_build_type or "Debug"
    local build_dir = root .. "\\build"
    local toolchain = "-DCMAKE_TOOLCHAIN_FILE=C:\\vcpkg\\scripts\\buildsystems\\vcpkg.cmake"

    local configure_cmd = string.format(
      'call "%s" x64 && cmake -S "%s" -B "%s" -G "Ninja" -DCMAKE_BUILD_TYPE=%s %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
      vcvars,
      root,
      build_dir,
      config,
      toolchain
    )

    local build_cmd = string.format(
      'cmake --build "%s" -- -j 14',
      build_dir
    )

    return {
      cmd = { "cmd.exe", "/c" },
      args = { configure_cmd .. " && " .. build_cmd },
      cwd = root,
      components = {
        { "restart_on_save",    paths = { vim.fn.expand("%:p") } },
        { "on_output_quickfix", open = false },
        { "on_exit_set_status" },
        { "on_complete_notify", statuses = {} },
        "default"
      },
    }
  end,
}
