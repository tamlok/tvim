if g:tvim_os == 'win'
    Plug 'yatli/coc-powershell', {'do': { -> coc#powershell#install()} }
else
    Plug 'yatli/coc-powershell'
endif

Plug 'neoclide/coc-json'
Plug 'neoclide/coc-tsserver'
if g:tvim_os == 'win'
    Plug 'neoclide/coc.nvim', {'do': 'install.cmd'}
else
    Plug 'neoclide/coc.nvim', {'do': './install.sh'}
endif
