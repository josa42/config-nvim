return {
  {
    'kana/vim-textobj-user',

    events = { 'InsertEnter' },

    dependencies = {
      'kana/vim-textobj-entire', --         ae | ie
      'kana/vim-textobj-line', --           al | il
      'kana/vim-textobj-indent', --         ai | ii
      'sgur/vim-textobj-parameter', --      aa | ia
      'whatyouhide/vim-textobj-xmlattr', -- ax | ix
      'fvictorio/vim-textobj-backticks', -- a` | i`
    },

    init = function()
      vim.g.vim_textobj_parameter_mapping = 'a'
    end,
  },
}
