return {
  'folke/persistence.nvim',
  lazy = true,
  event = 'VeryLazy',
  opts = {
    dir = vim.fn.stdpath 'state' .. '/sessions/',
    need = 1,
    branch = true,
  },
}
