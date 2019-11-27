" Highlight matches
set hlsearch
" Search as characters are entered
set incsearch

set tags=./tags;,tags

" find command
execute 'set path+=' . fnameescape(getcwd() . '/**')

if has('cscope')
    " {cscope}
    " [s]
    call AddKeyBinding('nnoremap <leader>sg :cscope find g <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find definition of cursor word')
    call AddKeyBinding('nnoremap <leader>sc :cscope find c <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find functions calling cursor word function')
    call AddKeyBinding('nnoremap <leader>ss :cscope find s <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find cursor word C symbol')
    call AddKeyBinding('nnoremap <leader>st :cscope find t <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find cursor word text string')
    " [sv]
    call AddKeyBinding('nnoremap <leader>svg :vert scscope find g <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find definition of cursor word in a vertical split')
    call AddKeyBinding('nnoremap <leader>svc :vert scscope find c <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find functions calling cursor word function in a vertical split')
    call AddKeyBinding('nnoremap <leader>svs :vert scscope find s <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find cursor word C symbol in a vertical split')
    call AddKeyBinding('nnoremap <leader>svt :vert scscope find t <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find cursor word text string in a vertical split')
    " [sp]
    call AddKeyBinding('nnoremap <leader>spg :scscope find g <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find definition of cursor word in a split')
    call AddKeyBinding('nnoremap <leader>spc :scscope find c <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find functions calling cursor word function in a split')
    call AddKeyBinding('nnoremap <leader>sps :scscope find s <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find cursor word C symbol in a split')
    call AddKeyBinding('nnoremap <leader>spt :scscope find t <C-R>=expand("<cword>")<CR><CR>',
                       \ '{cscope} Find cursor word text string in a split')

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
" [f]
call AddKeyBinding('nnoremap <leader>fg :GrepBuffer ', 'Grep all buffers')
