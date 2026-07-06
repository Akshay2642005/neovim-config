vim.keymap.set("n", "<leader>ob", function()
  require("overseer").run_template({ name = "CMake Build (Visual Studio Debug)" })
  require("overseer").toggle()
end)
