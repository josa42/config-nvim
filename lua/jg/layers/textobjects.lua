local layer = require('jg.lib.layer')

layer.use({
  requires = {
    'kana/vim-textobj-user',
    'kana/vim-textobj-entire', --         ae | ie
    'kana/vim-textobj-line', --           al | il
    'kana/vim-textobj-indent', --         ai | ii
    'sgur/vim-textobj-parameter', --      a, | i,
    'whatyouhide/vim-textobj-xmlattr', -- ax | ix
  },
})
