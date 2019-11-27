if has('autocmd')
    augroup coc_group
        autocmd!
        if executable('clangd')
            autocmd User CocNvimInit call coc#config('languageserver.clangd.enable', v:true)
        elseif executable('ccls')
            " CCLS will always make Vim fail to save files.
            " autocmd User CocNvimInit call coc#config('languageserver.ccls.enable', v:true)
        endif
    augroup END
endif

if has('autocmd')
    augroup coc2_group
      autocmd!
      " Update signature help on jump placeholder
      autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
    augroup END
endif

function! CocStatuslineInfo()
    if !exists('g:coc_enabled') || g:coc_enabled == 0
        return ''
    endif

    let status = coc#status()
    if status == ''
        return ''
    else
        return '[' . status . ']'
    endif
endfunction
