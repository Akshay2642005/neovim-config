return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    preset = 'helix',
    delay = 100,
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
      { '<leader>b', group = 'Buffer' },
      { '<leader>c', group = 'Code/Colorizer' },
      { '<leader>d', group = 'Debug/DAP' },
      { '<leader>f', group = 'Find/Files' },
      { '<leader>g', group = 'Git' },
      { '<leader>h', group = 'Hunk/Git' },
      { '<leader>i', group = 'Inlay Hints' },
      { '<leader>n', group = 'No Highlight' },
      { '<leader>o', group = 'Organize' },
      { '<leader>q', group = 'Session' },
      { '<leader>r', group = 'Refresh/Rename' },
      { '<leader>rn', desc = 'Rename symbol (live)' },
      { '<leader>s', group = 'Search/Switch' },
      { '<leader>t', group = 'Terminal/TODO' },
      { '<leader>w', group = 'Workspace/Wrap' },
      { '<leader>a', group = 'Avante/AI' },
      { '<leader>aa', desc = 'Show sidebar' },
      { '<leader>at', desc = 'Toggle sidebar' },
      { '<leader>ar', desc = 'Refresh sidebar' },
      { '<leader>af', desc = 'Switch sidebar focus' },
      { '<leader>an', desc = 'New ask' },
      { '<leader>ae', desc = 'Edit selected blocks' },
      { '<leader>aS', desc = 'Stop AI request' },
      { '<leader>ah', desc = 'Chat history' },
      { '<leader>ac', desc = 'Add buffer to files' },
      { '<leader>aB', desc = 'Add all buffers' },
      { '<leader>z', group = 'Zen' },

      -- Grapple
      { '<leader>.', desc = 'Grapple (toggle) file' },
      { ';', desc = 'Grapple tag menu' },

      -- LSP-related keymaps
      { 'g', group = 'Go to' },
      { 'gd', desc = 'Go to definition' },
      { 'gD', desc = 'Go to declaration' },
      { 'gi', desc = 'Go to implementation' },
      { 'gr', desc = 'Go to references' },

      -- Code actions group
      { '<leader>ca', desc = 'Code action' },
      { '<leader>ct', desc = 'Toggle colorizer' },

      -- Buffer group
      { '<leader>bd', desc = 'Delete buffer' },
      { '<leader>bD', desc = 'Close other buffers' },
      { '<leader>bf', desc = 'Find buffers' },
      { '<leader>bp', desc = 'Pick buffer' },
      { '<leader>bh', desc = 'Move buffer left' },
      { '<leader>bl', desc = 'Move buffer right' },
      { ']b', desc = 'Next buffer' },
      { '[b', desc = 'Previous buffer' },
      { '<Tab>', desc = 'Next buffer', mode = { 'n' } },
      { '<S-Tab>', desc = 'Previous buffer', mode = { 'n' } },

      -- Find/Files group
      { '<leader><space>', desc = 'Find files' },
      { '<leader>ff', desc = 'Find files' },
      {
        '<leader>fm',
        desc = 'Format buffer',
        mode = { 'n', 'v' },
      },
      { '<leader>fc', desc = 'Fold close' },
      { '<leader>fC', desc = 'Fold open' },
      { '<leader>fp', desc = 'Switch project' },
      { '<leader>fd', desc = 'Diagnostics' },

      -- Git group
      { '<leader>gg', desc = 'Lazygit' },
      { '<leader>gl', desc = 'Lazygit log (cwd)' },
      { '<leader>gf', desc = 'Lazygit log (file)' },
      { '<leader>gb', desc = 'Git blame line' },
      { '<leader>gs', desc = 'Git status' },
      { '<leader>gd', desc = 'Git diff' },

      -- Hunk/Git group (gitsigns)
      { '<leader>hs', desc = 'Stage hunk' },
      { '<leader>hr', desc = 'Reset hunk' },
      { '<leader>hS', desc = 'Stage buffer' },
      { '<leader>hR', desc = 'Reset buffer' },
      { '<leader>hu', desc = 'Undo stage hunk' },
      { '<leader>hp', desc = 'Preview hunk' },
      { '<leader>hi', desc = 'Preview hunk inline' },
      { '<leader>hb', desc = 'Blame line' },
      { '<leader>hB', desc = 'Toggle line blame' },
      { '<leader>hd', desc = 'Diff this' },
      { '<leader>hD', desc = 'Diff this ~' },
      { '<leader>ht', group = 'Toggle' },
      { '<leader>htd', desc = 'Toggle deleted' },

      -- Help group
      { '<leader>hh', desc = 'Help tags' },

      -- Inlay hints
      { '<leader>ci', desc = 'Toggle inlay hints' },

      -- Live grep
      { '<leader>cg', desc = 'Live grep' },
      { '<leader>cr', desc = 'LSP References' },
      -- No highlight
      { '<leader>nh', desc = 'Clear search highlight' },

      -- Organize imports
      { '<leader>oi', desc = 'Organize imports' },

      -- Session group
      { '<leader>qs', desc = 'Restore session' },
      { '<leader>ql', desc = 'Restore last session' },
      { '<leader>qd', desc = 'Don\'t save session' },
      { '<leader>qS', desc = 'Select session' },

      -- Search group
      { '<leader>st', desc = 'Search TODOs' },
      { '<leader>sT', desc = 'Search TODO/FIX/FIXME' },

      { '<leader>sb', desc = 'Switch background' },
      { '<leader>sw', desc = 'Switch wrap' },
      { '<leader>cs', desc = 'Document symbols' },
      { '<leader>cw', desc = 'Workspace symbols' },

      -- Terminal/TODO group
      { '<leader>vt', desc = 'Vertical terminal' },
      { '<leader>sh', desc = 'Horizontal terminal' },
      { '<leader>tq', desc = 'TODOs to quickfix' },
      { '<leader>tl', desc = 'TODOs to loclist' },

      -- Workspace group
      { '<leader>wa', desc = 'Add workspace folder' },
      { '<leader>wr', desc = 'Remove workspace folder' },
      { '<leader>wl', desc = 'List workspace folders' },
      { '<leader>wd', desc = 'Workspace diagnostics' },

      -- Misc
      { '<leader>ch', desc = 'Toggle cmdheight' },
      { '<leader>e', desc = 'File explorer' },
      {
        '<leader>y',
        desc = 'Yank to clipboard',
        mode = { 'n', 'v' },
      },
      { '<leader>Y', desc = 'Yank line to clipboard' },
      { '<leader>x', group = 'Diagnostics/Extra' },

      -- Macro manager
      { '<leader>m', group = 'Macro' },
      { '<leader>ms', desc = 'Save macro' },
      { '<leader>ml', desc = 'Load macro' },
      { '<leader>md', desc = 'Delete macro' },
      { '<leader>mp', desc = 'Preview macros' },

      -- Debug (DAP)
      { '<leader>db', desc = 'Toggle breakpoint' },
      { '<leader>dB', desc = 'Clear breakpoints' },
      { '<leader>du', desc = 'Toggle DAP UI' },
      { '<leader>dr', desc = 'Run last debug session' },
      { '<leader>dx', desc = 'Terminate debug session' },

      -- Flash navigation
      {
        's',
        desc = 'Flash',
        mode = { 'n', 'x', 'o' },
      },
      {
        'S',
        desc = 'Flash Treesitter',
        mode = { 'n', 'x', 'o' },
      },

      -- TODO navigation
      { ']t', desc = 'Next TODO' },
      { '[t', desc = 'Previous TODO' },

      -- Diagnostics/hunk navigation
      { '[c', desc = 'Previous hunk' },
      { ']c', desc = 'Next hunk' },
      { '[d', desc = 'Previous diagnostic' },
      { ']d', desc = 'Next diagnostic' },
      { '[q', desc = 'Previous quickfix' },
      { ']q', desc = 'Next quickfix' },
      { '[l', desc = 'Previous loclist' },
      { ']l', desc = 'Next loclist' },

      -- LSP hover
      { 'J', desc = 'Hover documentation' },
      { 'K', desc = 'Signature help' },

      -- Terminal
      {
        '<C-/>',
        desc = 'Toggle terminal',
        mode = { 'n', 't' },
      },
      {
        '<C-_>',
        desc = 'Toggle terminal',
        mode = { 'n', 't' },
      },

      -- Text object for hunk
      {
        'ih',
        desc = 'Select hunk',
        mode = { 'o', 'x' },
      },

      -- Treesitter textobjects
      {
        'af',
        desc = 'Function (around)',
        mode = { 'o', 'x' },
      },
      {
        'if',
        desc = 'Function (inner)',
        mode = { 'o', 'x' },
      },
      {
        'ac',
        desc = 'Class (around)',
        mode = { 'o', 'x' },
      },
      {
        'ic',
        desc = 'Class (inner)',
        mode = { 'o', 'x' },
      },
      {
        'aa',
        desc = 'Parameter (around)',
        mode = { 'o', 'x' },
      },
      {
        'ia',
        desc = 'Parameter (inner)',
        mode = { 'o', 'x' },
      },
      { ']f', desc = 'Next function start' },
      { ']F', desc = 'Next function end' },
      { '[f', desc = 'Prev function start' },
      { '[F', desc = 'Prev function end' },
      { '<leader>xp', desc = 'Swap param forward' },
      { '<leader>xP', desc = 'Swap param backward' },
    },
  },
}
