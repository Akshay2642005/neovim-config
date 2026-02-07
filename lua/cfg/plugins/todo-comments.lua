return {
  'folke/todo-comments.nvim',
  cmd = { 'TodoQuickFix', 'TodoLocList', 'TodoTrouble' },
  keys = {
    {
      ']t',
      function()
        require('todo-comments').jump_next()
      end,
      desc = 'Next TODO',
    },
    {
      '[t',
      function()
        require('todo-comments').jump_prev()
      end,
      desc = 'Previous TODO',
    },
    {
      '<leader>st',
      function()
        Snacks.picker.todo_comments()
      end,
      desc = 'Search TODOs',
    },
    {
      '<leader>sT',
      function()
        Snacks.picker.todo_comments { keywords = { 'TODO', 'FIX', 'FIXME' } }
      end,
      desc = 'Search TODO/FIX/FIXME',
    },
    {
      '<leader>tq',
      '<cmd>TodoQuickFix<cr>',
      desc = 'TODOs to quickfix',
    },
    {
      '<leader>tl',
      '<cmd>TodoLocList<cr>',
      desc = 'TODOs to loclist',
    },
  },
  opts = {
    signs = false, -- Disable signs for performance
    sign_priority = 8,
    keywords = {
      FIX = {
        icon = ' ',
        color = 'error',
        alt = { 'FIXME', 'BUG', 'ISSUE' },
      },
      TODO = { icon = ' ', color = 'info' },
      HACK = { icon = ' ', color = 'warning' },
      WARN = { icon = ' ', color = 'warning', alt = { 'WARNING' } },
      PERF = { icon = ' ', color = 'default', alt = { 'OPTIM', 'PERFORMANCE' } },
      NOTE = { icon = ' ', color = 'hint', alt = { 'INFO' } },
    },
    highlight = {
      multiline = false, -- Disable multiline for performance
      before = '',
      keyword = 'wide',
      after = 'fg',
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
    },
    search = {
      command = 'rg',
      args = {
        '--color=never',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
}
