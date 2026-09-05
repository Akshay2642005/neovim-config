-- Ensures only the DEBUG adapters stay installed via Mason. LSP servers,
-- linters and formatters remain on the manual :MasonInstallAll list in
-- configs/mason/packages.lua (deliberately not automated).
return {
  'jay-babu/mason-nvim-dap.nvim',
  lazy = true,
  event = 'BufReadPost',
  dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
  opts = {
    ensure_installed = { 'codelldb', 'delve', 'debugpy' },
    automatic_installation = true,
  },
}
