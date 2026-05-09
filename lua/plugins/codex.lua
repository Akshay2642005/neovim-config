return {
  'kkrampis/codex.nvim',
  lazy = true,
  event = { "VeryLazy", "BufEnter" },
  cmd = { 'Codex', 'CodexToggle' }, -- Optional: Load only on command execution
  opts = {
    keymaps     = {
      quit = '<C-q>',        -- Keybind to close the Codex window (default: Ctrl + q)
    },                       -- Disable internal default keymap (<leader>cc -> :CodexToggle)
    border      = 'single',  -- Options: 'single', 'double', or 'rounded'
    width       = 0.4,       -- Width of the floating window (0.0 to 1.0)
    height      = 0.8,       -- Height of the floating window (0.0 to 1.0)
    model       = 'gpt-5.5', -- Optional: pass a string to use a specific model (e.g., 'o3-mini')
    autoinstall = true,      -- Automatically install the Codex CLI if not found
    panel       = true,      -- Open Codex in a side-panel (vertical split) instead of floating window
    use_buffer  = false,     -- Capture Codex stdout into a normal buffer instead of a terminal buffer
  },
}
