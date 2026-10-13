return {
  'neovim/nvim-lspconfig',
  lazy = true,
  cmd = { 'Start' },
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    { import = 'plugins.lazydev' },
    { 'b0o/SchemaStore.nvim' },
    {
      'imroc/kubeschema.nvim',
      opts = {},
    },
  },
  config = function()
    local lspconfiguser = require 'configs.lsp'
    lspconfiguser.setup_diagnostic_config()

    local servers = require('configs.lsp.servers').to_setup
    for _, server in pairs(servers) do
      local server_opts = {
        on_attach = lspconfiguser.on_attach,
      }

      local has_custom_opts, server_custom_opts =
        pcall(require, 'configs.lsp.settings.' .. server)

      if has_custom_opts and type(server_custom_opts) == 'table' then
        server_opts =
          vim.tbl_deep_extend('force', server_opts, server_custom_opts)
      elseif has_custom_opts then
        vim.notify(
          'LSP settings for '
            .. server
            .. ' must return a table, got '
            .. type(server_custom_opts),
          vim.log.levels.WARN
        )
      end

      local has_custom_commands, server_custom_commands =
        pcall(require, 'configs.lsp.commands.' .. server)
      if has_custom_commands then
        server_opts.commands = server_custom_commands
      end

      vim.lsp.config(server, server_opts)
      vim.lsp.enable(server)
    end

    vim.api.nvim_create_user_command('LspCheckhealth', function()
      vim.cmd ':silent :vertical checkhealth vim.lsp'
    end, {})
  end,
}
