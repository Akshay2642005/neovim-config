return {
  'stevearc/overseer.nvim',
  lazy = true,
  cmd = {
    'OverseerRun',
    'OverseerOpen',
    'OverseerToggle',
    'OverseerInfo',
    'OverseerBuild',
    'OverseerQuickAction',
    'OverseerTaskAction',
    'OverseerClearCache',
  },
  ---@module 'overseer'
  ---@type overseer.SetupOpts
  opts = {
    dap = true,
    task_list = {
      direction = 'left',
    },
    output = {
      use_terminal = false,
      preserve_output = false,
    },
    component_aliases = {
      default = {
        -- { "on_output_quickfix", open = true, focus = true },
        'on_exit_set_status',
        { 'on_complete_notify', statuses = { 'FAILURE' } },
        { 'on_complete_dispose', require_view = { 'SUCCESS', 'FAILURE' } },
      },
    },
  },
}
