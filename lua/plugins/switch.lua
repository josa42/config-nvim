return {
  {
    'AndrewRadev/switch.vim',
    init = function()
      vim.g.switch_mapping = '-'
    end,
    config = function()
      local group = vim.api.nvim_create_augroup('plugins.switch', { clear = true })

      vim.api.nvim_create_autocmd({ 'FileType' }, {
        group = group,
        callback = function()
          vim.b.switch_custom_definitions = {}
        end,
      })

      vim.api.nvim_create_autocmd({ 'FileType' }, {
        group = group,
        pattern = [[\v(javascript|typescript)(react|)]],
        callback = function()
          vim.b.switch_custom_definitions = {
            {
              [ [[\v'([^'`]+)']] ] = [[`\1`]],
              [ [[\v'([^'"]+)']] ] = [["\1"]],
              [ [[\v`([^`"]+)`]] ] = [["\1"]],
              [ [[\v`([^`']+)`]] ] = [['\1']],
              [ [[\v"([^"']+)"]] ] = [['\1']],
              [ [[\v"([^"`]+)"]] ] = [[`\1`]],
              [ [[\v^( *)(it|describe|test)( *)\(]] ] = [[\1\2.only\3(]],
              [ [[\v^( *)(it|describe|test).only( *)\(]] ] = [[\1\2.skip\3(]],
              [ [[\v^( *)(it|describe|test).skip( *)\(]] ] = [[\1\2\3(]],
            },
          }
        end,
      })
    end,
  },
}
-- layer.use({
--   requires = { 'AndrewRadev/switch.vim' },
--
--   autocmds = {
--     {
--       'FileType',
--       callback = function()
--         vim.b.switch_custom_definitions = {}
--       end,
--     },
--     {
--       'FileType',
--       pattern = [[\v(javascript|typescript)(react|)]],
--       callback = function()
--         vim.b.switch_custom_definitions = {
--           {
--             [ [[\v'([^'`]+)']] ] = [[`\1`]],
--             [ [[\v'([^'"]+)']] ] = [["\1"]],
--             [ [[\v`([^`"]+)`]] ] = [["\1"]],
--             [ [[\v`([^`']+)`]] ] = [['\1']],
--             [ [[\v"([^"']+)"]] ] = [['\1']],
--             [ [[\v"([^"`]+)"]] ] = [[`\1`]],
--             [ [[\v^( *)(it|describe|test)( *)\(]] ] = [[\1\2.only\3(]],
--             [ [[\v^( *)(it|describe|test).only( *)\(]] ] = [[\1\2.skip\3(]],
--             [ [[\v^( *)(it|describe|test).skip( *)\(]] ] = [[\1\2\3(]],
--           },
--         }
--       end,
--     },
--   },
--
--   init = function()
--     vim.g.switch_mapping = '-'
--   end,
-- })
