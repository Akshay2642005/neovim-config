-- Competitive programming against Codeforces: fetch a contest's problems,
-- run them, and diff the output against the official tests.
--
-- The plugin drives terminals through toggleterm's `:TermExec`. We don't ship
-- toggleterm (Snacks.terminal is our terminal), so `config` registers a small
-- `:TermExec` shim that routes to Snacks instead.

local commands = {
  'EnterContest',
  'QNext',
  'TestCurrent',
  'RunCurrent',
  'CreateTestCase',
  'RetrieveLastTestCase',
}

--- Bridge for toggleterm's `:TermExec cmd="<shell command>"`. Snacks keys a
--- terminal on its command, so an earlier run is closed first -- `RunCurrent`
--- should re-run instead of toggling a terminal left over from last time.
--- @param cmd string
local function term_exec(cmd)
  local snacks = require 'snacks'
  local existing = snacks.terminal.get(cmd, { create = false })
  if existing and existing:buf_valid() then
    existing:close()
    -- Let the old terminal's BufWipeout handler drop its entry before a new
    -- terminal claims the same id, otherwise it clears the fresh one.
    vim.schedule(function()
      snacks.terminal(cmd)
    end)
    return
  end
  snacks.terminal(cmd)
end

return {
  'yunusey/codeforces-nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  cmd = commands,
  config = function()
    if vim.fn.exists ':TermExec' == 0 then
      vim.api.nvim_create_user_command('TermExec', function(args)
        local cmd = args.args:match '^cmd="(.*)"$' or args.args
        term_exec(cmd)
      end, { nargs = '+', desc = 'Run a command in a Snacks terminal' })
    end

    -- `codeforces-nvim.codeforces` and `codeforces-nvim.setup` resolve to the
    -- same table, i.e. this plugin's own state; `setup` lives on it too.
    local cf = require 'codeforces-nvim.codeforces'

    cf.setup {
      -- Safe to keep on: the `:TermExec` shim above is backed by Snacks.
      use_term_toggle = true,
      -- The extractor otherwise launches `Xvfb`, which macOS doesn't have (it
      -- panics before fetching anything); headless Chrome does the work.
      use_native_display = true,
      cf_path = vim.fn.expand '~/Documents/codeforces',
      timeout = 15000,
      compiler = {
        -- Apple's `g++` is clang, which has no <bits/stdc++.h>; Homebrew's
        -- GCC does, so compile with it.
        cpp = { 'g++-16', '@.cpp', '-o', '@' },
        py = {},
      },
      run = {
        cpp = { '@' },
        py = { 'python3', '@.py' },
      },
      -- vim.notify is overridden by snacks.nvim, so no nvim-notify needed.
      notify = function(title, message, type)
        local level
        if type == 'success' then
          level = vim.log.levels.INFO
        else
          level = vim.log.levels.ERROR
        end
        local text = message == nil and title or title .. '\n' .. message
        vim.notify(text, level, { title = 'codeforces' })
      end,
    }

    -- Upstream call-site bug: `enter_contest` calls
    -- `fetch_problems(contest, save_dir, exit_function)` but the callee
    -- expects `(contest, save_dir, use_native_display, exit_function)`. The
    -- callback therefore sits in the boolean slot -- it is nil when the job
    -- exits, so a freshly fetched contest never opens -- and the
    -- `use_native_display` option is never read. Re-bind both arguments, and
    -- surface the other silent failure: the extractor exits 0 without writing
    -- anything when Codeforces answers with a bot challenge.
    local fetch = cf.fetch_problems
    cf.fetch_problems = function(contest, save_dir, third, fourth)
      local native, done
      if type(fourth) == 'function' then -- upstream fixed the call site
        native, done = third, fourth
      else -- the callback arrived in the `use_native_display` slot
        native, done = cf.options.use_native_display, third
      end
      fetch(contest, save_dir, native, function()
        if done then
          done()
        end
        if vim.fn.isdirectory(save_dir) == 0 then
          local hint = ('No problems downloaded for contest %s.'):format(
            contest
          )
          cf.options.notify(
            'Codeforces',
            hint
              .. ' Codeforces is probably rate-limiting scraping; wait a few'
              .. ' minutes and run :EnterContest again.',
            'error'
          )
        end
      end)
    end
  end,
}
