if g:tvim_plug_gutentags_loaded == 1
    let g:gutentags_define_advanced_commands = 1
    " Disable it by default for large project
    let g:gutentags_enabled = 0

    let g:gutentags_generate_on_new = 1
    let g:gutentags_generate_on_missing = 1
    let g:gutentags_generate_on_empty_buffer = 0
    let g:gutentags_generate_on_write = 1

    let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project', 'dirs.proj', 'dirs']
    let g:gutentags_ctags_tagfile = 'tags'
    let s:vim_tags = expand('~/.cache/tags')
    if !isdirectory(s:vim_tags)
        silent! call mkdir(s:vim_tags, 'p')
    endif
    let g:gutentags_cache_dir = s:vim_tags
    let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
    " Used for Universal Ctags
    " let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']
    let tag_common_exclude = ['*.json', '*.md', '*.obj', '*.pdb', '*.ini', '*.log', '*.txt', '*.vcxproj', '*.proj', '*.vimrc', '*.csv']
    let g:gutentags_ctags_exclude = tag_common_exclude
    let g:gutentags_ctags_exclude += ['*.css', '*.html', '*.js', '*.ts']
    let g:gutentags_exclude_filetypes = tag_common_exclude
    let g:gutentags_modules = []
    if executable("ctags")
        let g:gutentags_modules += ['ctags']
    endif
    if executable("gtags-cscope") && executable("gtags")
        let g:gutentags_modules += ['gtags_cscope']
        let g:gutentags_cscope_executable="gtags-cscope"
    endif
endif
