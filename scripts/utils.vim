" Helper functions

function! ParentDir(path)
    return fnamemodify(a:path, ':h')
endfunction

function! CurrentFileDirectory()
    return expand("%:p:h")
endfunction

function! ConcatenatePath(path, name)
    let l:sep = '/'
    if g:tvim_os == 'win'
        let l:sep = '\'
    endif

    return a:path . l:sep . a:name
endfunction

let s:custom_key_bindings = []

function! AddKeyBinding(command, description)
    execute a:command
    call add(s:custom_key_bindings,
        \ {
            \ 'command': a:command,
            \ 'description': a:description
        \ })
endfunction

function! ShowKeyBindings()
    echom 'All key bindings:'
    for binding in s:custom_key_bindings
        echom binding.command . ' " ' . binding.description
    endfor
endfunction

let s:custom_cmd_abbrs = []

function! AddCommandAbbr(abbr, command, description)
    execute "cabbr <expr> " . a:abbr . " getcmdtype() == ':' ? '" . a:command . "' : '" . a:abbr . "'"
    call add(s:custom_cmd_abbrs,
        \ {
            \ 'abbreviation': a:abbr,
            \ 'command': a:command,
            \ 'description': a:description
        \ })
endfunction

function! ShowCommandAbbrs()
    echom 'All command abbreviations:'
    for abbr in s:custom_cmd_abbrs
        echom abbr.abbreviation . ' -> ' . abbr.command . ' " ' . abbr.description
    endfor
endfunction

function! LocateFileInVimFilesFolder(file)
    if g:tvim_os == 'win'
        if has('nvim')
            let l:tempLoc = ConcatenatePath($VIM . '\vimfiles', a:file)
            if filereadable(l:tempLoc)
                let &runtimepath .= ',' . $VIM . '\vimfiles'
                return l:tempLoc
            endif

            let l:tempLoc = ConcatenatePath($HOME . '\AppData\Local\nvim', a:file)
            if filereadable(l:tempLoc)
                return l:tempLoc
            endif
        else
            let l:tempLoc = ConcatenatePath($VIM . '\vimfiles', a:file)
            if filereadable(l:tempLoc)
                return l:tempLoc
            endif

            let l:tempLoc = ConcatenatePath($HOME . '\vimfiles', a:file)
            if filereadable(l:tempLoc)
                return l:tempLoc
            endif
        endif
    else
        let l:tempLoc = ConcatenatePath($HOME . '/.vim', a:file)
        if filereadable(l:tempLoc)
            return l:tempLoc
        endif
    endif

    return ''
endfunction

function! SetTabStopWidth(tab_width)
    if a:tab_width == 0
        set noexpandtab
    elseif a:tab_width > 0
        execute 'set tabstop=' . a:tab_width . ' softtabstop=' . a:tab_width . ' shiftwidth=' . a:tab_width . ' expandtab'
    endif
endfunction
