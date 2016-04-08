" Vim Configurations by tamlok
set nocompatible

if isdirectory($HOME."/.vim/bundle/Vundle.vim") || isdirectory($HOME."/vimfiles/plugin/Vundle.vim")
    " Vundle
    " git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
    filetype off

    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    Plugin 'VundleVim/Vundle.vim'
    Plugin 'gtags.vim'
    Plugin 'tpope/vim-surround'
    Plugin 'closetag.vim'
    Plugin 'majutsushi/tagbar'
    Plugin 'Yggdroot/LeaderF'
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

" Store temp files in a central spot. Should mkdir ~/.vim_tmp
if has("unix")
    set backupdir=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
    set directory=~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp
endif

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
" Use -1 instead of 100 to let any matching to replace this matching
" call matchadd('ColorColumn', '\%81v', 100)

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
set statusline+=\ #%n\    " Buffer number
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
set statusline+=\ \     " Two spaces
" Cursor line / total lines Current column number and virtual column number
set statusline+=%-14.(%l/%L,%c%V%)\  " Trailing space
set statusline+=%P      " Percentage in the file

" Valid in terminal. Need to set it again after GUI enter.
set noerrorbells visualbell t_vb=

set foldenable      " Enable folding
" set foldcolumn=2  " Column to show the hints for folding
set foldlevelstart=10   " Open most folds by default
set foldnestmax=10      " 10 nested fold max
set foldmethod=indent   " Fold based on indent level
set cursorline      " Highlight current line
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
call CommandAbbr('tbt', 'TagbarToggle')
call CommandAbbr('tboa', 'TagbarOpenAutoClose')
nnoremap <leader>tc :TagbarCurrentTag s<CR>

" Buffers navigation
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>

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

" Cscope keybindings
nmap <leader>cg :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cc :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <leader>cs :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <leader>ct :cs find t <C-R>=expand("<cword>")<CR><CR>

" Write to file
nnoremap <leader>w :w<CR>
" Quit window
nnoremap <leader>q :q<CR>
" Reload current file
nnoremap <leader>e :e<CR>
" Redraw the screen
nnoremap <leader>l :redraw<CR>
" Open a new tab
nnoremap <leader>te :tabedit<CR>
" Next tab
nnoremap <tab> :tabnext<CR>
" Previous tab
nnoremap <S-tab> :tabprevious<CR>

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
" Set current split to 100 line width, like Zooming
nnoremap <leader>z 100<C-w>\|

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

" Alternate between current and the last-active tabs
let g:lasttab = 1
nnoremap <leader>tl :exe "tabn ".g:lasttab<CR>

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
