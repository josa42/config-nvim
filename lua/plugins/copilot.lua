return {
  {
    'zbirenbaum/copilot.lua',

    event = { 'InsertEnter' },

    opts = {
      suggestion = {
        enabled = true,
        auto_trigger = true,
      },
      panel = { enabled = false },

      server_opts_overrides = {
        settings = {
          telemetry = false,
        },
      },
    },
  },
}
