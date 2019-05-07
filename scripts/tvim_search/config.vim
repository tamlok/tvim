" Highlight matches
set hlsearch
" Search as characters are entered
set incsearch

set tags=./tags;,tags

" find command
execute 'set path+=' . fnameescape(getcwd() . '/**')

if has('cscope')
    call AddKeyBinding('nnoremap <leader>cgc :cscope find g <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find definition of cursor word')
    call AddKeyBinding('nnoremap <leader>ccc :cscope find c <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find functions calling cursor word function')
    call AddKeyBinding('nnoremap <leader>csc :cscope find s <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find cursor word C symbol')
    call AddKeyBinding('nnoremap <leader>ctc :cscope find t <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find cursor word text string')
    call AddKeyBinding('nnoremap <leader>cgv :vert scscope find g <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find definition of cursor word in a vertical split')
    call AddKeyBinding('nnoremap <leader>ccv :vert scscope find c <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find functions calling cursor word function in a vertical split')
    call AddKeyBinding('nnoremap <leader>csv :vert scscope find s <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find cursor word C symbol in a vertical split')
    call AddKeyBinding('nnoremap <leader>ctv :vert scscope find t <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find cursor word text string in a vertical split')
    call AddKeyBinding('nnoremap <leader>cgs :scscope find g <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find definition of cursor word in a split')
    call AddKeyBinding('nnoremap <leader>ccs :scscope find c <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find functions calling cursor word function in a split')
    call AddKeyBinding('nnoremap <leader>css :scscope find s <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find cursor word C symbol in a split')
    call AddKeyBinding('nnoremap <leader>cts :scscope find t <C-R>=expand("<cword>")<CR><CR>',
                       \ 'Find cursor word text string in a split')

    call AddCommandAbbr('csf', 'cscope find', 'CScope find')
    call AddCommandAbbr('vcs', 'vert scscope find', 'CScope find in a vertical split')
    call AddCommandAbbr('scs', 'scscope find', 'CScope find in a split')

    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif
endif

if executable('gtags-cscope')
    set csprg=gtags-cscope
    " silent! execute 'cs add GTAGS ' . fnameescape(getcwd())
    let GtagsCscope_Auto_Load=1
    let GtagsCscope_Quiet=1
endif

function! GrepAllBuffers(pattern)
    cexpr []
    silent execute ':bufdo vimgrepadd ' . a:pattern . ' %:p'
    set cursorline
    set cursorcolumn
    copen
endfunction
command! -nargs=+ GrepBuffer call GrepAllBuffers(<f-args>)
call AddKeyBinding('nnoremap <leader>gb :GrepBuffer ', 'Grep all buffers')
