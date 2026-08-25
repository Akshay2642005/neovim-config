return {
  'rcarriga/nvim-dap-virtual-text',
  lazy = true,
  dependencies = { 'mfussenegger/nvim-dap' },
  opts = {
    enabled = true,
    enable_commands = true,
    highlight_changed_variables = true,
    highlight_new_as_changed = false,
    show_stop_reason = true,
    commented = false,
    only_first_definition = true,
    all_references = false,
    clear_on_continue = false,
    display_callback = function(variable, buf, stack_options, options)
      if variable.value and #variable.value > 15 then
        return ' = ' .. string.sub(variable.value, 1, 15) .. '...'
      end
      return ' = ' .. variable.value
    end,
  },
  config = function(_, opts)
    require('nvim-dap-virtual-text').setup(opts)
  end,
}
