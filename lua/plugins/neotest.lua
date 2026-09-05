-- Test runner: per-test gutter status + summary panel. Build/run tasks
-- stay in Overseer by design; neotest owns only test execution and its
-- results. Lazy on keys; the Rust adapter loads for Rust buffers only
-- (add neotest-python etc. the same way if other languages need it).
return {
  'nvim-neotest/neotest',
  lazy = true,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'rouge8/neotest-rust',
  },
  keys = {
    {
      '<leader>tt',
      function() require('neotest').run.run() end,
      desc = 'Test: run nearest',
    },
    {
      '<leader>tf',
      function() require('neotest').run.run(vim.fn.expand '%') end,
      desc = 'Test: run file',
    },
    {
      '<leader>ta',
      function() require('neotest').run.run(vim.fn.getcwd()) end,
      desc = 'Test: run all (cwd)',
    },
    {
      '<leader>to',
      function() require('neotest').output.open { enter = true } end,
      desc = 'Test: open output',
    },
    {
      '<leader>ts',
      function() require('neotest').summary.toggle() end,
      desc = 'Test: toggle summary',
    },
    {
      '<leader>tx',
      function() require('neotest').run.stop() end,
      desc = 'Test: stop',
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-rust',
      },
    }
  end,
}
