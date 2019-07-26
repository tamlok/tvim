let g:tvim_plug_gutentags_loaded = 0
if executable("ctags") || executable("gtags-cscope")
    Plug 'ludovicchabant/vim-gutentags'
    let g:tvim_plug_gutentags_loaded = 1
endif
