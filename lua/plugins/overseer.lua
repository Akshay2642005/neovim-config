return {
  'stevearc/overseer.nvim',
  lazy = "true",
  cmd = "Task",
  event = { "BufReadPost", "VeryLazy" },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    task_list = {
      direction = "bottom"
    },
    output = {
      use_terminal = false,

      preserve_output = false
    }
  },
}
