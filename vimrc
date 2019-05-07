" Vim Configurations
" Le Tan (tamlokveer at gmail.com)
" https://github.com/tamlok/tvim

" No vi compatibility
set nocompatible

" Variables of tvim, with tvim_ prefix
let g:tvim_os = 'unix' " Including win32unix
if has('win16') || has('win32') || has('win64') || has('win95')
    let g:tvim_os = 'win'
elseif has('mac') || has('macunix')
    let g:tvim_os = 'mac'
endif

" Detect tvim_utils for win
if g:tvim_os == 'win'
    let g:tvim_utils_folder = $VIMRUNTIME . '\tvim_utils'
    if isdirectory(g:tvim_utils_folder)
        let $PATH .= ';' . g:tvim_utils_folder
        let $PATH .= ';' . g:tvim_utils_folder . '\cppcheck'
        let $PATH .= ';' . g:tvim_utils_folder . '\global'

        let python3_folder = g:tvim_utils_folder . '\python35_embed_win32'
        let $PATH .= ';' . python3_folder

        if has('nvim')
            " pip3 install pynvim
            let g:python3_host_prog = fnameescape(python3_folder . '\python')
        else
            execute 'set pythonthreedll=' . fnameescape(python3_folder . '\python35.dll')
        endif
    endif
endif

" Detect main.vim entry
let g:tvim_main_script = ''
if g:tvim_os == 'win'
    if has('nvim')
        if filereadable($HOME . '\AppData\Local\nvim\scripts\main.vim')
            let g:tvim_main_script = $HOME . '\AppData\Local\nvim\scripts\main.vim'
        elseif filereadable($VIM . '\vimfiles\scripts\main.vim')
            let &runtimepath .= ',' . $VIM . '\vimfiles'
            let g:tvim_main_script = $VIM . '\vimfiles\scripts\main.vim'
        endif
    else
        if filereadable($HOME . '\vimfiles\scripts\main.vim')
            let g:tvim_main_script = $HOME . '\vimfiles\scripts\main.vim'
        elseif filereadable($VIM . '\vimfiles\scripts\main.vim')
            let g:tvim_main_script = $VIM . '\vimfiles\scripts\main.vim'
        endif
    endif
else
    if filereadable($HOME."/.vim/scripts/main.vim")
        let g:tvim_main_script = $HOME."/.vim/scripts/main.vim"
    endif
endif

if g:tvim_main_script != ''
    let s:mainScript = fnameescape(g:tvim_main_script)
    execute 'source ' . s:mainScript
endif

filetype plugin indent on
