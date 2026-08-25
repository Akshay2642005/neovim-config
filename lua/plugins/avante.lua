return {
  'yetone/avante.nvim',
  lazy = true,
  event = 'VeryLazy',
  build = vim.fn.has('win32') ~= 0
      and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false'
    or 'make',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'folke/snacks.nvim',
    'MeanderingProgrammer/render-markdown.nvim',
  },
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    provider = 'opencode',
    mode = 'agentic',
    selector = {
      provider = 'snacks',
      provider_opts = {},
    },
    file_selector = {
      provider_opts = {
        get_filepaths = function(params)
          local cwd = params.cwd
          local handle = io.popen('git -C "' .. cwd .. '" ls-files --cached --others --exclude-standard 2>/dev/null')
          if not handle then return {} end
          local result = {}
          for line in handle:lines() do
            table.insert(result, line)
          end
          handle:close()
          return result
        end,
      },
    },
    input = {
      provider = 'native',
      provider_opts = {},
    },
    behaviour = {
      auto_suggestions = false,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true,
      enable_token_counting = true,
      auto_add_current_file = true,
      auto_approve_tool_permissions = true,
    },
    acp_providers = {
      opencode = {
        command = 'opencode',
        args = { 'acp' },
      },
    },
    providers = {
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-sonnet-4-20250514',
        timeout = 30000,
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
    },
    windows = {
      position = 'right',
      wrap = true,
      width = 30,
      sidebar_header = {
        enabled = true,
        align = 'center',
        rounded = true,
      },
      input = {
        prefix = '> ',
        height = 8,
      },
      edit = {
        border = 'rounded',
        start_insert = true,
      },
      ask = {
        floating = false,
        start_insert = true,
        border = 'rounded',
        focus_on_apply = 'ours',
      },
    },
    diff = {
      autojump = true,
      list_opener = 'copen',
      override_timeoutlen = 500,
    },
    suggestion = {
      debounce = 600,
      throttle = 600,
    },
    mappings = {
      sidebar = {
        apply_all = 'A',
        apply_cursor = 'a',
        retry_user_request = 'r',
        edit_user_request = 'e',
        switch_windows = '<Tab>',
        reverse_switch_windows = '<S-Tab>',
        remove_file = 'd',
        add_file = '@',
        close = { '<Esc>', 'q' },
      },
      diff = {
        ours = 'co',
        theirs = 'ct',
        all_theirs = 'ca',
        both = 'cb',
        cursor = 'cc',
        next = ']x',
        prev = '[x',
      },
      suggestion = {
        accept = '<M-l>',
        next = '<M-]>',
        prev = '<M-[>',
        dismiss = '<C-]>',
      },
      submit = {
        normal = '<CR>',
        insert = '<C-s>',
      },
      cancel = {
        normal = { '<C-c>', '<Esc>', 'q' },
        insert = { '<C-c>' },
      },
    },
  },
  config = function(_, opts)
    require('avante').setup(opts)

    vim.api.nvim_create_user_command('AvanteClear', function()
      local avante = require('avante')
      if avante.clear_history then
        avante.clear_history()
      end
    end, { desc = 'Clear avante chat history' })
  end,
}
