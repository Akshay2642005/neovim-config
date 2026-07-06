return {
  {
    "carderne/pi-nvim",
    lazy = true,
    event = { "VeryLazy", "InsertEnter" },
    config = function()
      require("pi-nvim").setup({
        socket_path = nil, -- auto-discover
        set_default_keymaps = true,
      })
    end
  }
}
