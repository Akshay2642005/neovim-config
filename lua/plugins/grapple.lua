return {
  'cbochs/grapple.nvim',
  lazy = true,
  event = 'VeryLazy',
  opts = {
    scope = 'git',
    quick_select = '123456789',
    win_opts = {
      width = 50,
      height = 12,
      row = 0.3,
    },
  },
}
