GuiTabline 0
GuiPopupmenu 0

let s:gui_font_size = '13'

" Select this font if available. Could not detect it dynamically.
" execute 'GuiFont! Source Code Pro:h' . s:gui_font_size
if has('unix')
    execute 'GuiFont! Liberation Mono:h' . s:gui_font_size
else
    execute 'GuiFont! Consolas:h' . s:gui_font_size
endif

set guicursor=a:block
set guicursor+=o:hor50-Cursor
set guicursor+=n:Cursor
set guicursor+=a:blinkon0
if g:colors_name == 'detorte'
    set guicursor+=i-ci-sm:InsertCursor
    set guicursor+=r-cr:ReplaceCursor-hor20
    set guicursor+=c:CommandCursor
    set guicursor+=v-ve:VisualCursor
endif

set tabline=%!ShortTabLine()

" Change font size using <C-up> and <C-down>
call AddKeyBinding('nnoremap <C-Up> :call IncreaseGuiFontSize()<CR>',
                   \ 'Increase GUI font size')
call AddKeyBinding('nnoremap <C-Down> :call DecreaseGuiFontSize()<CR>',
                   \ 'Decrease GUI font size')
