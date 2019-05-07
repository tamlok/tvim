let g:tvim_plug_ctrlp_loaded = 0
if !has('python') && !has('python3')
    Plug 'ctrlpvim/ctrlp.vim'
    let g:tvim_plug_ctrlp_loaded = 1
endif
