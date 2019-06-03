if g:tvim_plug_leaderf_loaded == 1
    let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }
    let g:Lf_WorkingDirectoryMode = 'a'
    let g:Lf_ShortcutF = '<leader>cp'
    let g:Lf_ShortcutB = '<leader>cpb'
    let g:Lf_UseVersionControlTool = 0
    let g:Lf_WildIgnore = {
            \ 'dir': ['.svn', '.git', '.hg'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.cov.*.report']
            \}
    let g:Lf_ShowHidden = 1

    call AddKeyBinding('nnoremap <leader>cpc :execute "LeaderfFile" getcwd()<CR>',
                       \ 'Find in current working directory')
    call AddKeyBinding('nnoremap <leader>cpm :LeaderfMru<CR>', 'Find in Most-Recently-Used')
    call AddKeyBinding('nnoremap <leader>cpt :LeaderfTag<CR>', 'Find in tag file')
    call AddKeyBinding('nnoremap <leader>cpu :LeaderfBufTag<CR>',
                       \ 'Find in tags of current buffer')
    call AddKeyBinding('nnoremap <leader>cpa :LeaderfBufTagAll<CR>',
                       \ 'Find in tags of all buffers')
    call AddKeyBinding('nnoremap <leader>cpw :LeaderfBufTagAllCword<CR>',
                       \ 'Find cursor word in tags of all buffers')
    call AddKeyBinding('nnoremap <leader>cpf :LeaderfFunction!<CR>',
                       \ 'Find functions in current buffer')
    call AddKeyBinding('nnoremap <leader>cpe :LeaderfFunctionAll<CR>',
                       \ 'Find functions in all buffers')
endif
