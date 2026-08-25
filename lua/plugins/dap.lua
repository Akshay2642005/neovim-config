-- Debugging: nvim-dap + nvim-dap-ui, adapters resolved from mason's bin dir.
-- Install adapters with :MasonInstallAll (see configs/mason/packages.lua).
return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'DAP: Continue / start debug session' },
    { '<F10>', function() require('dap').step_over() end, desc = 'DAP: Step over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'DAP: Step into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'DAP: Step out' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
    { '<leader>dB', function() require('dap').clear_breakpoints() end, desc = 'Clear breakpoints' },
    { '<leader>du', function() require('dapui').toggle() end, desc = 'Toggle DAP UI' },
    { '<leader>dr', function() require('dap').run_last() end, desc = 'Run last debug session' },
    { '<leader>dx', function() require('dap').terminate() end, desc = 'Terminate debug session' },
  },
  cmd = {
    'DapToggleBreakpoint',
    'DapContinue',
    'DapTerminate',
    'DapDisconnect',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin'

    -- C / C++ / Rust via codelldb
    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = mason_bin .. '/codelldb',
        args = { '--port', '${port}' },
      },
    }

    -- Go via delve
    dap.adapters.delve = {
      type = 'server',
      port = '${port}',
      executable = {
        command = mason_bin .. '/dlv',
        args = { 'dap', '-l', '127.0.0.1:${port}' },
      },
    }

    -- Python via mason's debugpy-adapter
    dap.adapters.python = {
      type = 'server',
      host = '127.0.0.1',
      port = '${port}',
      executable = {
        command = mason_bin .. '/debugpy-adapter',
        args = {},
      },
    }

    local function input_program()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end

    dap.configurations.c = {
      {
        name = 'Launch (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = input_program,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = {
      {
        name = 'Launch (codelldb)',
        type = 'codelldb',
        request = 'launch',
        program = input_program,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
      },
    }

    dap.configurations.go = {
      {
        name = 'Debug file',
        type = 'delve',
        request = 'launch',
        program = '${file}',
      },
      {
        name = 'Debug package (tests)',
        type = 'delve',
        request = 'launch',
        mode = 'test',
        program = '${workspaceFolder}',
      },
    }

    dap.configurations.python = {
      {
        name = 'Launch file',
        type = 'python',
        request = 'launch',
        program = '${file}',
        console = 'integratedTerminal',
      },
      {
        name = 'Attach to :5678',
        type = 'python',
        request = 'attach',
        connect = { host = '127.0.0.1', port = 5678 },
      },
    }

    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '✗', texthl = 'DapBreakpointRejected' })
    vim.fn.sign_define('DapStopped', { text = '→', texthl = 'DapStopped', linehl = 'DapStoppedLine' })

    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
    dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
    dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
  end,
}
