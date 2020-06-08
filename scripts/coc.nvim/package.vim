if executable('node')
    let node_version = system('node --version')
    if node_version > 'v6.0.0'
        Plug 'neoclide/coc.nvim', {'branch': 'release'}

        if g:tvim_os == 'win'
            Plug 'yatli/coc-powershell', {'do': { -> coc#powershell#install()} }
        else
            Plug 'yatli/coc-powershell'
        endif

        Plug 'neoclide/coc-json'
        Plug 'neoclide/coc-tsserver'
    endif
endif
