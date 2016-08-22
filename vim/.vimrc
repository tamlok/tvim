" Vim Configurations by tamlok
set nocompatible

if isdirectory($HOME."/.vim/bundle/Vundle.vim") || isdirectory($HOME."/vimfiles/bundle/Vundle.vim")
    " Vundle
    " git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    filetype off

    if isdirectory($HOME."/vimfiles/bundle/Vundle.vim")
        set rtp+=$HOME/vimfiles/bundle/Vundle.vim/
        call vundle#begin('$USERPROFILE/vimfiles/bundle/')
    else
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()
    endif
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'gtags.vim'
    Plugin 'tpope/vim-surround'
    Plugin 'closetag.vim'
    Plugin 'majutsushi/tagbar'
    Plugin 'Yggdroot/LeaderF'
    Plugin 'easymotion/vim-easymotion'
    Plugin 'gabrielelana/vim-markdown'
    Plugin 'octol/vim-cpp-enhanced-highlight'
    Plugin 'vim-ctrlspace/vim-ctrlspace'
    Plugin 'joker1007/vim-markdown-quote-syntax'
    Plugin 'mileszs/ack.vim'
    Plugin 'scrooloose/nerdtree'
    Plugin 'iamcco/markdown-preview.vim'
    Plugin 'ctrlpvim/ctrlp.vim'
    call vundle#end()
endif

filetype on
filetype plugin on
filetype indent on

set background=dark
set encoding=utf-8

" Short tab line for vim
function! ShortTabLine()
    let ret = ''
    for i in range(tabpagenr('$'))
        " Select the color group for highlighting active tab
        " Or ctermbg=230
        hi TabLineSelCus ctermfg=16 ctermbg=179 cterm=NONE
        if i + 1 == tabpagenr()
            let ret .= '%#TabLineSelCus#'
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
    let ret .= '%#TabLineFill#%T'
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

" GUI
if has("gui_running")
    set imcmdline

    set guioptions-=m       " Hide menu bar
    set guioptions-=T       " Hide tool bar
    set guioptions-=L       " Hide leftside scroll bar
    set guioptions-=r       " Hide rightside scroll bar
    set guioptions-=b       " Hide bottom scroll bar
    set guioptions+=c       " Use console dialog

    set guicursor=a:block
    set gcr+=o:hor50-Cursor
    set gcr+=n:Cursor
    set gcr+=i-ci-sm:InsertCursor
    set gcr+=r-cr:ReplaceCursor-hor20
    set gcr+=c:CommandCursor
    set gcr+=v-ve:VisualCursor
    set guicursor+=a:blinkon0

    set guitablabel=%{ShortTabLabel()}

    " Map <Ctrl+F2> to toggle the menu and toolbar
    map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
                            \set guioptions-=T <Bar>
                            \set guioptions-=m <Bar>
                        \else <Bar>
                            \set guioptions+=T <Bar>
                            \set guioptions+=m <Bar>
                        \endif<CR>

    if has("win16") || has("win32") || has("win64") || has("win95")
        set langmenu=zh_CN.UTF-8
        language message zh_CN.UTF-8
        set guifontset=
        set guifont=Consolas:h11
        set guifontwide=NSimsun:h11
        " Delete and reload the menu to use UTF-8 on Wins
        source $VIMRUNTIME/delmenu.vim
        source $VIMRUNTIME/menu.vim
    elseif has("unix")
        set guifontset=
        set guifont=Liberation\ Mono\ 11
    endif
else
    set tabline=%!ShortTabLine()
endif

" Colorscheme
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
endif

set fileencodings=UCS-BOM,UTF-8,Chinese
set termencoding=UTF-8

if has("syntax")
    syntax enable " Enable syntax processing
    syntax on
endif

set ruler       " Display the ruler
set showcmd     " Show the input command
set scrolloff=3 " Scroll 3 lines offset when cursor is near the buttom or the top
set autoindent
set cindent
set smartindent

set tabstop=4       " Number of visual spaces per TAB
set softtabstop=4   " Number of spaces in tab when editing
set shiftwidth=4
set expandtab     " convert tabs to spaces

set wildmenu        " Visual autocomplete for command menu
set wildmode=list:longest,full " Complete only up to the point of ambiguity

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

" Display tabs and trailing spaces
" set list
" set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set showmode        " Display current mode in the message line
" set relativenumber  " Display line number relative to current line
" set number          " Display absolute line number
set hlsearch        " Highlight matches
set incsearch       " Search as characters are entered
"set list lcs=tab:\|\   " Display Tab indent
set cc=81               " Highlight the 81th column

set complete-=i     " Do not scan included files in completion

set tags=./tags;/

" Automatically change current working directory when opening file or
" switching buffers.
" set autochdir

set confirm     " Ask for confirmation when handling unsaved or read-only files
set report=0
set showmatch   " Highlight matched parentheses
set matchtime=5 " Time for highlighting matched parentheses

set textwidth=0 " Disable auto wrapping of long lines
set wrapmargin=0

" Allow modified buffer to be hidden
set hidden

" Disable auto inserting comment leader one by one
set formatoptions-=c formatoptions-=o formatoptions-=r

" Statusline
set laststatus=2    " Always display the statusline
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P   " The default status line
set statusline=
set statusline+=%<
set statusline+=%#StatuslineBufNum#
set statusline+=%-2n   " Buffer number
set statusline+=%*
set statusline+=%F\     " Full file path

set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}\ 

" Display a warning if file format isn't unix
set statusline+=%#StatuslineWarning#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

" Help file flag, modified flag, read-only flag
set statusline+=%h%#Modifier#%m%*%r

" set statusline+=%=    " Left/right separator
set statusline+=\     " One space
set statusline+=[%{v:register}]\ 
" Cursor line / total lines Current column number and virtual column number
set statusline+=%-20.(row:%l-%L\(%P)\ col:%c%V%)

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
set exrc
set secure

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
    execute "cs add GTAGS ".fnameescape(getcwd())
    let GtagsCscope_Auto_Load=1
    let GtagsCscope_Quiet=1
endif

" Change StatueLine color according to the mode
function! InsertStatuslineColor(mode)
    if a:mode == 'r'
        hi StatusLine ctermbg=139 guibg=#af87af
    else
        hi StatusLine ctermbg=71 guibg=#5faf5f
    endif
endfunction

" Highlihgt of extra space
hi ExtraWhitespace ctermbg=202 guibg=orangered1

" Define abbr for only ':' command mode
function! CommandAbbr(abbr, cmd)
    exec "cabbr <expr> " . a:abbr . " getcmdtype() == ':' ? '" . a:cmd . "' : '" . a:abbr . "'"
endfunction

" Abbr to change to expanding tab with 4 spaces
call CommandAbbr('extab', 'set tabstop=4 \| set softtabstop=4 \| set shiftwidth=4 \| set expandtab')
call CommandAbbr('noextab', 'set tabstop=8 \| set softtabstop=8 \| set shiftwidth=8 \| set noexpandtab')

call CommandAbbr('fms', 'set foldmethod=syntax')
call CommandAbbr('gta', 'Gtags')
call CommandAbbr('gtr', 'Gtags -r')
call CommandAbbr('csf', 'cscope find')
call CommandAbbr('vcs', 'vert scscope find')
call CommandAbbr('scs', 'scscope find')

" Update ctags and gtags
function! UpdateTags()
    if executable("ctags")
        echom "Updating ctags ..."
        call system("ctags -R")
    endif
    if executable("global")
        echom "Updating gtags ..."
        call system("global -u")
    endif
endfunction
call CommandAbbr("upt", 'call UpdateTags()')

" Change highlights to a darker mode
function! ChangeDarkHighlightMode()
    hi Normal guifg=White guibg=#262626 ctermfg=255 ctermbg=235
    hi CursorColumn ctermbg=236 guibg=#303030
    hi CursorLine term=NONE cterm=NONE ctermbg=237 gui=none guibg=#3a3a3a
    hi ColorColumn ctermbg=238 guibg=#444444
endfunction
call CommandAbbr('hidark', 'call ChangeDarkHighlightMode()')

map <space> <leader>

" For Tagbar plugin
let g:tagbar_autofocus = 1
let g:tagbar_left=1
nnoremap <leader>tc :TagbarCurrentTag s<CR>
nnoremap <leader>tt :TagbarToggle<CR>
nnoremap <leader>ta :TagbarOpenAutoClose<CR>
function! DisplayCurrentTag()
    try
        TagbarCurrentTag
    catch
    endtry
endfunction

" For NERDTree plugin
nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>nf :NERDTreeFind<CR>

" For LeaderF plugin
let g:Lf_ShortcutF = '<leader>lf'
let g:Lf_ShortcutB = '<leader>lb'

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

" Search for selected text
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

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
nnoremap <silent> <leader>ci :set cursorline! \| set cursorcolumn!<CR>

" Set current working directory as well as some variables derived from it to
" current file's directory
function! ChangeCWD()
    cd %:p:h
    echo "Change CWD to ".getcwd()
    set path&
    execute "set path+=".fnameescape(getcwd()."/**")
    cs kill -1
    execute "cs add GTAGS ".fnameescape(getcwd())
endfunction
nmap <F5> :call ChangeCWD()<cr>

" vim-markdown plugin
let g:markdown_enable_mappings=0
let g:markdown_enable_spell_checking=0
let g:markdown_enable_input_abbreviations=0

" Add support for markdown files in tagbar. We should copy the
" markdown2ctags.py to the proper place to make it work.
let file_markdown2ctags='~/.vim/markdown2ctags.py'
if has("win16") || has("win32") || has("win64") || has("win95")
    let file_markdown2ctags='~\vimfiles\markdown2ctags.py'
endif
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

" For vim-cpp-enhanced-highlight plugin
let c_no_curly_error=1

" For CtrlSpace plugin
let g:CtrlSpaceSymbols={"CS": "CtrlSpace", "Sin": "Single", "All": "All", "Vis": "Visible", "File": "File", "WLoad": "Workspace Load",
            \ "WSave": "Workspace Save", "Zoom": "Zoom", "IV": "-", "IA": "*", "IM": "+", "BM": "Bookmark", "Tabs": "Tab List"}
let g:CtrlSpaceSearchTiming=500
let g:CtrlSpaceUseTabline=0
let g:CtrlSpaceDefaultMappingKey="<leader>s"
if executable("ag")
    let g:CtrlSpaceGlobCommand='ag -l --nocolor -g ""'
endif

" For ack.vim plugin
" Use ag instead of ack
if executable("ag")
    let g:ackprg='ag --nogroup --nocolor --column'
endif

" For markdown-preview.vim plugin
let g:mkdp_path_to_chrome="chrome"
let g:mkdp_auto_close=0
nmap <F6> <Plug>MarkdownPreview
nmap <F7> <Plug>StopMarkdownPreview

function! HandleMdFile()
    iabbr *** *************************
endfunction

" For ctrlp plugin
let g:ctrlp_map='<leader>cp'
let g:ctrlp_extensions=['tag', 'buffertag']
let g:ctrlp_match_window='order:ttb'
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
nnoremap <leader>cpt :CtrlPTag<CR>
nnoremap <leader>cpb :CtrlPBufTag<CR>

" Section about autocmd
if has('autocmd')
    augroup other_group
        autocmd!
        if has("gui_running")
            " Starting GUI will reset t_vb, so need to set it again
            autocmd GUIEnter * set visualbell t_vb=
        endif
        " Disable auto inserting command leader one by one.
        " The ftplugin may set the option, so we need to set it again.
        autocmd FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r
        " Jump to the last position when reopening a file
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
        " Remember the last-active tab
        autocmd TabLeave * let g:lasttab = tabpagenr()
        " Tagbar plugin, auto display current tag in statusline
        if isdirectory($HOME."/.vim/bundle/tagbar") || isdirectory($HOME."/vimfiles/bundle/tagbar")
            autocmd CursorHold * call DisplayCurrentTag()
        endif

        " Auto enable/disable input method when in/leave insert mode
        autocmd InsertLeave * set imdisable | set iminsert=0
        autocmd InsertEnter * set noimdisable | set iminsert=0

        " Hanlde markdown file type
        autocmd FileType markdown call HandleMdFile()
    augroup END

    augroup highlight_group
        autocmd!
        autocmd InsertEnter * call InsertStatuslineColor(v:insertmode)
        autocmd InsertChange * call InsertStatuslineColor(v:insertmode)
        autocmd InsertLeave * hi StatusLine ctermbg=179 guibg=LightGoldenrod3
        autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
        autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
        autocmd InsertLeave * match ExtraWhitespace /\s\+$/
    augroup END
endif
