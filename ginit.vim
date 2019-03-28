GuiTabline 0
GuiPopupmenu 0

if has('unix')
    GuiFont Liberation\ Mono:h12
else
    GuiFont Consolas:h12
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
nnoremap <C-Up> :call GuiSizeUp()<CR>
nnoremap <C-Down> :call GuiSizeDown()<CR>
