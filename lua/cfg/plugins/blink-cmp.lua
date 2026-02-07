return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'Saghen/blink.cmp',
    event = 'InsertEnter',
    version = '*',
    dependencies = {
      'fang2hou/blink-copilot',
    },
    config = function()
      require('blink-cmp').setup {
        keymap = {
          ['<C-space>'] = {
            'show',
            'show_documentation',
            'hide_documentation',
          },
          ['<C-e>'] = { 'hide' },
          ['<CR>'] = { 'fallback' },

          ['<Tab>'] = { 'snippet_forward', 'accept', 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
        },
        completion = {
          accept = {
            resolve_timeout_ms = 10000,
            auto_brackets = {
              enabled = false,
            },
          },
          list = {
            selection = {
              auto_insert = true,
              preselect = true,
            },
          },
          ghost_text = {
            enabled = true,
          },
          menu = {
            auto_show = true,
            border = 'none',
            draw = {
              columns = {
                {
                  'label',
                  gap = 1,
                },
                { 'kind' },
              },
            },
          },
          documentation = {
            auto_show = true,
            auto_show_delay_ms = 0,
            window = {
              border = 'none',
            },
          },
        },
        signature = {
          trigger = {
            enabled = true,
          },
          window = {
            border = 'none',
          },
        },
        appearance = {
          use_nvim_cmp_as_default = false,
        },
        sources = {
          default = { 'lsp', 'path', 'buffer', 'copilot' },
          providers = {
            lsp = {
              timeout_ms = 10000,
            },
            copilot = {
              name = 'copilot',
              module = 'blink-copilot',
              score_offset = 100,
              async = true,
              opts = {
                max_completions = 3,
              },
            },
          },
        },
        cmdline = {
          enabled = true,
        },
      }
    end,
  },
}
