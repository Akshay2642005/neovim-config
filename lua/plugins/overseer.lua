return {
  'stevearc/overseer.nvim',
  lazy = "true",
  cmd = "Task",
  event = { "BufReadPost", "VeryLazy" },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    task_list = {
      direction = "left"
    },
    output = {
      use_terminal = false,
      preserve_output = true
    }
  },
}
