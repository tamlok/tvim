let g:tvim_plug_gtags_loaded = 0
if executable('gtags')
    Plug 'vim-scripts/gtags.vim'
    let g:tvim_plug_gtags_loaded = 1
endif
