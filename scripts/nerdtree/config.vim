let g:NERDTreeQuitOnOpen=1
let g:NERDTreeAutoDeleteBuffer=1

call AddKeyBinding('nnoremap <leader>nt :NERDTreeToggle<CR>', 'Toggle NERDTree')
call AddKeyBinding('nnoremap <leader>nf :NERDTreeFind<CR>', 'Open NERDTree and locate to current file')
" Trailing space needed
call AddKeyBinding('nnoremap <leader>nb :NERDTreeFromBookmark ', 'Open NERDTree from a given bookmark')
