return {
  {
    'kylechui/nvim-surround',

    events = { 'InsertEnter' },

    opts = {
      keymaps = {
        insert = nil, -- '<C-g>s',
        insert_line = nil, -- '<C-g>S',
        normal = 'sa',
        normal_cur = nil, --  'yss',
        normal_line = nil, --  'yS',
        normal_cur_line = nil, --  'ySS',
        visual = 'sa',
        visual_line = nil, --  'gS',
        delete = 'sd',
        change = 'sr',
      },
      surrounds = {
        v = { add = { '${', '}' } },
      },
    },
  },
}
