let g:colors_name = ''
let g:detorte_theme_mode = 'light'

if &t_Co >= 256 || has("gui_running")
    try
        colorscheme detorte
    catch /^Vim\%((\a\+)\)\=:E185/
        if has("gui_running")
            colorscheme desert
        else
            colorscheme torte
        endif
    endtry
elseif &term == 'win32'
    set term=xterm
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"

    try
        colorscheme detorte
    catch /^Vim\%((\a\+)\)\=:E185/
        if has("gui_running")
            colorscheme desert
        else
            colorscheme torte
        endif
    endtry
elseif &term == 'xterm'
    set term=xterm-256color
    if &t_Co == 256
        try
            colorscheme detorte
        catch /^Vim\%((\a\+)\)\=:E185/
            if has("gui_running")
                colorscheme desert
            else
                colorscheme torte
            endif
        endtry
    else
        set term=xterm
    endif
endif
