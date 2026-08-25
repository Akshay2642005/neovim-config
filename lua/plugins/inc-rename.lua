return {
  'smjonas/inc-rename.nvim',
  cmd = 'IncRename',
  keys = {
    {
      '<leader>rn',
      function()
        return ':IncRename ' .. vim.fn.expand('<cword>')
      end,
      desc = 'Rename symbol (live)',
      expr = true,
      mode = { 'n', 'v' },
    },
  },
  opts = {},
}
