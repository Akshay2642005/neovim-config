--- @type vim.lsp.Config
local config = {
  capabilities = {
    workspace = {
      didChangeConfiguration = {
        dynamicRegistration = true,
      },
    },
  },
  on_attach = require('kubeschema').on_attach,
  on_new_config = function(new_config)
    local ok, schemastore = pcall(require, 'schemastore')
    if not ok then
      vim.notify('schemastore could not be loaded', vim.log.levels.WARN)
      return
    end

    new_config.settings = vim.tbl_deep_extend(
      'force',
      new_config.settings or {},
      {
        yaml = {
          schemaStore = {
            enable = false,
          },
          schemas = schemastore.yaml.schemas {
            ignore = {
              'Rancher Fleet',
            },
            extra = {
              {
                name = 'Example',
                description = 'Example YAML Schema',
                fileMatch = '**/.example/job.yml',
                url = 'https://example.com/example-schema.json',
              },
            },
          },
        },
      }
    )
  end,
  settings = {
    redhat = {
      telemetry = {
        enabled = false,
      },
    },
    yaml = {
      validate = {
        enable = true,
      },
    },
  },
}

return config
