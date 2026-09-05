-- Project-wide find & replace (VS Code Cmd+Shift+H parity).
return {
  'MagicDuck/grug-far.nvim',
  lazy = true,
  cmd = { 'GrugFar', 'GrugFarWithin' },
  keys = {
    {
      '<leader>sr',
      function()
        require('grug-far').open {}
      end,
      desc = 'Search & replace (project)',
    },
    {
      -- NOTE: <leader>sw is taken (toggle line wrap); capital W avoids it.
      '<leader>sW',
      function()
        require('grug-far').open { prefills = { search = vim.fn.expand '<cword>' } }
      end,
      desc = 'Search & replace word under cursor',
    },
    {
      '<leader>sr',
      function()
        require('grug-far').with_visual_selection {}
      end,
      mode = 'v',
      desc = 'Search & replace selection',
    },
  },
  opts = {
    engine = 'ripgrep',
    windowCreation = { border = 'single' },
  },
}
