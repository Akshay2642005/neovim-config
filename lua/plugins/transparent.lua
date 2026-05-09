return {
  "xiyaowong/transparent.nvim",
  lazy = true,
  event = { "VeryLazy", "VimEnter" },
  config = function()
    require("transparent").setup({})
  end
}
