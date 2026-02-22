return {
  name = "Dotnet Build",
  builder = function()
    local csproj = vim.fs.find(function(name)
      return name:match("%.csproj$")
    end, { upward = true, type = "file" })[1]

    if not csproj then
      vim.notify("*.csproj not found", vim.log.levels.ERROR)
      return
    end

    local root = vim.fs.dirname(csproj)

    return {
      cmd = { "dotnet" },
      args = { "build" },
      cwd = root,
      components = {
        { "on_output_quickfix", open = false },
        { "on_exit_set_status" },
        { "on_complete_notify", statuses = {} },
      },
    }
  end,
  condition = {
    filetype = { "cs", "csproj" },
    callback = function()
      return vim.fs.find(function(name)
        return name:match("%.csproj$")
      end, { upward = true, type = "file" })[1] ~= nil
    end,
  },
}
