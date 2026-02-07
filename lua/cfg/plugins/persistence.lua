return {
  'folke/persistence.nvim',
  keys = {
    {
      '<leader>qs',
      function()
        require('persistence').load()
      end,
      desc = 'Restore session',
    },
    {
      '<leader>ql',
      function()
        require('persistence').load { last = true }
      end,
      desc = 'Restore last session',
    },
    {
      '<leader>qd',
      function()
        require('persistence').stop()
      end,
      desc = "Don't save current session",
    },
    {
      '<leader>qS',
      function()
        require('persistence').select()
      end,
      desc = 'Select session',
    },
  },
  opts = {
    dir = vim.fn.stdpath 'state' .. '/sessions/',
    need = 1,
    branch = true,
  },
}
