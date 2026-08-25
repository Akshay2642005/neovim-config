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
    },
    task_builder = function(self, params)
      local components = { unpack(self.components) }
      -- Inject quickfix + error notify for all tasks
      table.insert(components, 1, { "on_output_quickfix", open = true, focus = true })
      table.insert(components, 2, { "on_complete_notify", statuses = { "FAILURE" } })
      return vim.tbl_extend("force", self, {
        components = components,
      })
    end,
  },
}
