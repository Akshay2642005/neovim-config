local overseer = require 'overseer'

local function find_project_root()
  local cwd = vim.fn.getcwd()

  local root = vim.fs.root(cwd, { 'build.zig', '.git' })

  return root or cwd
end

local function get_zig_steps()
  local root = find_project_root()

  local result = vim
    .system({ 'zig', 'build', '--help' }, {
      cwd = root,
      text = true,
    })
    :wait()

  if result.code ~= 0 then
    return {}
  end

  local steps = {}
  local in_steps = false

  for line in result.stdout:gmatch '[^\r\n]+' do
    -- Zig's help output contains:
    --
    -- Steps:
    --   install      Copy build artifacts to prefix
    --   uninstall    Remove build artifacts from prefix
    --   ...
    if line:match '^Steps:%s*$' then
      in_steps = true
    elseif in_steps then
      -- Stop when the next non-indented section starts.
      if not line:match '^%s+' and line ~= '' then
        break
      end

      -- Extract:
      --   step-name    description
      local name, description = line:match '^%s+([%w_%-%.]+)%s+(.+)$'

      if name then
        table.insert(steps, {
          name = name,
          description = description,
        })
      end
    end
  end

  return steps
end

return {
  name = 'Zig',
  generator = function(_, cb)
    local root = find_project_root()

    if vim.fn.filereadable(root .. '/build.zig') ~= 1 then
      cb {}
      return
    end

    local steps = get_zig_steps()
    local tasks = {}

    for _, step in ipairs(steps) do
      table.insert(tasks, {
        name = 'Zig: ' .. step.name,
        desc = step.description,

        builder = function()
          return {
            cmd = { 'zig', 'build', step.name },

            cwd = root,

            components = {
              'default',
              'on_output_quickfix',
            },
          }
        end,

        condition = {
          callback = function()
            return vim.fn.filereadable(root .. '/build.zig') == 1
          end,
        },
      })
    end

    cb(tasks)
  end,

  condition = {
    callback = function()
      local root = find_project_root()

      return vim.fn.executable 'zig' == 1
        and vim.fn.filereadable(root .. '/build.zig') == 1
    end,
  },
}
