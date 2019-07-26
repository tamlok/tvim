if g:tvim_plug_ctrlp_loaded == 1
    " Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
    function! CtrlP_StatusLine_1(...)
        let focus='['.a:1.']'
        let byfname='['.a:2.']'
        let regex=a:3 ? 'regex' : ''
        let item='{'.a:5.'}'
        let marked = ' '.a:7.' '
        let dir = 'CWD['.getcwd().']%=%<'
        return focus.byfname.regex.item.marked.dir
    endfunction

    function! CtrlP_StatusLine_2(...)
        let len='['.a:1.']'
        let dir = 'CWD['.getcwd().']%=%<'
        return len.dir
    endfunction

    let g:ctrlp_map='<leader>cp'
    let g:ctrlp_extensions=['tag', 'buffertag']
    let g:ctrlp_match_window='order:ttb,results:100'
    let g:ctrlp_status_func={
        \ 'main': 'CtrlP_StatusLine_1',
        \ 'prog': 'CtrlP_StatusLine_2',
    \ }
    let g:ctrlp_max_files = 0
    let g:ctrlp_max_depth = 50
    " Always open a new instance
    let g:ctrlp_switch_buffer = 0
    " From spf13
    if executable('ag')
        let s:ctrlp_fallback = 'ag -i --nocolor --nogroup --hidden -g "" %s'
    elseif executable('ack-grep')
        let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
    elseif executable('ack')
        let s:ctrlp_fallback = 'ack %s --nocolor -f'
    elseif g:tvim_os == 'win'
        let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
    else
        let s:ctrlp_fallback = 'find %s -type f'
    endif

    if exists("g:ctrlp_user_command")
        unlet g:ctrlp_user_command
    endif
    let g:ctrlp_user_command = {
        \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
        \ },
        \ 'fallback': s:ctrlp_fallback
    \ }

    call AddKeyBinding('nnoremap <leader>cpt :CtrlPTag<CR>', '')
    call AddKeyBinding('nnoremap <leader>cpb :CtrlPBuffer<CR>', '')
    call AddKeyBinding('nnoremap <leader>cpm :CtrlPMixed<CR>', '')
    call AddKeyBinding('nnoremap <leader>cpu :CtrlPBufTag<CR>', '')
    call AddKeyBinding('nnoremap <leader>cpa :CtrlPBufTagAll<CR>', '')
    call AddKeyBinding('nnoremap <leader>cpc :CtrlP :pwd<CR>', '')

    call AddCommandAbbr('cp', 'CtrlP', 'CtrlP')
endif
