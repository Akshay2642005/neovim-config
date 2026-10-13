return {
  'Ramilito/kubectl.nvim',
  version = '2.*',
  cmd = { 'Kubectl', 'K', 'Kubens', 'Kubectx' },
  keys = {
    {
      '<leader>k',
      function()
        require('kubectl').toggle()
      end,
      desc = 'Toggle kubectl',
    },
  },
  dependencies = { 'Saghen/blink.lib' },
  config = function()
    require('kubectl').setup()
  end,
}
