return {
  'stevearc/overseer.nvim',
  lazy = true,
  cmd = { 'OverseerRun', 'OverseerOpen', 'OverseerToggle', 'OverseerInfo', 'OverseerBuild', 'OverseerQuickAction', 'OverseerTaskAction', 'OverseerClearCache' },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    dap = false,
    task_list = {
      direction = "bottom"
    },
    output = {
      use_terminal = false,

      preserve_output = false
    }
  },
}
