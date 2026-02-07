return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    delay = 300,
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = false,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = true,
        windows = true,
        nav = true,
        z = true,
        g = true,
      },
    },
    win = {
      padding = { 1, 2 },
      title = true,
      title_pos = 'center',
      border = 'single',
    },
    icons = {
      breadcrumb = '»',
      separator = '➜',
      group = '+ ',
      mappings = false,
    },
    spec = {
      -- Top-level groups
      { '<leader>b',       group = 'Buffer' },
      { '<leader>c',       group = 'Code/Colorizer' },
      { '<leader>d',       group = 'Diagnostics' },
      { '<leader>f',       group = 'Find/Files' },
      { '<leader>g',       group = 'Git' },
      { '<leader>h',       group = 'Help' },
      { '<leader>i',       group = 'Inlay Hints' },
      { '<leader>l',       group = 'LSP/Live Grep' },
      { '<leader>n',       group = 'No Highlight' },
      { '<leader>o',       group = 'Organize' },
      { '<leader>r',       group = 'Refresh/Rename' },
      { '<leader>s',       group = 'Switch/Symbols' },
      { '<leader>t',       group = 'Terminal/Tests' },
      { '<leader>w',       group = 'Workspace/Wrap' },

      -- Grapple group (semicolon prefix)
      { ';',               group = 'Grapple' },
      { ';',               desc = 'Grapple toggle tag',     mode = 'n' },
      { ';;',              desc = 'Grapple open tags' },
      { ';1',              desc = 'Grapple tag 1' },
      { ';2',              desc = 'Grapple tag 2' },
      { ';3',              desc = 'Grapple tag 3' },
      { ';4',              desc = 'Grapple tag 4' },
      { ';5',              desc = 'Grapple tag 5' },
      { ';6',              desc = 'Grapple tag 6' },
      { ';7',              desc = 'Grapple tag 7' },
      { ';8',              desc = 'Grapple tag 8' },
      { ';9',              desc = 'Grapple tag 9' },

      -- LSP-related keymaps (will show when LSP attaches)
      { 'g',               group = 'Go to' },
      { 'gd',              desc = 'Go to definition' },
      { 'gD',              desc = 'Go to declaration' },
      { 'gi',              desc = 'Go to implementation' },
      { 'gr',              desc = 'Go to references' },

      -- Code actions group
      { '<leader>ca',      desc = 'Code action' },
      { '<leader>ct',      desc = 'Toggle colorizer' },

      -- Buffer group
      { '<leader>bd',      desc = 'Delete buffer' },
      { '<leader>bf',      desc = 'Find buffers' },

      -- Diagnostics group
      { '<leader>dd',      desc = 'Buffer diagnostics' },
      { '<C-w>d',          desc = 'Show diagnostic float' },

      -- Find/Files group
      { '<leader><space>', desc = 'Find files' },
      { '<leader>ff',      desc = 'Find files' },
      { '<leader>fm',      desc = 'Format buffer',          mode = { 'n', 'v' } },
      { '<leader>fc',      desc = 'Fold close' },

      -- Git group
      { '<leader>gs',      desc = 'Git status' },

      -- Help group
      { '<leader>hh',      desc = 'Help tags' },
      { '<leader>ht',      desc = 'Horizontal terminal' },

      -- Inlay hints
      { '<leader>ih',      desc = 'Toggle inlay hints' },

      -- Live grep
      { '<leader>lg',      desc = 'Live grep' },

      -- No highlight
      { '<leader>nh',      desc = 'Clear search highlight' },

      -- Organize imports
      { '<leader>oi',      desc = 'Organize imports' },

      -- Switch group
      { '<leader>sb',      desc = 'Switch background' },
      { '<leader>sw',      desc = 'Switch wrap' },
      { '<leader>sds',     desc = 'Document symbols' },
      { '<leader>sws',     desc = 'Workspace symbols' },

      -- Terminal group
      { '<leader>vt',      desc = 'Vertical terminal' },

      -- Workspace group
      { '<leader>wa',      desc = 'Add workspace folder' },
      { '<leader>wr',      desc = 'Remove workspace folder' },
      { '<leader>wl',      desc = 'List workspace folders' },
      { '<leader>wd',      desc = 'Workspace diagnostics' },

      -- Misc
      { '<leader>ch',      desc = 'Toggle cmdheight' },
      { '<leader>e',       desc = 'File explorer' },
      { '<leader>q',       desc = 'Quickfix diagnostics' },
      { '<leader>y',       desc = 'Yank to clipboard',      mode = { 'n', 'v' } },
      { '<leader>Y',       desc = 'Yank line to clipboard' },
      { '<leader>D',       desc = 'Type definition' },
      { '<leader>rn',      desc = 'Rename symbol' },

      -- Diagnostics navigation
      { '[d',              desc = 'Previous diagnostic' },
      { ']d',              desc = 'Next diagnostic' },

      -- LSP hover
      { 'J',               desc = 'Hover documentation' },
      { 'K',               desc = 'Signature help' },

      -- Terminal (C-/ is interpreted as C-_ on Windows)
      { '<C-/>',           desc = 'Toggle terminal',        mode = { 'n', 't' } },
      { '<C-_>',           desc = 'Toggle terminal',        mode = { 'n', 't' } },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show { global = false }
      end,
      desc = 'Buffer local keymaps',
    },
  },
}
