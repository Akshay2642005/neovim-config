local overseer = require 'overseer'

local function find_project_root()
  local cwd = vim.fn.getcwd()
  local root = vim.fs.root(cwd, { 'CMakeLists.txt', '.git' })
  return root or cwd
end

local function build_dir(root)
  return root .. '/build'
end

local function is_configured(root)
  return vim.fn.filereadable(build_dir(root) .. '/CMakeCache.txt') == 1
end

local function get_generator(root)
  local cache = build_dir(root) .. '/CMakeCache.txt'
  local f = io.open(cache, 'r')
  if not f then
    return nil
  end
  local content = f:read '*a'
  f:close()
  return content:match 'CMAKE_GENERATOR:INTERNAL=([^\r\n]+)'
end

local function get_cmake_targets(root)
  local generator = get_generator(root)
  local bdir = build_dir(root)
  local targets = {}

  if generator and generator:match 'Ninja' then
    local result = vim
      .system({ 'ninja', '-C', bdir, '-t', 'targets' }, { text = true })
      :wait()
    if result.code ~= 0 then
      return {}
    end
    for line in result.stdout:gmatch '[^\r\n]+' do
      local name, kind = line:match '^([%w_%-%./]+):%s*(%a+)$'
      if name and not name:match '/' and not name:match '^CMakeFiles' then
        table.insert(targets, { name = name, description = kind })
      end
    end
  else
    local result = vim
      .system({ 'cmake', '--build', bdir, '--target', 'help' }, { text = true })
      :wait()
    if result.code ~= 0 then
      return {}
    end
    for line in result.stdout:gmatch '[^\r\n]+' do
      local name = line:match '^%.%.%.%s+([%w_%-%.]+)'
      if name and name ~= 'edit_cache' and name ~= 'rebuild_cache' then
        table.insert(targets, { name = name, description = 'target' })
      end
    end
  end

  return targets
end

return {
  name = 'CMake',
  generator = function(_, cb)
    local root = find_project_root()
    if vim.fn.filereadable(root .. '/CMakeLists.txt') ~= 1 then
      cb {}
      return
    end

    local bdir = build_dir(root)
    local tasks = {}

    table.insert(tasks, {
      name = 'CMake: Configure',
      builder = function()
        return {
          name = 'CMake: Configure',
          cmd = { 'cmake' },
          args = {
            '-S',
            '.',
            '-B',
            'build',
            '-DCMAKE_BUILD_TYPE=Debug',
            '-G',
            'Ninja',
          },
          cwd = root,
          components = { 'default', 'on_output_quickfix' },
        }
      end,
    })

    if is_configured(root) then
      table.insert(tasks, {
        name = 'CMake: Build All',
        builder = function()
          return {
            name = 'CMake: Build All',
            cmd = { 'cmake' },
            args = {
              '--build',
              bdir,
              '-j',
              tostring(vim.uv.available_parallelism()),
            },
            cwd = root,
            components = { 'default', 'on_output_quickfix' },
          }
        end,
      })

      table.insert(tasks, {
        name = 'CMake: Clean',
        builder = function()
          return {
            name = 'CMake: Clean',
            cmd = { 'cmake' },
            args = { '--build', bdir, '--target', 'clean' },
            cwd = root,
            components = { 'default', 'on_output_quickfix' },
          }
        end,
      })

      local targets = get_cmake_targets(root)
      for _, t in ipairs(targets) do
        local task_name = 'CMake: Build ' .. t.name
        table.insert(tasks, {
          name = task_name,
          desc = t.description,
          builder = function()
            return {
              name = task_name,
              cmd = { 'cmake' },
              args = { '--build', bdir, '--target', t.name },
              cwd = root,
              components = { 'default', 'on_output_quickfix' },
            }
          end,
        })

        local bin_path = root .. '/bin/' .. t.name
        if vim.fn.executable(bin_path) == 1 then
          local run_name = 'CMake: Run ' .. t.name
          table.insert(tasks, {
            name = run_name,
            builder = function()
              return {
                name = run_name,
                cmd = { bin_path },
                cwd = root,
                components = { 'default' },
              }
            end,
          })
        end
      end
    end

    cb(tasks)
  end,
  condition = {
    callback = function()
      local root = find_project_root()
      return vim.fn.executable 'cmake' == 1
        and vim.fn.filereadable(root .. '/CMakeLists.txt') == 1
    end,
  },
}
