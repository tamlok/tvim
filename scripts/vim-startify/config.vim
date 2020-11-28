function! s:nerdtreeBookmarks()
    " List NERDTree bookmarks.
    let bookmarksFile = expand('$HOME') . '/.NERDTreeBookmarks'
    if filereadable(bookmarksFile)
        let bookmarksStrs = readfile(bookmarksFile)
        let bookmarks = []
        for str in bookmarksStrs
            " Ignore blank lines.
            if str !=# ''
                let name = substitute(str, '^\(.\{-}\) .*$', '\1', '')
                let path = substitute(str, '^.\{-} \(.*\)$', '\1', '')
                let path = fnamemodify(path, ':p')

                call add(bookmarks, {'line': name, 'path': path})
            endif
        endfor
        return bookmarks
    endif

    return []
endfunction

function! s:mruDirs()
    " Get 5 most recently used working directories.
    let dirs = uniq(map(copy(v:oldfiles), 'fnamemodify(v:val, ":h")'))[:4]
    return map(dirs, '{"line": fnamemodify(v:val, ":."), "path": v:val}')
endfunction

let g:startify_lists = [
            \ { 'header': ['   NERDTree Bookmarks'], 'type': function('s:nerdtreeBookmarks') },
            \ { 'header': ['   MRU dirs'],           'type': function('s:mruDirs') },
            \ { 'header': ['   MRU'],                'type': 'files' },
            \ { 'header': ['   MRU '. getcwd()],     'type': 'dir' },
            \ { 'header': ['   Sessions'],           'type': 'sessions' },
            \ ]
