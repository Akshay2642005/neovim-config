return {
  'saecki/crates.nvim',
  event = { 'BufReadPost Cargo.toml' },
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {},
}
