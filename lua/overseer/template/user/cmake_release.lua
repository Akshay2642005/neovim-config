return {
  name = "CMake Build (Release)",
  builder = function()
    local cmake_file = vim.fs.find("CMakeLists.txt", { upward = true })[1]
    if not cmake_file then
      vim.notify("CMakeLists.txt not found", vim.log.levels.ERROR)
      return
    end
    local root = vim.fs.dirname(cmake_file)
    local config = vim.g.cmake_build_type or "Release"
    local sep = vim.fn.has("win32") == 1 and "\\" or "/"
    local build_dir = root .. sep .. "build"
    local njobs = vim.loop.available_parallelism and vim.loop.available_parallelism() or 8

    local configure_cmd, build_cmd, cmd, args

    if vim.fn.has("win32") == 1 then
      -- Windows: MSVC via vcvarsall + vcpkg toolchain
      local vcvars = "C:\\Program Files\\Microsoft Visual Studio\\18\\Insiders\\VC\\Auxiliary\\Build\\vcvarsall.bat"
      local toolchain = "-DCMAKE_TOOLCHAIN_FILE=C:\\vcpkg\\scripts\\buildsystems\\vcpkg.cmake"

      configure_cmd = string.format(
        'call "%s" x64 && cmake -S "%s" -B "%s" -G "Ninja" -DCMAKE_BUILD_TYPE=%s %s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
        vcvars, root, build_dir, config, toolchain
      )
      build_cmd = string.format('cmake --build "%s" -- -j %d', build_dir, njobs)

      cmd = { "cmd.exe", "/c" }
      args = { configure_cmd .. " && " .. build_cmd }
    elseif vim.fn.has("mac") == 1 then
      -- macOS: brew-managed toolchain, no vcpkg
      configure_cmd = string.format(
        'cmake -S "%s" -B "%s" -G "Ninja" -DCMAKE_BUILD_TYPE=%s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON -DCMAKE_PREFIX_PATH=/opt/homebrew',
        root, build_dir, config
      )
      build_cmd = string.format('cmake --build "%s" -- -j %d', build_dir, njobs)

      cmd = { "/bin/zsh", "-c" }
      args = { configure_cmd .. " && " .. build_cmd }
    else
      -- Linux: system toolchain (gcc/clang via apt/pacman/etc), no vcpkg
      configure_cmd = string.format(
        'cmake -S "%s" -B "%s" -G "Ninja" -DCMAKE_BUILD_TYPE=%s -DCMAKE_EXPORT_COMPILE_COMMANDS=ON',
        root, build_dir, config
      )
      build_cmd = string.format('cmake --build "%s" -- -j %d', build_dir, njobs)

      cmd = { "/bin/bash", "-c" }
      args = { configure_cmd .. " && " .. build_cmd }
    end

    return {
      cmd = cmd,
      args = args,
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
