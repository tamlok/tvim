let g:tvim_plug_ack_loaded = 0
if executable('ag') || executable('ack')
    Plug 'mileszs/ack.vim'
    let g:tvim_plug_ack_loaded = 1
endif
