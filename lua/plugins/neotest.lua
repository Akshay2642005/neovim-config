-- Test runner: per-test gutter status + summary panel. Build/run tasks
-- stay in Overseer by design; neotest owns only test execution and its
-- results. Lazy on keys; adapters activate per filetype, so unused
-- languages cost nothing after load.
--
-- Adapter notes:
--   C++ ... neotest-ctest needs a built tree: CTestTestfile.cmake within
--           two levels of the root (your Overseer cmake build produces
--           it). No compilation happens inside neotest.
--   Zig ... needs zig >= 0.14 in PATH (pin tag 1.3.* for zig 0.13).
--   JS .... jest AND vitest adapters coexist; each fires only when its
--           runner config exists. Adjust jestCommand per package manager.
return {
  'nvim-neotest/neotest',
  lazy = true,
  -- BufReadPost (not just keys): neotest discovers tests via BufAdd /
  -- BufEnter autocmds created at setup. Keys-only loading meant nothing
  -- existed to discover the already-open buffer, so gutter signs only
  -- appeared after the first <leader>t* press. One-time module load at
  -- first file open; discovery itself stays async, no per-keystroke cost.
  event = { 'BufReadPost', 'BufNewFile' },
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'rouge8/neotest-rust',
    'nvim-neotest/neotest-go',
    'nvim-neotest/neotest-python',
    'nvim-neotest/neotest-jest',
    'marilari88/neotest-vitest',
    'lawrence-laz/neotest-zig',
    'orjangj/neotest-ctest',
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
      -- Output opens as a bottom split (not neotest's default float)
      -- so it docks into edgy alongside the summary.
      '<leader>to',
      function()
        require('neotest').output.open {
          enter = true,
          open_win = function()
            vim.cmd 'botright split'
            local win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_height(win, 15)
            return win
          end,
        }
      end,
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
    {
      -- DAP strategy: debug the nearest test under codelldb/delve.
      '<leader>td',
      function() require('neotest').run.run { strategy = 'dap' } end,
      desc = 'Test: debug nearest',
    },
  },
  config = function()
    require('neotest').setup {
      -- Summary docks at the bottom (edgy rule matches ft=neotest-summary
      -- there); the default is a right-side vsplit that squeezes code.
      -- animated = false: neotest's own expand/collapse animation, the one
      -- scroll-adjacent knob left at its default.
      summary = { open = 'botright split | resize 15', animated = false },
      -- Single opener rule: neotest auto-pops output after every run by
      -- default, which stacked a second panel next to manual <leader>to.
      -- <leader>to stays the only way output opens.
      output = { open_on_run = false },
      adapters = {
        require 'neotest-rust',
        require('neotest-go') {},
        require 'neotest-python',
        require('neotest-jest') { jestCommand = 'npx jest' },
        require 'neotest-vitest',
        require('neotest-zig') {},
        require('neotest-ctest').setup { dap_adapter = 'codelldb' },
      },
    }
    -- The buffer open at setup already fired BufAdd/BufEnter before
    -- neotest's autocmds existed. Re-fire BufAdd for it (scoped: few
    -- plugins listen to BufAdd, unlike BufEnter which everything hears)
    -- so the current file discovers without a buffer switch.
    vim.schedule(function()
      if vim.fn.expand '%' ~= '' then
        vim.api.nvim_exec_autocmds('BufAdd', { buffer = 0, modeline = false })
      end
    end)

    -- `q` closes neotest's own windows. The summary has no close action
    -- in its mappings table, so this FileType key does it instead;
    -- output is a plain split, plain :close suffices there.
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('neotest_close_key', { clear = true }),
      pattern = 'neotest-summary',
      callback = function()
        vim.keymap.set('n', 'q', function() require('neotest').summary.close() end, {
          buffer = true,
          silent = true,
          desc = 'Close test summary',
        })
      end,
    })
    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('neotest_output_close_key', { clear = true }),
      pattern = 'neotest-output',
      callback = function()
        vim.keymap.set('n', 'q', '<cmd>close<cr>', {
          buffer = true,
          silent = true,
          desc = 'Close test output',
        })
      end,
    })
  end,
}
