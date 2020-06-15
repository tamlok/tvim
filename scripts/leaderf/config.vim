if g:tvim_plug_leaderf_loaded == 1
    let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }
    let g:Lf_WorkingDirectoryMode = 'a'
    let g:Lf_ShortcutF = '<leader>f'
    let g:Lf_ShortcutB = '<leader>fb'
    let g:Lf_UseVersionControlTool = 0
    let g:Lf_WildIgnore = {
            \ 'dir': ['.svn', '.git', '.hg'],
            \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]', '*.cov.*.report']
            \}
    let g:Lf_ShowHidden = 1
    let g:Lf_ShowDevIcons = 0
endif
