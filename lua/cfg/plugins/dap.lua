return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
    },
    keys = {
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle breakpoint',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Conditional breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Run to cursor',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step into',
      },
      {
        '<leader>do',
        function()
          require('dap').step_over()
        end,
        desc = 'Step over',
      },
      {
        '<leader>dO',
        function()
          require('dap').step_out()
        end,
        desc = 'Step out',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = 'Pause',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = 'Toggle REPL',
      },
      {
        '<leader>ds',
        function()
          require('dap').session()
        end,
        desc = 'Session',
      },
      {
        '<leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = 'Terminate',
      },
      {
        '<leader>du',
        function()
          require('dapui').toggle()
        end,
        desc = 'Toggle DAP UI',
      },
      {
        '<leader>de',
        function()
          require('dapui').eval()
        end,
        mode = { 'n', 'v' },
        desc = 'Eval expression',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('nvim-dap-virtual-text').setup {
        commented = true,
      }

      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸', current_frame = '▸' },
        mappings = {
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        layouts = {
          {
            elements = {
              { id = 'scopes',      size = 0.25 },
              { id = 'breakpoints', size = 0.25 },
              { id = 'stacks',      size = 0.25 },
              { id = 'watches',     size = 0.25 },
            },
            size = 40,
            position = 'left',
          },
          {
            elements = {
              { id = 'repl',    size = 0.5 },
              { id = 'console', size = 0.5 },
            },
            size = 10,
            position = 'bottom',
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = 'single',
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
      }

      -- Auto open/close DAP UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Signs
      vim.fn.sign_define(
        'DapBreakpoint',
        { text = '●', texthl = 'DapBreakpoint', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '●', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapLogPoint',
        { text = '◆', texthl = 'DapLogPoint', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapStopped',
        { text = '▶', texthl = 'DapStopped', linehl = 'DapStoppedLine', numhl = '' }
      )
      vim.fn.sign_define(
        'DapBreakpointRejected',
        { text = '○', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' }
      )

      -- Highlight groups
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#f5a623' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })
      vim.api.nvim_set_hl(0, 'DapStoppedLine', { bg = '#2e4d3d' })
      vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#656565' })
    end,
  },
}
