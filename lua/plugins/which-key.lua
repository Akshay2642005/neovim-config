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
      { '<leader>f',       group = 'Find/Files' },
      { '<leader>g',       group = 'Git' },
      { '<leader>h',       group = 'Hunk/Git' },
      { '<leader>i',       group = 'Inlay Hints' },
      { '<leader>l',       group = 'LSP/Live Grep' },
      { '<leader>n',       group = 'No Highlight' },
      { '<leader>o',       group = 'Organize' },
      { '<leader>q',       group = 'Session' },
      { '<leader>r',       group = 'Refresh/Rename' },
      { '<leader>s',       group = 'Search/Switch' },
      { '<leader>t',       group = 'Terminal/TODO' },
      { '<leader>w',       group = 'Workspace/Wrap' },

      -- Grapple group (semicolon prefix)
      { ';',               group = 'Grapple' },
      { ';;',              desc = 'Grapple open tags' },
      { ';1',              desc = 'Grapple tag 1' },
      { ';2',              desc = 'Grapple tag 2' },
      { ';3',              desc = 'Grapple tag 3' },
      { ';4',              desc = 'Grapple tag 4' },
      { ';5',              desc = 'Grapple tag 5' },

      -- LSP-related keymaps
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

      -- Find/Files group
      { '<leader><space>', desc = 'Find files' },
      { '<leader>ff',      desc = 'Find files' },
      { '<leader>fm',      desc = 'Format buffer',          mode = { 'n', 'v' } },
      { '<leader>fc',      desc = 'Fold close' },

      -- Git group
      { '<leader>gg',      desc = 'Lazygit' },
      { '<leader>gl',      desc = 'Lazygit log (cwd)' },
      { '<leader>gf',      desc = 'Lazygit log (file)' },
      { '<leader>gb',      desc = 'Git blame line' },
      { '<leader>gs',      desc = 'Git status' },

      -- Hunk/Git group (gitsigns)
      { '<leader>hs',      desc = 'Stage hunk' },
      { '<leader>hr',      desc = 'Reset hunk' },
      { '<leader>hS',      desc = 'Stage buffer' },
      { '<leader>hR',      desc = 'Reset buffer' },
      { '<leader>hu',      desc = 'Undo stage hunk' },
      { '<leader>hp',      desc = 'Preview hunk' },
      { '<leader>hi',      desc = 'Preview hunk inline' },
      { '<leader>hb',      desc = 'Blame line' },
      { '<leader>hB',      desc = 'Toggle line blame' },
      { '<leader>hd',      desc = 'Diff this' },
      { '<leader>hD',      desc = 'Diff this ~' },
      { '<leader>ht',      group = 'Toggle' },
      { '<leader>htd',     desc = 'Toggle deleted' },

      -- Help group
      { '<leader>hh',      desc = 'Help tags' },

      -- Inlay hints
      { '<leader>ih',      desc = 'Toggle inlay hints' },

      -- Live grep
      { '<leader>lg',      desc = 'Live grep' },

      -- No highlight
      { '<leader>nh',      desc = 'Clear search highlight' },

      -- Organize imports
      { '<leader>oi',      desc = 'Organize imports' },

      -- Session group
      { '<leader>qs',      desc = 'Restore session' },
      { '<leader>ql',      desc = 'Restore last session' },
      { '<leader>qd',      desc = "Don't save session" },
      { '<leader>qS',      desc = 'Select session' },

      -- Search group
      { '<leader>st',      desc = 'Search TODOs' },
      { '<leader>sT',      desc = 'Search TODO/FIX/FIXME' },

      { '<leader>sb',      desc = 'Switch background' },
      { '<leader>sw',      desc = 'Switch wrap' },
      { '<leader>sds',     desc = 'Document symbols' },
      { '<leader>sws',     desc = 'Workspace symbols' },

      -- Terminal/TODO group
      { '<leader>vt',      desc = 'Vertical terminal' },
      { '<leader>tq',      desc = 'TODOs to quickfix' },
      { '<leader>tl',      desc = 'TODOs to loclist' },

      -- Workspace group
      { '<leader>wa',      desc = 'Add workspace folder' },
      { '<leader>wr',      desc = 'Remove workspace folder' },
      { '<leader>wl',      desc = 'List workspace folders' },
      { '<leader>wd',      desc = 'Workspace diagnostics' },

      -- Misc
      { '<leader>ch',      desc = 'Toggle cmdheight' },
      { '<leader>e',       desc = 'File explorer' },
      { '<leader>y',       desc = 'Yank to clipboard',      mode = { 'n', 'v' } },
      { '<leader>Y',       desc = 'Yank line to clipboard' },
      { '<leader>D',       desc = 'Type definition' },
      { '<leader>rn',      desc = 'Rename symbol' },

      -- Flash navigation
      { 's',               desc = 'Flash',                  mode = { 'n', 'x', 'o' } },
      { 'S',               desc = 'Flash Treesitter',       mode = { 'n', 'x', 'o' } },

      -- TODO navigation
      { ']t',              desc = 'Next TODO' },
      { '[t',              desc = 'Previous TODO' },

      -- Diagnostics/hunk navigation
      { '[c',              desc = 'Previous hunk' },
      { ']c',              desc = 'Next hunk' },
      { '[d',              desc = 'Previous diagnostic' },
      { ']d',              desc = 'Next diagnostic' },

      -- LSP hover
      { 'J',               desc = 'Hover documentation' },
      { 'K',               desc = 'Signature help' },

      -- Terminal
      { '<C-/>',           desc = 'Toggle terminal',        mode = { 'n', 't' } },
      { '<C-_>',           desc = 'Toggle terminal',        mode = { 'n', 't' } },

      -- Text object for hunk
      { 'ih',              desc = 'Select hunk',            mode = { 'o', 'x' } },
    },
  },
}
