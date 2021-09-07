let g:tvim_plug_coc_loaded = 0
if executable('node')
    let node_version = system('node --version')
    " v12.0.1
    let major = matchstr(node_version, '\d*', 1)
    if major > 5
        Plug 'neoclide/coc.nvim', {'branch': 'release'}

        if g:tvim_os == 'win'
            Plug 'yatli/coc-powershell', {'do': { -> coc#powershell#install()} }
        else
            Plug 'yatli/coc-powershell'
        endif

        Plug 'neoclide/coc-json'
        Plug 'neoclide/coc-tsserver'

        let g:tvim_plug_coc_loaded = 1
    endif
endif
