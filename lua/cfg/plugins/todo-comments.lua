return {
  'folke/todo-comments.nvim',
  event = 'VeryLazy',
  cmd = { 'TodoQuickFix', 'TodoLocList', 'TodoTrouble' },
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    signs = false,
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
      multiline = false,
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
