if g:tvim_plug_ack_loaded == 1
    " Use ag instead of ack
    if executable("ag")
        let g:ackprg='ag --nogroup --nocolor --column'
    endif
endif
