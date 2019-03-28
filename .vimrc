" Vim Configurations
" Le Tan (tamlokveer at gmail.com)
" https://github.com/tamlok/tvim

set nocompatible

" Variables of tvim
" s: for script-scope variables
let s:tvim_os = 'unix' " Including win32unix
if has('win16') || has('win32') || has('win64') || has('win95')
    let s:tvim_os = 'win'
elseif has('mac') || has('macunix')
    let s:tvim_os = 'mac'
endif

" Detect tvim_utils for win
if s:tvim_os == 'win'
    let s:tvim_utils_folder = $VIMRUNTIME . '\tvim_utils'
    if isdirectory(s:tvim_utils_folder)
        let $PATH .= ';' . s:tvim_utils_folder
        let $PATH .= ';' . s:tvim_utils_folder . '\cppcheck'
        let $PATH .= ';' . s:tvim_utils_folder . '\global'

        let python3_folder = s:tvim_utils_folder . '\python35_32'
        let $PATH .= ';' . python3_folder

        if has('nvim')
            " pip3 install pynvim
            let g:python3_host_prog = fnameescape(python3_folder . '\python')
        else
            execute 'set pythonthreedll=' . fnameescape(python3_folder . '\python35.dll')
        endif
    endif
endif

" Plug for plugins
let s:plug_plugins = ''
if s:tvim_os == 'win'
    if has('nvim')
        if filereadable($HOME . '\AppData\Local\nvim\autoload\plug.vim')
            let s:plug_plugins = $HOME . '\AppData\Local\nvim\plugged'
        elseif filereadable($VIM . '\vimfiles\autoload\plug.vim')
            let &runtimepath .= ',' . $VIM . '\vimfiles'
            let s:plug_plugins = $VIM . '\vimfiles\plugged'
        endif
    else
        if filereadable($HOME . '\vimfiles\autoload\plug.vim')
            let s:plug_plugins = $HOME . '\vimfiles\plugged'
        elseif filereadable($VIM . '\vimfiles\autoload\plug.vim')
            let s:plug_plugins = $VIM . '\vimfiles\plugged'
        endif
    endif
else
    if filereadable($HOME."/.vim/autoload/plug.vim")
        let s:plug_plugins = $HOME."/.vim/plugged"
    endif
endif

let s:gutentags_loaded = 0

if s:plug_plugins != ""
    let s:plug_plugins = fnameescape(s:plug_plugins)

    exec "silent! call plug#begin('" . s:plug_plugins . "')"
    Plug 'vim-scripts/gtags.vim'
    Plug 'tpope/vim-surround'
    Plug 'majutsushi/tagbar'
    Plug 'easymotion/vim-easymotion'
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'mileszs/ack.vim'
    Plug 'guns/xterm-color-table.vim', {'on': 'XtermColorTable'}
    Plug 'tamlok/vim-highlight'
    Plug 'will133/vim-dirdiff'
    Plug 'derekwyatt/vim-fswitch'
    Plug 'scrooloose/nerdtree', {'on': ['NERDTreeToggle', 'NERDTreeFind', 'NERDTreeFromBookmark'] }

    if executable("ctags") || executable("gtags-cscope")
        Plug 'ludovicchabant/vim-gutentags'
        let s:gutentags_loaded = 1
    endif

    Plug 'skywind3000/asyncrun.vim'

    if has('python') || has('python3')
        Plug 'Yggdroot/LeaderF'
    else
        Plug 'ctrlpvim/ctrlp.vim'
    endif

    Plug 'w0rp/ale'
    Plug 'skywind3000/vim-preview'
    call plug#end()
endif

set background=dark
set encoding=utf-8

" Italic font
set t_ZH=[3m
set t_ZR=[23m

" Short tab line for vim
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
            if getbufvar(bufnr, "&modified")
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

" Short tab line for gvim
function! ShortTabLabel()
    let bufnrlist = tabpagebuflist(v:lnum)
    let label = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    let filename = fnamemodify(label, ':t')
    if filename == ''
        let filename = 'No Name'
    endif
    let ret = v:lnum.'. '.filename

    for bufnr in bufnrlist
        if getbufvar(bufnr, "&modified")
            let ret .= ' +'
            break
        endif
    endfor
    return ret
endfunction

" Colorscheme
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

" GUI
" gui_running is 0 in nvim, so we copy this part to ginit.vim, too
if has('gui_running')
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

    set tabline=%!ShortTabLine()

    " Map <Ctrl+F2> to toggle the menu and toolbar
    map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
                            \set guioptions-=T <Bar>
                            \set guioptions-=m <Bar>
                        \else <Bar>
                            \set guioptions+=T <Bar>
                            \set guioptions+=m <Bar>
                        \endif<CR>

    if s:tvim_os == 'win'
        set langmenu=zh_CN.UTF-8
        language message zh_CN.UTF-8
        set guifontset=
        set guifont=Consolas:h12
        set guifontwide=NSimsun:h12
        " Delete and reload the menu to use UTF-8 on Wins
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
    else
        set guifontset=
        set guifont=Liberation\ Mono\ 12
    endif

    " Change font size using <C-up> and <C-down>
    nnoremap <C-Up> :call GuiSizeUp()<CR>
    nnoremap <C-Down> :call GuiSizeDown()<CR>
else
    set tabline=%!ShortTabLine()
endif

" Change font size in GUI
function! GuiSizeUp()
    if has('nvim')
        let l:font = g:GuiFont
        let l:fontwide = ''
    else
        let l:font = &guifont
        let l:fontwide = &guifontwide
    endif

    let l:font = substitute(
        \ l:font, ':h\zs\d\+', '\=eval(submatch(0) + 1)', '')
    let l:fontwide = substitute(
        \ l:fontwide, ':h\zs\d\+', '\=eval(submatch(0) + 1)', '')

    if has('nvim')
        execute 'GuiFont ' . l:font
    else
        let &guifont = l:font
        let &guifontwide = l:fontwide
    endif
endfunction

function! GuiSizeDown()
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

set fileencodings=UCS-BOM,UTF-8,Chinese
set termencoding=UTF-8

if has("syntax")
    syntax enable " Enable syntax processing
    syntax on
endif

set previewheight=20 " Preview window height
set ruler       " Display the ruler
set showcmd     " Show the input command
" set scrolloff=3 " Scroll 3 lines offset when cursor is near the buttom or the top
set autoindent
set cindent
set smartindent
set ignorecase
set smartcase

set tabstop=4       " Number of visual spaces per TAB
set softtabstop=4   " Number of spaces in tab when editing
set shiftwidth=4
set expandtab     " convert tabs to spaces

set wildmenu        " Visual autocomplete for command menu
set wildmode=list:longest,full " Complete only up to the point of ambiguity
set wildignore=*.o,*.obj,*.bin,*.dll,*.exe

set title           " Set the terminal title

" Store temp files in a central spot. Should mkdir ~/.vim_tmp in Unix or
" ~/AppData/Local/Temp in Windows.
if has("unix")
    let tempdir="~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp"
else
    let tempdir="~/AppData/Local/Temp"
endif
execute "set backupdir=".tempdir
execute "set directory=".tempdir

set showmode        " Display current mode in the message line

" set number          " Display absolute line number
set relativenumber  " Display line number relative to current line
set hlsearch        " Highlight matches
set incsearch       " Search as characters are entered
" set list lcs=tab:\|\   " Display Tab indent
set cc=81               " Highlight the 81th column

set complete-=i     " Do not scan included files in <C-P> completion
set completeopt=menuone,preview

set tags=./tags;,tags

set confirm     " Ask for confirmation when handling unsaved or read-only files
set report=0
set showmatch   " Highlight matched parentheses
set matchtime=5 " Time for highlighting matched parentheses

set textwidth=0 " Disable auto wrapping of long lines
set wrapmargin=0

" Allow modified buffer to be hidden
set hidden

set formatoptions-=c formatoptions-=o formatoptions-=r

" Statusline
function! StatusLineFileDir()
    return expand("%:p:h")
endfunction

set laststatus=2    " Always display the statusline
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P   " The default status line
set statusline=
set statusline+=%-3n   " Buffer number
set statusline+=%*
set statusline+=%<     " Where to truncate line if too long
set statusline+=%{StatusLineFileDir()}\ 
set statusline+=[%t]

" Trailing space
set statusline+=%*\ 

set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}\ 

" Display a warning if file format isn't unix
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" Help file flag, modified flag, read-only flag
set statusline+=%h%w%#WarningMsg#%m%*%r

" set statusline+=%=    " Left/right separator
set statusline+=\     " One space
set statusline+=[%{v:register}]\ 
" Cursor line / total lines Current column number and virtual column number
set statusline+=%-25.(r:%l-%L\(%P)\ c:%c%V%)

" Valid in terminal. Need to set it again after GUI enter.
set noerrorbells visualbell t_vb=

set foldenable      " Enable folding
" set foldcolumn=2  " Column to show the hints for folding
set foldlevelstart=10   " Open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " Fold based on indent level
" set cursorline      " Highlight current line
" set cursorcolumn    " Highlight current column

set ttyfast             " Indicates a fast terminal connection

" find command
execute "set path+=".fnameescape(getcwd()."/**")

set history=200

" Enable mouse for both terminal and gui
if has("mouse")
    set mouse=nvc
    if has("unix")
        set ttymouse=xterm2
    endif
endif

" let vim to source local .vimrc file with secure on
" set exrc
" set secure

" Enable matchit plugin to enable % to jump between keyword like if/end
runtime macros/matchit.vim

" Let backspace behave well in insert mode
set backspace=indent,eol,start

" Set the max height of the popup menu
set pumheight=10

" GNU GLOBAL or cscope
" Let cscope replace ctags
" set cscopetag
" let CtagsCscope_Auto_Map=1
if has("cscope") && has("quickfix")
    set cscopequickfix=s-,c-,d-,i-,t-,e-
endif

if executable("gtags-cscope")
    set csprg=gtags-cscope
    silent! execute "cs add GTAGS ".fnameescape(getcwd())
    let GtagsCscope_Auto_Load=1
    let GtagsCscope_Quiet=1
endif

" Change StatueLine color according to the mode
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

" Set tab width. Disable expanding tab if zero.
function! SetTabFn(tab_width)
    if a:tab_width == 0
        set noexpandtab
    elseif a:tab_width > 0
        execute 'set tabstop=' . a:tab_width . ' softtabstop=' . a:tab_width . ' shiftwidth=' . a:tab_width . ' expandtab'
    else
        echom "warning: arg equal to 0 will disable expanding tab, larger than 0 will set the tab stop."
    endif
endfunction
command! -nargs=1 STab call SetTabFn(<f-args>)

" Define abbr for only ':' command mode
function! CommandAbbr(abbr, cmd)
    exec "cabbr <expr> " . a:abbr . " getcmdtype() == ':' ? '" . a:cmd . "' : '" . a:abbr . "'"
endfunction

call CommandAbbr('fms', 'set foldmethod=syntax')
call CommandAbbr('gta', 'Gtags')
call CommandAbbr('gtr', 'Gtags -r')
call CommandAbbr('csf', 'cscope find')
call CommandAbbr('vcs', 'vert scscope find')
call CommandAbbr('scs', 'scscope find')
call CommandAbbr('ms', 'marks')
" Clean up trailing spaces
call CommandAbbr('cts', '%s/\s\+$//')

" Update gtags asynchronously
function! UpdateTags()
    if executable("global")
        let gtags_file = getcwd() . '/GTAGS'
        if filereadable(fnameescape(gtags_file))
            AsyncRun global -u
        else
            echom "Creating GTAGS"
            call system("gtags")
            cs kill -1
            execute "cs add GTAGS ".fnameescape(getcwd())
            echom "GTAGS created"
        endif
    endif
endfunction
call CommandAbbr("upt", 'call UpdateTags()')

map <space> <leader>

" For Tagbar plugin
let g:tagbar_autofocus = 1
let g:tagbar_left=1
" Use t instead of <Space> to display the prototype of the current tag
let g:tagbar_map_showproto="t"
nnoremap <leader>tc :TagbarCurrentTag s<CR>
nnoremap <leader>tt :TagbarToggle<CR>
nnoremap <leader>ta :TagbarOpenAutoClose<CR>

" For NERDTree plugin
let g:NERDTreeQuitOnOpen=1
let g:NERDTreeAutoDeleteBuffer=1
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
" Trailing space needed
nnoremap <leader>nb :NERDTreeFromBookmark 

" For EasyMotion plugin
map <Leader>m <Plug>(easymotion-prefix)

" Buffers navigation
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

" Diff the file in current buffer with the file last saved
function! DiffWithFileFromDisk()
    let filename=expand('%')
    let diffname=filename.'.fileFromBuffer'
    exec 'saveas! '.diffname
    diffthis
    vsplit
    exec 'edit '.filename
    diffthis
endfunction
nmap <F2> :call DiffWithFileFromDisk()<cr>
nmap <F3> :set paste!<CR>

let s:mouse_setting = &mouse
" Toggle mouse mode
function! ToggleMouse()
    if !has("mouse")
        return
    endif

    if &mouse == ""
        let &mouse = s:mouse_setting
        echo "Using mouse for Vim"
    else
        set mouse=
        echo "Using mouse for system"
    endif
endfunction
nmap <F4> :call ToggleMouse()<cr>

" Quickfix list navigation
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap <leader>qc :cclose<CR>
nnoremap <leader>qo :copen<CR>
nnoremap <leader>ql :clist<CR>

" Tags list navigation
nnoremap [t :tprevious<CR>
nnoremap ]t :tnext<CR>

" Location list navigation
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap <leader>lc :lclose<CR>
nnoremap <leader>lo :lopen<CR>
nnoremap <leader>ll :llist<CR>

" Preview window navigation
nnoremap [p :ptprevious<CR>
nnoremap ]p :ptnext<CR>

" Cscope keybindings
if has("cscope")
    nmap <leader>cgc :cscope find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ccc :cscope find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>csc :cscope find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ctc :cscope find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>cgv :vert scscope find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ccv :vert scscope find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>csv :vert scscope find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ctv :vert scscope find t <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>cgs :scscope find g <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>ccs :scscope find c <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>css :scscope find s <C-R>=expand("<cword>")<CR><CR>
    nmap <leader>cts :scscope find t <C-R>=expand("<cword>")<CR><CR>
endif

" Write to file
nnoremap <leader>ww :w<CR>
" Quit window
nnoremap <leader>wq :q<CR>
" Reload current file
nnoremap <leader>we :e<CR>
" Redraw the screen
nnoremap <leader>wr :redraw<CR>

" Open a new tab
nnoremap <leader>te :tabedit<CR>
" Alternate between current and the last-active tabs
let g:lasttab = 1
nnoremap <leader>0 :exe "tabn ".g:lasttab<CR>
" Tab Navigation Using Number
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt
nnoremap <leader>4 4gt
nnoremap <leader>5 5gt
nnoremap <leader>6 6gt
nnoremap <leader>7 7gt
nnoremap <leader>8 8gt
nnoremap <leader>9 9gt

" Copy/paste to/from system clipboard
vmap <leader>y "+y
nmap <leader>y "+y
nmap <leader>p "+p
nmap <leader>P "+P

" n<Enter> to go to line n
" nnoremap <CR> G
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" Select the text that was just pasted
nnoremap <leader>v V`]

" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Insert an empty line before {}
inoremap {<CR> {<CR>}<C-o>O
function! RecoverCR()
    imap {<CR> {<CR>
endfunction
call CommandAbbr('noclo', 'call RecoverCR()')

" Zoom/Restore window
function! ZoomToggle() abort
    if exists("t:zoomed") && t:zoomed
        exec t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
nnoremap <silent> <leader>z :call ZoomToggle()<CR>

" Toggle cursorline and cursorcolumn
function! ToggleCurrentCursorInfo()
    if &cursorline != &cursorcolumn
        set cursorline
        set cursorcolumn
    else
        set cursorline!
        set cursorcolumn!
    endif
endfunction
nnoremap <silent> <leader>ci :call ToggleCurrentCursorInfo()<CR>

" Flash cursorline and cursorcolumn
function! FlashCursor()
    set cursorline cursorcolumn
    redraw
    sleep 200m
    set nocursorline nocursorcolumn
endfunction
nnoremap <silent> <leader>cf :call FlashCursor()<CR>

" Set current working directory as well as some variables derived from it to
" current file's directory
function! ChangeCWD()
    cd %:p:h
    echo "Change CWD to ".getcwd()
    set path&
    execute "set path+=".fnameescape(getcwd()."/**")
endfunction
nmap <F5> :call ChangeCWD()<cr>

" Search pattern using grep in all the buffers
function! GrepBufferF(pattern)
    " Clear the quickfix window first
    cexpr []
    silent execute ":bufdo vimgrepadd ".a:pattern." %:p"
    set cursorline
    set cursorcolumn
    copen
endfunction
command! -nargs=+ GrepBuffer call GrepBufferF(<f-args>)
nnoremap <leader>gb :GrepBuffer 

" Highlight extra whitespaces
function! HighlightExtraWhiteSpace(insert_enter)
    hi ExtraWhitespace ctermbg=202 guibg=#ff5f00
    if a:insert_enter == 1
        match ExtraWhitespace /\s\+\%#\@<!$/
    else
        match ExtraWhitespace /\s\+$/
    endif
endfunction

" Map Ctrl+J and Ctrl+K to navigate down and up in popup menu.
" Ctrl+N and Ctrl+P may cause performance issue.
inoremap <expr> <C-J> pumvisible() ? "<Down>" : "<C-J>"
inoremap <expr> <C-K> pumvisible() ? "<Up>" : "<C-K>"

" Add support for markdown files in tagbar. We should copy the
" .markdown2ctags.py to the proper place to make it work.
let file_markdown2ctags='~/.vim/markdown2ctags.py'
if has("win16") || has("win32") || has("win64") || has("win95")
    let file_markdown2ctags=fnameescape($VIM."\\vimfiles\\markdown2ctags.py")
    if !filereadable(file_markdown2ctags)
        let file_markdown2ctags='~\vimfiles\markdown2ctags.py'
    endif
endif
if executable("python")
    let g:tagbar_type_markdown = {
        \ 'ctagstype': 'markdown',
        \ 'ctagsbin' : file_markdown2ctags,
        \ 'ctagsargs' : '-f - --sort=yes',
        \ 'kinds' : [
            \ 's:sections',
            \ 'i:images'
        \ ],
        \ 'sro' : '|',
        \ 'kind2scope' : {
            \ 's' : 'section',
        \ },
        \ 'sort': 0,
    \ }
endif

" For vim-cpp-enhanced-highlight plugin
let c_no_curly_error=1

" For ack.vim plugin
" Use ag instead of ack
if executable("ag")
    let g:ackprg='ag --nogroup --nocolor --column'
endif

function! HandleMdFile()
    " More readable tagbar
    hi! link TagbarScope NONE
endfunction

" For ctrlp plugin
let g:ctrlp_map='<leader>cp'
let g:ctrlp_extensions=['tag', 'buffertag']
let g:ctrlp_match_window='order:ttb,results:100'
let g:ctrlp_status_func={
    \ 'main': 'CtrlP_StatusLine_1',
    \ 'prog': 'CtrlP_StatusLine_2',
    \ }
" Arguments: focus, byfname, s:regexp, prv, item, nxt, marked
function! CtrlP_StatusLine_1(...)
    let focus='['.a:1.']'
    let byfname='['.a:2.']'
    let regex=a:3 ? 'regex' : ''
    let item='{'.a:5.'}'
    let marked = ' '.a:7.' '
    let dir = 'CWD['.getcwd().']%=%<'
    return focus.byfname.regex.item.marked.dir
endfunction
function! CtrlP_StatusLine_2(...)
    let len='['.a:1.']'
    let dir = 'CWD['.getcwd().']%=%<'
    return len.dir
endfunction
let g:ctrlp_max_files = 0
let g:ctrlp_max_depth = 50
" Always open a new instance
let g:ctrlp_switch_buffer = 0
" From spf13
if executable('ag')
    let s:ctrlp_fallback = 'ag -i --nocolor --nogroup --hidden -g "" %s'
elseif executable('ack-grep')
    let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
elseif executable('ack')
    let s:ctrlp_fallback = 'ack %s --nocolor -f'
elseif (has("win32") || has("win64") || has("win95") || has("win16"))
    let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
else
    let s:ctrlp_fallback = 'find %s -type f'
endif
if exists("g:ctrlp_user_command")
    unlet g:ctrlp_user_command
endif
let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': s:ctrlp_fallback
            \ }

" For LeaderF plugin
if has('python') || has('python3')
    let g:Lf_PreviewResult = { 'BufTag': 0, 'Function': 0 }
    let g:Lf_WorkingDirectoryMode = 'a'
    let g:Lf_ShortcutF = '<leader>cp'
    let g:Lf_ShortcutB = '<leader>cpb'
    nnoremap <leader>cpc :execute 'LeaderfFile' getcwd()<CR>
    nnoremap <leader>cpm :LeaderfMru<CR>
    nnoremap <leader>cpt :LeaderfTag<CR>
    nnoremap <leader>cpu :LeaderfBufTag<CR>
    nnoremap <leader>cpa :LeaderfBufTagAll<CR>
    nnoremap <leader>cpw :LeaderfBufTagAllCword<CR>
    nnoremap <leader>cpf :LeaderfFunction!<CR>
    nnoremap <leader>cpe :LeaderfFunctionAll<CR>
else
    nnoremap <leader>cpt :CtrlPTag<CR>
    nnoremap <leader>cpb :CtrlPBuffer<CR>
    nnoremap <leader>cpm :CtrlPMixed<CR>
    nnoremap <leader>cpu :CtrlPBufTag<CR>
    nnoremap <leader>cpa :CtrlPBufTagAll<CR>
    nnoremap <leader>cpc :CtrlP :pwd<CR>
    call CommandAbbr('cp', 'CtrlP')
endif

" For IndentLine plugin
let g:indentLine_concealcursor = ''

" For FSwitch plugin
let g:fsnonewfiles = 1
nnoremap <silent> <Leader>fs :FSHere<CR>
nnoremap <silent> <Leader>fr :FSSplitRight<CR>
nnoremap <silent> <Leader>fa :FSSplitAbove<CR>

" For Gutentags plugin
let g:gutentags_generate_on_new = 1
let g:gutentags_generate_on_missing = 1

let g:gutentags_generate_on_empty_buffer = 0
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project', 'dirs.proj', 'dirs']
let g:gutentags_ctags_tagfile = 'tags'
let s:vim_tags = expand('~/.cache/tags')
if s:gutentags_loaded == 1 && !isdirectory(s:vim_tags)
    silent! call mkdir(s:vim_tags, 'p')
endif
let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
" let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

let tag_common_exclude = ['*.json', '*.md', '*.obj', '*.pdb', '*.ini', '*.log', '*.txt', '*.vcxproj', '*.proj', '*.vimrc']
let g:gutentags_ctags_exclude = tag_common_exclude
let g:gutentags_ctags_exclude += ['*.css', '*.html', '*.js']
let g:gutentags_exclude_filetypes = tag_common_exclude

let g:gutentags_modules = []
if executable("ctags")
    let g:gutentags_modules += ['ctags']
endif
if executable("gtags-cscope") && executable("gtags")
    let g:gutentags_modules += ['gtags_cscope']
    let g:gutentags_cscope_executable="gtags-cscope"
endif

function! EnableGutentags(timerId)
    if g:gutentags_generate_on_new == 1
        return
    endif

    let g:gutentags_generate_on_new = 1
    let g:gutentags_generate_on_missing = 1

    silent! GutentagsUpdate
endfunction

" For AsyncRun plugin
let g:asyncrun_open = 6
let g:asyncrun_bell = 1
" Trailing space is needed
nnoremap <leader>ar :AsyncRun 

" For ALE plugin
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%](%severity%) %s'
nnoremap [a :ALEPreviousWrap<CR>
nnoremap ]a :ALENextWrap<CR>
nnoremap <leader>ad :ALEDetail<CR>
let g:ale_lint_delay = 500
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_enter = 0

" For vim-preview plugin
nnoremap <leader>tp :PreviewTag<CR>
nnoremap <leader>tg :PreviewGoto edit<CR>
nnoremap <leader>ts :PreviewSignature!<CR>
nnoremap <leader>tq :PreviewQuickfix<CR>

" Section about autocmd
if has('autocmd')
    augroup other_group
        autocmd!
        if has("gui_running")
            " Starting GUI will reset t_vb, so need to set it again
            autocmd GUIEnter * set visualbell t_vb=
        endif

        " The ftplugin may set the option, so we need to set it again
        autocmd FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r

        " Jump to the last position when reopening a file
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

        " Remember the last-active tab
        autocmd TabLeave * let g:lasttab = tabpagenr()

        " Auto enable/disable input method when in/leave insert mode
        autocmd InsertLeave * set imdisable | set iminsert=0
        if !has('nvim')
            autocmd InsertEnter * set noimdisable | set iminsert=2
        else
            " No effect in Neovim
            autocmd InsertEnter * set noimdisable | set iminsert=0
        endif

        " Hanlde markdown file type
        autocmd FileType markdown call HandleMdFile()
    augroup END

    augroup highlight_group
        autocmd!
        autocmd InsertEnter * call ChangeStatuslineColor(v:insertmode)
        autocmd InsertChange * call ChangeStatuslineColor(v:insertmode)
        autocmd InsertLeave * call ChangeStatuslineColor('n')
        autocmd InsertEnter * call HighlightExtraWhiteSpace(1)
        autocmd InsertLeave * call HighlightExtraWhiteSpace(0)
    augroup END
endif
