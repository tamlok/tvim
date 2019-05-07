let g:fsnonewfiles = 1
call AddKeyBinding('nnoremap <silent> <Leader>fs :FSHere<CR>', 'Switch to header/implementation file')
call AddKeyBinding('nnoremap <silent> <Leader>fr :FSSplitRight<CR>', 'Switch to header/implementation file at a right split')
call AddKeyBinding('nnoremap <silent> <Leader>fa :FSSplitAbove<CR>', 'Switch to header/implementation file at a split above')
