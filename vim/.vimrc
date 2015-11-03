" Vim Configurations by tamlok
set nocompatible

if isdirectory($HOME."/.vim/bundle/Vundle.vim")
    " Vundle
    " git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    filetype off

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'gtags.vim'
    Plugin 'genutils'
    Plugin 'lookupfile'
    Plugin 'tpope/vim-surround'
    " Plugin 'Townk/vim-autoclose'
    Plugin 'closetag.vim'
    call vundle#end()
endif

filetype on
filetype plugin on
filetype indent on

set background=dark
set t_Co=256
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

let current_color = ""

" GUI
if has("gui_running")
    set imcmdline

    set guioptions-=m       " Hide menu bar
    set guioptions-=T       " Hide tool bar
    set guioptions-=L       " Hide leftside scroll bar
    set guioptions-=r       " Hide rightside scroll bar
    set guioptions-=b       " Hide bottom scroll bar

    set gcr=a:block

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
set wildmode=list:longest,full " Complete only up to the point of ambiguity

set title           " Set the terminal title

" Store temp files in a central spot. Should mkdir ~/.vim_tmp
if has("unix")
    set backupdir=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set directory=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

" Display tabs and trailing spaces
" set list
" set listchars=tab:▷⋅,trail:⋅,nbsp:⋅

set showmode        " Display current mode in the message line
set relativenumber  " Display line number relative to current line
set number          " Display absolute line number
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

set textwidth=0 " Disable auto wrapping of long lines
set wrapmargin=0

" Allow modified buffer to be hidden
set hidden

"set formatoptions-=cro " Disable auto inserting comment leader
if has("autocmd")
    autocmd FileType * setlocal formatoptions-=ro
endif

" Statusline
set laststatus=2    " Always display the statusline
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P   " The default status line
set statusline=
set statusline+=%<
set statusline+=[%n]\   " Buffer number
set statusline+=%F\     " Full file path

set statusline+=%{\"[\".(&fenc==\"\"?&enc:&fenc).((exists(\"+bomb\")\ &&\ &bomb)?\",B\":\"\").\"]\ \"}\ 

" Display a warning if file format isn't unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

set statusline+=%h%m%r  " Help file flag, modified flag, read-only flag

" set statusline+=%=    " Left/right separator
set statusline+=\ \     " Two spaces
" Cursor line / total lines Current column number and virtual column number
set statusline+=%-14.(%l/%L,%c%V%)\  " Trailing space
set statusline+=%P      " Percentage in the file

set noerrorbells visualbell t_vb=

set foldenable      " Enable folding
set foldcolumn=2
set foldlevelstart=10   " Open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " Fold based on indent level
set cursorline      " Highlight current line

" find command
execute "set path+=".getcwd()."/**"

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
set secure

" Enable matchit plugin to enable % to jump between keyword like if/end
runtime macros/matchit.vim

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
    " Or guibg=NavajoWhite1
    hi StatusLine guifg=black guibg=LightGoldenrod3
    hi PmenuSel guifg=black guibg=LightGoldenrod3
    " Or guibg=Plum3
    hi Pmenu guifg=black guibg=RosyBrown
    hi CursorLine guibg=Grey27
elseif current_color == "torte"
    hi CursorLine term=NONE cterm=NONE ctermbg=238
    hi Search term=reverse ctermfg=229 ctermbg=136
    hi StatusLine ctermfg=16 ctermbg=179 cterm=NONE
    hi StatusLineNC ctermfg=244 ctermbg=144 cterm=NONE
    hi Comment term=bold ctermfg=74
    hi Constant term=underline ctermfg=217
    hi LineNr term=underline ctermfg=143
    hi Folded ctermfg=220
    hi FoldColumn ctermfg=220
    hi Special ctermfg=214
    hi NonText ctermfg=152 ctermbg=239
    hi Visual ctermfg=186 ctermbg=64 cterm=NONE
    hi PmenuSel ctermfg=16 ctermbg=179 cterm=NONE
    hi Pmenu ctermfg=16 ctermbg=138
endif

" Highlihgt extra space
hi ExtraWhitespace ctermbg=202 guibg=orangered1
if has("autocmd")
    :autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    :autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    :autocmd InsertLeave * match ExtraWhitespace /\s\+$/
endif

" Section about functions
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

" Buffers navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

nmap <F7> :call DiffWithFileFromDisk()<cr>
nmap <F8> :set paste!<CR>

" Quickfix list navigation
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
" Close Quickfix list
nmap <C-x> :cclose<CR>

" Tags list navigation
nnoremap <silent> [t :tprevious<CR>
nnoremap <silent> ]t :tnext<CR>

" Location list navigation
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>

nmap <leader>d :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>r :cs find c <C-R>=expand("<cword>")<CR><CR>
" Write to file
nnoremap <leader>w :w<CR>
" Quit window
nnoremap <leader>q :q<CR>
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
" inoremap jj <ESC>
" Split window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" For AutoClose plugin, insert an empty line before {}
inoremap {<CR> {<CR>}<C-o>O
function! RecoverCR()
    imap {<CR> {<CR>
endfunction
" cabbr noclo call RecoverCR() \| AutoCloseOff
cabbr noclo call RecoverCR()

" Search for selected text
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>
function! s:VSetSearch()
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
    let @s = temp
endfunction
