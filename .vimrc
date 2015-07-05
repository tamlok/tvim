" Vim Configurations by tamlok
set nocompatible
colorscheme evening
set encoding=utf-8

" GUI
if has("gui_running")
    source $VIMRUNTIME/vimrc_example.vim

    set langmenu=zh_CN.UTF-8
    set imcmdline
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim
    language message zh_CN.UTF-8

    au GUIEnter * simalt ~x	" 窗口启动时自动最大化
    set guioptions-=m	" 隐藏菜单栏
    set guioptions-=T	" 隐藏工具栏
    set guioptions-=L	" 隐藏左侧滚动条
    set guioptions-=r	" 隐藏右侧滚动条
    set guioptions-=b	" 隐藏底部滚动条
    set guifontset=
    set guifont=Consolas:h11
    colorscheme desert
endif

set fileencodings=UCS-BOM,UTF-8,Chinese
set termencoding=UTF-8

if has("syntax")
    syntax enable
    syntax on
endif

if has("autocmd")
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    "have Vim load indentation rules and plugins according to the detected filetype
    filetype plugin indent on
endif

set ruler	" Display the ruler
set showcmd	" Show the input command
set scrolloff=3	" Scroll 3 lines offset when cursor is near the buttom or the top
set autoindent
set cindent
set smartindent

set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab

filetype on
filetype plugin on

" Display tabs and trailing spaces
" set list
" set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set showmode	" Display current mode in the message line
"set relativenumber	" Display line number relative to current line
"set number	" Display absolute line number
set hlsearch
set incsearch
"set list lcs=tab:\|\ 	" Display Tab indent
set cc=80	" Highlight the 80th column

set tags=./tags;/
set autochdir

set confirm	" Ask for confirmation when handling unsaved or read-only files
set report=0
set showmatch	" Highlight matched parentheses
set matchtime=5	" Time for highlighting matched parentheses

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

" Key mapping
" Ctrl-c to open the definition in a new tab
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
" Alt-] to open the definition in a vertical split window
" map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

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

set noerrorbells visualbell t_vb=
if has('autocmd')
	autocmd GUIEnter * set visualbell t_vb=
endif

set nowrap
set tw=0
set wrapmargin=0
