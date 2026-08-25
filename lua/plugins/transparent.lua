return {
  "xiyaowong/transparent.nvim",
  lazy = true,
  event = "VeryLazy",
  config = function()
    require("transparent").setup({})
  end
}
