return {
  {
    'OXY2DEV/markview.nvim',
    lazy = true,
    -- NOTE: no BufReadPre here on purpose: Avante sidebars are nofile
    -- buffers, so BufReadPre never fires for them. ft + VeryLazy covers
    -- both real markdown files and the Avante sidebar/input buffers.
    event = 'VeryLazy',
    ft = {
      'Avante',
      'AvanteInput',
      'avante',
      'codecompanion',
      'markdown',
      'opencode_output',
    },
    opts = {
      preview = {
        filetypes = {
          'Avante',
          'AvanteInput',
          'avante',
          'codecompanion',
          'markdown',
          'opencode_output',
        },
      },
    },
  },
}
