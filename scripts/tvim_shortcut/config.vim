" ==Commands==
command! -nargs=1 TTab call SetTabStopWidth(<f-args>)
command! -nargs=0 TKeys call ShowKeyBindings()
command! -nargs=0 TAbbrs call ShowCommandAbbrs()

" ==Key bindings==
call AddKeyBinding('map <space> <leader>', 'Use <space> as leader key')
if has('nvim')
    call AddKeyBinding('nnoremap <C-6> <C-^>', 'Map <C-6> to alternate between files')
endif

call AddKeyBinding('nnoremap [b :bprevious<CR>', 'Previous buffer')
call AddKeyBinding('nnoremap ]b :bnext<CR>', 'Next buffer')

function! DiffBufferWithDisk()
    let l:currentFile = expand('%')
    let l:filename = expand('%:t')
    let l:diffname = ConcatenatePath(&backupdir, l:filename . '.fileFromBuffer')
    execute 'saveas! ' . diffname
    diffthis
    execute 'vsplit ' . filename
    diffthis
endfunction

call AddKeyBinding('nmap <F2> :call DiffBufferWithDisk()<CR>',
                   \ 'Diff contents between buffer and disk file')

call AddKeyBinding('nmap <F3> :set paste!<CR>', 'Toggle paste mode')

call AddKeyBinding('nnoremap [q :cprevious<CR>', 'Previous quickfix error')
call AddKeyBinding('nnoremap ]q :cnext<CR>', 'Next quickfix error')
call AddKeyBinding('nnoremap <leader>qc :cclose<CR>', 'Close quickfix window')
call AddKeyBinding('nnoremap <leader>qo :copen<CR>', 'Open quickfix window')
call AddKeyBinding('nnoremap <leader>ql :clist<CR>', 'List all quickfix error')

call AddKeyBinding('nnoremap [t :tprevious<CR>', 'Previous tag')
call AddKeyBinding('nnoremap ]t :tnext<CR>', 'Next tag')

call AddKeyBinding('nnoremap [l :lprevious<CR>', 'Previous location')
call AddKeyBinding('nnoremap ]l :lnext<CR>', 'Next location')
call AddKeyBinding('nnoremap <leader>lc :lclose<CR>', 'Close location window')
call AddKeyBinding('nnoremap <leader>lo :lopen<CR>', 'Open location window')
call AddKeyBinding('nnoremap <leader>ll :llist<CR>', 'List all locations')

call AddKeyBinding('nnoremap [p :ptprevious<CR>', 'Preview previous tag')
call AddKeyBinding('nnoremap ]p :ptnext<CR>', 'Preview next tag')

call AddKeyBinding('nnoremap <leader>ww :w<CR>', 'Save current file')
call AddKeyBinding('nnoremap <leader>wq :q<CR>', 'Quit current window')
call AddKeyBinding('nnoremap <leader>we :e<CR>', 'Reload current file')
call AddKeyBinding('nnoremap <leader>wr :redraw<CR>', 'Redraw screen')

call AddKeyBinding('nnoremap <leader>te :tabedit<CR>', 'Open a new tab to edit')

call AddKeyBinding('nnoremap <leader>0 :exe "tabn " . g:tvim_last_active_tab<CR>',
                   \ 'Alternate between current and last active tab')

call AddKeyBinding('nnoremap <leader>1 1gt', 'Go to tab 1')
call AddKeyBinding('nnoremap <leader>2 2gt', 'Go to tab 2')
call AddKeyBinding('nnoremap <leader>3 3gt', 'Go to tab 3')
call AddKeyBinding('nnoremap <leader>4 4gt', 'Go to tab 4')
call AddKeyBinding('nnoremap <leader>5 5gt', 'Go to tab 5')
call AddKeyBinding('nnoremap <leader>6 6gt', 'Go to tab 6')
call AddKeyBinding('nnoremap <leader>7 7gt', 'Go to tab 7')
call AddKeyBinding('nnoremap <leader>8 8gt', 'Go to tab 8')
call AddKeyBinding('nnoremap <leader>9 9gt', 'Go to tab 9')

call AddKeyBinding('vnoremap <leader>y "+y', 'Copy selection to system clipboard')
call AddKeyBinding('nnoremap <leader>y "+y', 'Copy text to system clipboard')
call AddKeyBinding('nnoremap <leader>p "+p', 'Paste from system clipboard')
call AddKeyBinding('nnoremap <leader>P "+P', 'Paste the text from system clipboard before cursor')
call AddKeyBinding('nnoremap <leader>d "+d', 'Delete text and copy to system clipboard')

call AddKeyBinding('nnoremap <leader><space> :nohlsearch<CR>', 'Clear search highlight')

" Select the text that was just pasted
call AddKeyBinding('nnoremap <leader>v V`]', 'Select text just pasted')

call AddKeyBinding('nnoremap <C-h> <C-w>h', 'Move cursor one split window left')
call AddKeyBinding('nnoremap <C-j> <C-w>j', 'Move cursor one split window up')
call AddKeyBinding('nnoremap <C-k> <C-w>k', 'Move cursor one split window down')
call AddKeyBinding('nnoremap <C-l> <C-w>l', 'Move cursor one split window right')

function! ZoomRestoreCurrentWindow() abort
    if exists("t:zoomed") && t:zoomed == 1
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction

call AddKeyBinding('nnoremap <silent> <leader>z :call ZoomRestoreCurrentWindow()<CR>',
                   \ 'Zoom/Restore current window')

function! ToggleCursorHighlight()
    if &cursorline != &cursorcolumn
        set cursorline
        set cursorcolumn
    else
        set cursorline!
        set cursorcolumn!
    endif
endfunction

call AddKeyBinding('nnoremap <silent> <leader>ci :call ToggleCursorHighlight()<CR>',
                   \ 'Toggle highlight of cursor line and column')

function! ChangeCwdToCurrentFile()
    let l:currentDir = fnameescape(expand('%:p:h'))
    execute 'cd ' . l:currentDir
    set path&
    execute 'set path+=' . fnameescape(getcwd() . '/**')
    echom 'CWD -> ' . getcwd() ' &path -> ' . &path
endfunction
call AddKeyBinding('nmap <F5> :call ChangeCwdToCurrentFile()<cr>',
                   \ 'Change CWD and path to current file')

" Map Ctrl+J and Ctrl+K to navigate down and up in popup menu.
" Ctrl+N and Ctrl+P may cause performance issue.
call AddKeyBinding('inoremap <expr> <C-J> pumvisible() ? "<Down>" : "<C-J>"',
                   \ 'Move down in popup menu')
call AddKeyBinding('inoremap <expr> <C-K> pumvisible() ? "<Up>" : "<C-K>"',
                   \ 'Move up in popup menu')

" ==Abbreviations==
call AddCommandAbbr('fms', 'set foldmethod=syntax', 'Use syntax folding method')
call AddCommandAbbr('ms', 'marks', 'Show all marks')
call AddCommandAbbr('cts', '%s/\s\+$//', 'Clean up trailing whitespaces')
