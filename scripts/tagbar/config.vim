let g:tagbar_autofocus = 1
let g:tagbar_left=1
" Use t instead of <Space> to display the prototype of current tag
let g:tagbar_map_showproto="t"

" Add support for markdown files in tagbar
let s:markdown2ctags_file = LocateFileInVimFilesFolder('markdown2ctags.py')
if s:markdown2ctags_file != '' && has("python3")
    let g:tagbar_type_markdown = {
        \ 'ctagstype': 'markdown',
        \ 'ctagsbin' : s:markdown2ctags_file,
        \ 'ctagsargs' : '-f - --sort=yes',
        \ 'kinds' : [
            \ 's:sections',
            \ 'i:images'
        \ ],
        \ 'sro' : '|',
        \ 'kind2scope' : {
            \ 's' : 'section',
        \ },
        \ 'sort': 0,
    \ }
endif
