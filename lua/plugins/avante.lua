return {
  {
    "yetone/avante.nvim",
    build = vim.fn.has("win32") ~= 0
        and "powershell.exe -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
        or "make",
    event = { "VeryLazy", "InsertEnter" },
    lazy = true,
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
      instructions_file = "agents.md",
      provider = "copilot",
      windows = {
        width = 45,
        height = 30,
        sidebar_header = {
          enabled = false,
          rounded = false
        }
      },
      selector = {
        provider = "native"
      },
      input = {
        provider = "snacks"
      }
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
      "folke/snacks.nvim",           -- for input provider snacks
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = true,
            prompt_for_file_name = true,
            drag_and_drop = {
              insert_mode = true,
            },
            use_absolute_path = true,
          },
        },
      },
    },
  }
}
