return {
  "goolord/alpha-nvim",
  lazy = true,
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    dashboard.section.buttons.val = {
      dashboard.button("e", "    New file", ":ene <BAR> startinsert <CR>"),
      dashboard.button("f", "    Find file", ":SnacksPickerFiles<CR>"),
      dashboard.button("b", "    Browse files", "<CMD>lua require('oil').toggle_float()<CR>"),
      dashboard.button("s", "  󰁯  Select Session", [[<CMD>lua require("persistence").select()<CR>]]),
      dashboard.button("l", "  󰒲  Lazy", ":Lazy<CR>"),
      dashboard.button("q", "  󰅚  Quit", ":qa<CR>"),
    }

    dashboard.config.layout = {
      { type = "padding", val = 8 }, -- Increase this number to push text further down (Vertical Center)
      dashboard.section.header,
      { type = "padding", val = 2 }, -- Space between header and buttons
      dashboard.section.buttons,
      { type = "padding", val = 1 },
      dashboard.section.footer,
    }

    -- Standard Alpha centering opts
    dashboard.opts.opts = {
      margin = 4, -- Adjust this to move the whole block left or right (Horizontal Center)
      width = 40,
    }
    alpha.setup(dashboard.opts)
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyVimStarted",
      callback = function()
        local stats = require("lazy").stats()
        local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
        dashboard.section.footer.val = "Neovim loaded in " .. ms .. " ms"
        pcall(vim.cmd.AlphaRedraw)
      end,
    })
  end,
}
