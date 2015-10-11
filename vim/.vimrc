" Vim Configurations by tamlok
set nocompatible

if has("unix")
    " Vundle
    " git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    filetype off

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'gtags.vim'
    Plugin 'genutils'
    Plugin 'lookupfile'
    call vundle#end()
endif

filetype on
filetype plugin on
filetype indent on

set background=dark
set t_Co=256
set encoding=utf-8

" Short tab line for vim
function ShortTabLine()
    let ret = ''
    for i in range(tabpagenr('$'))
        " select the color group for highlighting active tab
        if i + 1 == tabpagenr()
            let ret .= '%#errorMsg#'
        else
            let ret .= '%#TabLine#'
        endif

        " find the buffername for the tablabel
        let buflist = tabpagebuflist(i+1)
        let winnr = tabpagewinnr(i+1)
        let buffername = bufname(buflist[winnr - 1])
        let filename = fnamemodify(buffername, ':t')
        " check if there is no name
        if filename == ''
            let filename = 'noname'
        endif
        let ret .= '['.filename.']'
    endfor

    " after the last tab fill with TabLineFill and reset tab page #
    let ret .= '%#TabLineFill#%T'
    return ret
endfunction

" Short tab line for gvim
function ShortTabLabel()
    let bufnrlist = tabpagebuflist(v:lnum)
    let label = bufname(bufnrlist[tabpagewinnr(v:lnum) - 1])
    let filename = fnamemodify(label, ':t')
    let ret = filename
    return ret
endfunction

let current_color = ""

" GUI
if has("gui_running")
    source $VIMRUNTIME/vimrc_example.vim

    set imcmdline
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    au GUIEnter * simalt ~x " Maximize the window at startup
    set guioptions-=m       " Hide menu bar
    set guioptions-=T       " Hide tool bar
    set guioptions-=L       " Hide leftside scroll bar
    set guioptions-=r       " Hide rightside scroll bar
    set guioptions-=b       " Hide bottom scroll bar

    colorscheme desert
    let current_color = "desert"

    set guitablabel=%{ShortTabLabel()}

    " Map <Ctrl+F2> to toggle the menu and toolbar
    map <silent> <C-F2> :if &guioptions =~# 'T' <Bar>
                            \set guioptions-=T <Bar>
                            \set guioptions-=m <Bar>
                        \else <Bar>
                            \set guioptions+=T <Bar>
                            \set guioptions+=m <Bar>
                        \endif<CR>

    if has('autocmd')
        autocmd GUIEnter * set visualbell t_vb=
    endif

    if has("win16") || has("win32") || has("win64") || has("win95")
        set langmenu=zh_CN.UTF-8
        language message zh_CN.UTF-8
        set guifontset=
        set guifont=Consolas:h11
    elseif has("unix")
        set guifontset=
        set guifont=Liberation\ Mono\ 11
    endif
else
    colorscheme torte
    let current_color = "torte"
    set tabline=%!ShortTabLine()
endif

set fileencodings=UCS-BOM,UTF-8,Chinese
set termencoding=UTF-8

if has("syntax")
    syntax enable " Enable syntax processing
    syntax on
endif

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

set ruler       " Display the ruler
set showcmd     " Show the input command
set scrolloff=3 " Scroll 3 lines offset when cursor is near the buttom or the top
set autoindent
set cindent
set smartindent

set tabstop=8       " Number of visual spaces per TAB
set softtabstop=8   " Number of spaces in tab when editing
set shiftwidth=8
set noexpandtab     " Do not convert tabs to spaces

set wildmenu        " Visual autocomplete for command menu
set wildmode=list:longest " Complete only up to the point of ambiguity
set lazyredraw      " Redraw only when we need to

set title           " Set the terminal title

" Store temp files in a central spot. Should mkdir ~/.vim_tmp
set backupdir=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" Display tabs and trailing spaces
" set list
" set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set showmode	    " Display current mode in the message line
"set relativenumber	" Display line number relative to current line
set number	        " Display absolute line number
set hlsearch        " Highlight matches
set incsearch       " Search as characters are entered
"set list lcs=tab:\|\   " Display Tab indent
set cc=81               " Highlight the 80th column

set tags=./tags;/
set autochdir

set confirm     " Ask for confirmation when handling unsaved or read-only files
set report=0
set showmatch   " Highlight matched parentheses
set matchtime=5 " Time for highlighting matched parentheses

set textwidth=0	" Disable auto wrapping of long lines
set wrapmargin=0

"set formatoptions-=cro	" Disable auto inserting comment leader
autocmd FileType * setlocal formatoptions-=ro

" Statusline
set laststatus=2	" Always display the statusline
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P	" The default status line
set statusline=
set statusline+=%<
set statusline+=[%n]\ 	" Buffer number
set statusline+=%F\ 	" Full file path

set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}\ 

" Display a warning if file format isn't unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

set statusline+=%h%m%r	" Help file flag, modified flag, read-only flag

set statusline+=%=	" Left/right separator
" Cursor line / total lines Current column number and virtual column number
set statusline+=%-14.(%l/%L,%c%V%)\ 
set statusline+=%P	" Percentage in the file

set noerrorbells visualbell t_vb=

set tw=0
set wrapmargin=0
set foldenable      " Enable folding
set foldcolumn=2
set foldlevelstart=10   " Open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " Fold based on indent level
set cursorline      " Highlight current line

" find command
set path+=$PWD/**

" GNU GLOBAL or cscope
" Let cscope replace ctags
" set cscopetag
" let CtagsCscope_Auto_Map=1
if has("unix") && filereadable("/usr/bin/gtags-cscope")
    set csprg=gtags-cscope
    cs add GTAGS $PWD
    let GtagsCscope_Auto_Load=1
    let GtagsCscope_Quiet=1
endif

" Lookupfile
let g:LookupFile_MinPatLength=2
let g:LookupFile_PreserveLastPattern=0
let g:LookupFile_PreservePatternHistory=1
let g:LookupFile_AlwaysAcceptFirst=1
let g:LookupFile_AllowNewFiles=0

" .filetags can be generated using scripts/genfiletags.sh
if filereadable("./.filetags")
    let g:LookupFile_TagExpr='"./.filetags"'
endif

" Case insensitive search
function! LookupFile_IgnoreCaseFunc(pattern)
    let _tags=&tags
    try
        let &tags=eval(g:LookupFile_TagExpr)
        let newpattern='\c'.a:pattern
        let tags=taglist(newpattern)
    catch
        echohl ErrorMsg | echo "Exception: ".v:exception | echohl NONE
        return ""
    finally
        let &tags=_tags
    endtry

    " Show the matches for what is typed so far
    let files=map(tags, 'v:val["filename"]')
    return files
endfunction
let g:LookupFile_LookupFunc='LookupFile_IgnoreCaseFunc'
" End lookupfile

" Section about changing color
if current_color == "desert"
    hi LineNr guifg=DarkKhaki
elseif current_color == "torte"
    hi CursorLine term=NONE cterm=NONE ctermbg=238
    hi Search term=reverse ctermfg=229 ctermbg=136
    hi StatusLine ctermfg=16 ctermbg=144 cterm=NONE
    hi StatusLineNC ctermfg=244 ctermbg=144 cterm=NONE
    hi Comment term=bold ctermfg=74 " 117
    hi Constant term=underline ctermfg=217
    hi LineNr term=underline ctermfg=143
    hi Folded ctermfg=220
    hi FoldColumn ctermfg=220
    hi Special ctermfg=214
    hi NonText ctermfg=152 ctermbg=239
    hi Visual ctermfg=186 ctermbg=64 cterm=NONE
endif

if has("gui_running")
    set gcr=a:block
    " mode aware cursors, change the color of the cursor based on current mode
    set gcr+=o:hor50-Cursor
    set gcr+=n:Cursor
    set gcr+=i-ci-sm:InsertCursor
    set gcr+=r-cr:ReplaceCursor-hor20
    set gcr+=c:CommandCursor
    set gcr+=v-ve:VisualCursor
    set gcr+=a:blinkon0
    hi InsertCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=37  guibg=#2aa198
    hi VisualCursor  ctermfg=15 guifg=#fdf6e3 ctermbg=125 guibg=#d33682
    hi ReplaceCursor ctermfg=15 guifg=#fdf6e3 ctermbg=65  guibg=#dc322f
    hi CommandCursor ctermfg=15 guifg=#fdf6e3 ctermbg=166 guibg=#cb4b16
endif

" Highlihgt extra space
hi ExtraWhitespace ctermbg=202 guibg=orangered1
:autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
:autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
:autocmd InsertLeave * match ExtraWhitespace /\s\+$/

" Section about functions
" Diff the file in current buffer with the file last saved
function DiffWithFileFromDisk()
    let filename=expand('%')
    let diffname=filename.'.fileFromBuffer'
    exec 'saveas! '.diffname
    diffthis
    vsplit
    exec 'edit '.filename
    diffthis
endfunction

" Section about Key mapping and Abbreviation
" Abbr to change to expanding tab with 4 spaces
cabbr extab set tabstop=4 \| set softtabstop=4 \| set shiftwidth=4 \| set expandtab
cabbr noextab set tabstop=8 \| set softtabstop=8 \| set shiftwidth=8 \| set noexpandtab
cabbr fms set foldmethod=syntax
cabbr gta Gtags
cabbr gtr Gtags -r
cabbr csf cs find
cabbr luf LookupFile
cabbr lub LUBufs
cabbr luw LUWalk

map <space> <leader>
map <C-down> <ESC>:bn<CR>
map <C-up> <ESC>:bp<CR>
nmap <F7> :call DiffWithFileFromDisk()<cr>
nmap <F8> :set paste!<CR>
" Quickfix list navigation
nmap <C-n> :cn<CR>
nmap <C-p> :cp<CR>
" Close Quickfix list
nmap <C-x> :cclose<CR>
nmap <leader>d :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>r :cs find c <C-R>=expand("<cword>")<CR><CR>
" Write to file
nnoremap <leader>w :w<CR>
" Copy/paste to/from system clipboard
vmap <leader>y "+y
nmap <leader>y "+y
nmap <leader>p "+p
nmap <leader>P "+P
" n<Enter> to go to line n
nnoremap <CR> G
" Turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>
" Select the text that was just pasted
nnoremap <leader>v V`]
" jj to Esc
inoremap jj <ESC>
" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
