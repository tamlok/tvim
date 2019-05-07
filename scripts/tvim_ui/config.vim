function! ShortTabLine()
    let ret = ''
    for i in range(tabpagenr('$'))
        " Select the color group for highlighting active tab
        if i + 1 == tabpagenr()
            let ret .= '%#TabLineSel#'
        else
            let ret .= '%#TabLine#'
        endif

        " Add the tab number
        let tabnum = i + 1

        " Find the buffername for the tablabel
        let buflist = tabpagebuflist(i+1)
        let winnr = tabpagewinnr(i+1)
        let buffername = bufname(buflist[winnr - 1])
        let filename = fnamemodify(buffername, ':t')

        " Find if any file is modified
        let modifier = ''
        for bufnr in buflist
            if getbufvar(bufnr, '&modified')
                let modifier = ' +'
                break
            endif
        endfor

        " check if there is no name
        if filename == ''
            let filename = 'No Name'
        endif
        let ret .= '['.tabnum.'. '.filename.modifier.']'
    endfor

    " after the last tab fill with TabLineFill and reset tab page #
    let ret .= '%#TabLineFill#'
    return ret
endfunction

function! ShortTabLineGUI()
    let bufnrlist = tabpagebuflist(v:lnum)
    let label = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    let filename = fnamemodify(label, ':t')
    if filename == ''
        let filename = 'No Name'
    endif
    let ret = v:lnum.'. '.filename

    for bufnr in bufnrlist
        if getbufvar(bufnr, '&modified')
            let ret .= ' +'
            break
        endif
    endfor
    return ret
endfunction

" Change font size in GUI
function! IncreaseGuiFontSize()
    if has('nvim')
        let l:font = g:GuiFont
        let l:fontwide = ''
    else
        let l:font = &guifont
        let l:fontwide = &guifontwide
    endif

    let l:font = substitute(
        \ l:font, ':h\zs\d\+', '\=eval(submatch(0) + 1)', 'g')
    let l:fontwide = substitute(
        \ l:fontwide, ':h\zs\d\+', '\=eval(submatch(0) + 1)', 'g')

    if has('nvim')
        execute 'GuiFont ' . l:font
    else
        let &guifont = l:font
        let &guifontwide = l:fontwide
    endif
endfunction

function! DecreaseGuiFontSize()
    if has('nvim')
        let l:font = g:GuiFont
        let l:fontwide = ''
    else
        let l:font = &guifont
        let l:fontwide = &guifontwide
    endif

    let l:font = substitute(
        \ l:font, ':h\zs\d\+', '\=eval(submatch(0) - 1)', '')
    let l:fontwide = substitute(
        \ l:fontwide, ':h\zs\d\+', '\=eval(submatch(0) - 1)', '')

    if has('nvim')
        execute 'GuiFont ' . l:font
    else
        let &guifont = l:font
        let &guifontwide = l:fontwide
    endif
endfunction

set tabline=%!ShortTabLine()

" gui_running is 0 in nvim, so we need to copy this part to ginit.vim, too
if has('gui_running') && !has('nvim')
    set imcmdline

    set guioptions-=m       " Hide menu bar
    set guioptions-=T       " Hide tool bar
    set guioptions-=L       " Hide leftside scroll bar
    set guioptions-=r       " Hide rightside scroll bar
    set guioptions-=e       " Use terminal tab line
    set guioptions-=b       " Hide bottom scroll bar
    set guioptions+=c       " Use console dialog

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

    let s:command = 'map <silent> <C-F2> :if &guioptions =~# ''T'' <Bar>'
                    \ . ' set guioptions-=T <Bar>'
                    \ . ' set guioptions-=m <Bar>'
                    \ . ' else <Bar>'
                    \ . ' set guioptions+=T <Bar>'
                    \ . ' set guioptions+=m <Bar>'
                    \ . ' endif<CR>'
    call AddKeyBinding(s:command, 'Toggle GUI menu and toolbar')

    let s:gui_font_size = '13'
    if g:tvim_os == 'win'
        set langmenu=zh_CN.UTF-8
        language message zh_CN.UTF-8
        set guifontset=
        execute 'set guifont=Source\ Code\ Pro:h' . s:gui_font_size . ',Consolas:h' . s:gui_font_size
        execute 'set guifontwide=Microsoft\ Yahei:h' . s:gui_font_size . ',NSimsun:h' . s:gui_font_size
        " Delete and reload the menu to use UTF-8 on Windows
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
    else
        set guifontset=
        execute 'set guifont=Source\ Code\ Pro\ ' . s:gui_font_size . ',Liberation\ Mono\ ' . s:gui_font_size . ',Courier\ New\ ' . s:gui_font_size
        execute 'set guifontwide=Microsoft\ Yahei\ ' . s:gui_font_size . ',WenQuanYi\ Micro\ Hei\ ' . s:gui_font_size
    endif

    " Change font size using <C-up> and <C-down>
    call AddKeyBinding('nnoremap <C-Up> :call IncreaseGuiFontSize()<CR>',
                       \ 'Increase GUI font size')
    call AddKeyBinding('nnoremap <C-Down> :call DecreaseGuiFontSize()<CR>',
                       \ 'Decrease GUI font size')
endif

" Status line
" Always display the statusline
set laststatus=2
" The default status line
" set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline=
" Buffer number
set statusline+=%-3n
set statusline+=%*
" Where to truncate line if too long
set statusline+=%<
execute 'set statusline+=%{CurrentFileDirectory()}\ '
set statusline+=[%t]

execute 'set statusline+=%*\ '
execute 'set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}\ '

" Display a warning if file format isn't unix
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" Help file flag, modified flag, read-only flag
set statusline+=%h%w%#WarningMsg#%m%*%r

if exists('*CocStatuslineInfo')
    set statusline+=%{CocStatuslineInfo()}
endif

" Left/right separator
" set statusline+=%=

execute 'set statusline+=\ '
execute 'set statusline+=[%{v:register}]\ '
" Cursor line / total lines Current column number and virtual column number
set statusline+=%-25.(r:%l-%L\(%P)\ c:%c%V%)

" Enable mouse for both terminal and gui
if has('mouse')
    set mouse=nvc
    if g:tvim_os == 'unix'
        set ttymouse=xterm2
    endif

    let s:mouse_setting = &mouse
    " Toggle mouse mode
    function! ToggleMouseMode()
        if !has('mouse')
            return
        endif

        if &mouse == ''
            let &mouse = s:mouse_setting
            echo 'Using mouse for Vim'
        else
            set mouse=
            echo 'Using mouse for system'
        endif
    endfunction
    call AddKeyBinding('nnoremap <F4> :call ToggleMouse()<CR>', 'Toggle mouse mode')
endif

" Change Statueline color according to the mode
function! ChangeStatuslineColor(mode)
    if g:colors_name != 'detorte'
        return
    endif

    if a:mode == 'r'
        hi! link StatusLine StatusLineReplace
    elseif a:mode == 'n'
        hi! link StatusLine StatusLineNormal
    else
        hi! link StatusLine StatusLineInsert
    endif
endfunction

function! HighlightExtraWhiteSpace(insert_enter)
    hi ExtraWhitespace ctermbg=202 guibg=#ff5f00
    if a:insert_enter == 1
        match ExtraWhitespace /\s\+\%#\@<!$/
    else
        match ExtraWhitespace /\s\+$/
    endif
endfunction

if has('autocmd')
    augroup gui_group
        autocmd!

        autocmd InsertEnter * call ChangeStatuslineColor(v:insertmode)
        autocmd InsertChange * call ChangeStatuslineColor(v:insertmode)
        autocmd InsertLeave * call ChangeStatuslineColor('n')
        autocmd InsertEnter * call HighlightExtraWhiteSpace(1)
        autocmd InsertLeave * call HighlightExtraWhiteSpace(0)

        if has('gui_running')
            " Starting GUI will reset t_vb, so need to set it again
            autocmd GUIEnter * set visualbell t_vb=
        endif
    augroup END
endif

" Show the input command
set showcmd

" Scroll 3 lines offset when cursor is near the buttom or the top
" set scrolloff=3

" Preview window height
set previewheight=20

" Set the max height of the popup menu
set pumheight=10

" Display the ruler
set ruler

" Set the terminal title
set title

" Display current mode in the message line
set showmode

" Display line number relative to current line
set relativenumber

" Display Tab indent
" set list lcs=tab:\|\

" Highlight the 81th column
set cc=81
