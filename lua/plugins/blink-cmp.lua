return {
  {
    'zbirenbaum/copilot.lua',
    lazy = true,
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      -- Inline ghost-text mode (Zed-style Tab completion). Copilot shows
      -- dimmed text at the cursor; <Tab> (wired in blink.cmp's keymap
      -- below) accepts it. hide_during_completion avoids doubling with
      -- the blink popup menu. No blink-copilot source: running both
      -- shows every suggestion twice (once inline, once in the menu).
      suggestion = {
        enabled = true,
        auto_trigger = true,
        hide_during_completion = true,
        debounce = 75,
        trigger_on_accept = true,
        keymap = {
          accept = false, -- accepted via blink.cmp <Tab> handler instead
          accept_word = '<M-w>',
          accept_line = '<M-l>',
          next = '<M-]>',
          prev = '<M-[>',
          dismiss = '<C-]>',
        },
      },
      panel = { enabled = false },
      filetypes = {
        markdown = true,
        help = true,
      },
    },
  },
  {
    'Saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    lazy = true,
    version = '*',
    dependencies = {
      'Kaiser-Yang/blink-cmp-avante',
    },
    opts = {
      enabled = function()
        return vim.bo.buftype ~= 'prompt'
            and vim.b.completion ~= false
      end,
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide' },
        ['<CR>'] = { 'fallback' },
        -- <Tab>: Copilot ghost text first, then blink popup. One key for
        -- both keeps Zed-style muscle memory; copilot is hidden while the
        -- popup menu is open (hide_during_completion) so they rarely race.
        ['<Tab>'] = {
          function(cmp)
            local ok, suggestion = pcall(require, 'copilot.suggestion')
            if ok and suggestion.is_visible() then
              suggestion.accept()
              return true
            end
          end,
          'snippet_forward',
          'accept',
          'select_next',
          'fallback',
        },
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
        default = { 'lsp', 'path', 'buffer', 'avante' },
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
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
          },
        },
      },
      cmdline = { enabled = true },
    },
  },
}
