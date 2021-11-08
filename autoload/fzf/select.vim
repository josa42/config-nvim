function! fzf#select#cb(selection)
  call s:cb(a:selection)
endfunction

function! fzf#select#open(options, cb)
  let s:cb = a:cb
  let opts = fzf#wrap({ 'source': a:options, 'sink': function('fzf#select#cb') })
  call fzf#run(opts)
endfunction
