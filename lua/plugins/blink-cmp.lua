return {
  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    cmd = 'Copilot',
    event = { 'VeryLazy', 'InsertEnter' },
    opts = {
      suggestion = { enabled = true },
      panel = { enabled = true },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'Saghen/blink.cmp',
    event = { 'VeryLazy', 'InsertEnter' },
    lazy = true,
    version = '*',
    dependencies = {
      'fang2hou/blink-copilot',
    },
    opts = {
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<CR>'] = { 'fallback' },
        ['<Tab>'] = { 'snippet_forward', 'accept', 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
      },
      completion = {
        accept = {
          resolve_timeout_ms = 50,
          auto_brackets = { enabled = false },
        },
        list = {
          selection = {
            auto_insert = true,
            preselect = true,
          },
          max_items = 20,
        },
        ghost_text = { enabled = true },
        menu = {
          auto_show = true,
          border = 'none',
          draw = {
            columns = { { 'label', gap = 1 }, { 'kind' } },
            treesitter = { 'lsp' },
          },
        },
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 100,
          window = { border = 'none' },
        },
      },
      signature = {
        enabled = true,
        trigger = { enabled = true },
        window = { border = 'none' },
      },
      appearance = {
        use_nvim_cmp_as_default = false,
      },
      sources = {
        default = { 'lsp', 'path', 'buffer', 'copilot' },
        per_filetype = {
          lua = { 'lsp', 'path', 'buffer' },
        },
        providers = {
          lsp = {
            timeout_ms = 150,
            score_offset = 90,
            async = true,
          },
          path = {
            timeout_ms = 50,
            score_offset = 50,
          },
          buffer = {
            timeout_ms = 50,
            max_items = 3,
            score_offset = 30,
            min_keyword_length = 3,
          },
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 80,
            async = true,
            timeout_ms = 300,
            opts = {
              max_completions = 1,
            },
          },
        },
      },
      cmdline = { enabled = true },
    },
  },
}
