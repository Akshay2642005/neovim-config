-- The one window manager: every sidebar-like window docks into edgy
-- (bottom/left/right) instead of splitting the code window.
--
-- Deliberately EXCLUDED (they own their windows; two managers = flicker):
--   dap-ui panels .... owned by dapui's own layout (only exist mid-session)
--   Avante sidebar ... toggles/resizes its own window
--   Snacks pickers .... floating windows, edgy ignores floats anyway
--   grug-far ......... owns its panel layout
--   Diffview ......... owns its tabpage layout
--   symbols outline .. <leader>cs (Snacks document symbols) won over a
--                        sidebar; no outline plugin installed.
--
-- Code splits (<leader>vt/sh, go-to-definition vsplits, picker
-- <c-x> edit_split) are NOT managed by edgy by design -- edgy docks
-- sidebars; code windows tile natively with splitbelow/splitright.
return {
  'folke/edgy.nvim',
  lazy = true,
  event = 'VeryLazy',
  opts = {
    animate = { enabled = false },
    options = {
      left = { size = 30 },
      bottom = { size = 10 },
      right = { size = 32 },
    },
    bottom = {
      { ft = 'trouble', title = 'Diagnostics', size = { height = 10 } },
      { ft = 'qf', title = 'QuickFix', size = { height = 10 } },
      { ft = 'OverseerList', title = 'Tasks', size = { height = 12 } },
      -- Snacks toggle-terminal docks here; toggle off/on re-docks it.
      -- (absolute height: fractions would track tall screens worse.)
      { ft = 'snacks_terminal', title = 'Terminal', size = { height = 12 } },
      { ft = 'dap-repl', title = 'DAP Repl', size = { height = 10 } },
      {
        ft = 'help',
        size = { height = 20 },
        filter = function(buf)
          return vim.bo[buf].buftype == 'help'
        end,
      },
      { ft = 'man', size = { height = 20 } },
      { ft = 'checkhealth', title = 'Checkhealth', size = { height = 20 } },
      { ft = 'lspinfo', title = 'LspInfo', size = { height = 20 } },
      -- neotest summary opens via `summary.open` below as a bottom split;
      -- docked here at the same height so edgy owns it, not a free split.
      { ft = 'neotest-summary', title = 'Tests', size = { height = 15 } },
      -- <leader>to output uses a custom open_win (bottom split, h15).
      { ft = 'neotest-output', title = 'Test Output', size = { height = 15 } },
    },
    left = {
      { ft = 'undotree', title = 'Undo', size = { width = 30 } },
    },
  },
}
