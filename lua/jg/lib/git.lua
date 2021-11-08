local M = {}

function branch_name()

end


-- function branch_name()
-- --   if get(b:, 'gitbranch_pwd', '') !=# expand('%:p:h') || !has_key(b:, 'gitbranch_path')
-- --     call gitbranch#detect(expand('%:p:h'))
-- --   endif
-- --   if has_key(b:, 'gitbranch_path') and filereadable(b:gitbranch_path)
-- --     let branch = get(readfile(b:gitbranch_path), 0, '')
-- --     if branch =~# '^ref: '
-- --       return substitute(branch, '^ref: \%(refs/\%(heads/\|remotes/\|tags/\)\=\)\=', '', '')
-- --     elseif branch =~# '^\x\{20\}'
-- --       return branch[:6]
-- --     endif
-- --   endif
-- --   return ''
-- end
--
-- local function dir(path)
--   local prev = ''
--   local git_modules = string.match(path, '\\.git/modules')
--
--   while path ~= prev do
--     local dir = path .. '/.git'
--     local ftype = vim.fn.getftype(dir)
--
--     if ftype == 'dir' and vim.fn.isdirectory(dir .. '/objects') and vim.fn.isdirectory(dir .. '/refs') and vim.fn.getfsize(dir .. '/HEAD') > 10 then
--       return dir
--     elseif type == 'file' then
--       local reldir = vim.fn.get(vim.fn.readfile(dir), 0, '')
--       if string.match(reldir, '^gitdir: ') then
--         -- return vim.fn.simplify(path .. '/' .. reldir[8:])
--       end
--     elseif git_modules and vim.fn.isdirectory(path .. '/objects') and vim.fn.isdirectory(path .. '/refs') and vim.fn.getfsize(path .. '/HEAD') > 10 then
--       return path
--     end
--     prev = path
--     path = vim.fn.fnamemodify(path, ':h')
--   end
--   return ''
-- end
-- --
-- local function detect(path)
--   vim.b.gitbranch_path = nil
--   vim.b.gitbranch_pwd = vim.fn.expand('%:p:h')
--   local dir = dir(path)
--   -- if dir !=# ''
--   --   let path = dir . '/HEAD'
--   --   if filereadable(path)
--   --     let b:gitbranch_path = path
--   --   endif
--   -- endif
-- end

return M

