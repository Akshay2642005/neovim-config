return {
  'windwp/nvim-ts-autotag',
  ft = {
    'astro',
    'glimmer',
    'handlebars',
    'hbs',
    'html',
    'javascript',
    'javascriptreact',
    'jsx',
    'markdown',
    'php',
    'rescript',
    'rust', -- add this
    'svelte',
    'tsx',
    'twig',
    'typescript',
    'typescriptreact',
    'vue',
    'xml',
  },
  config = function()
    require('nvim-ts-autotag').setup({
      opts = {
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = true,
      },
      per_filetype = { -- add this block
        rust = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = true,
        },
      },
    })
  end,
}
