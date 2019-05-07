Plug 'yatli/coc-powershell', {'do': { -> coc#powershell#install()} }
Plug 'neoclide/coc-json'
Plug 'neoclide/coc-tsserver'
if g:tvim_os == 'win'
    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': 'install.cmd'}
else
    Plug 'neoclide/coc.nvim', {'tag': '*', 'do': './install.sh'}
endif
