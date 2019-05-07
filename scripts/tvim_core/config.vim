set encoding=utf-8

" Italic font
set t_ZH=[3m
set t_ZR=[23m

set fileencodings=UCS-BOM,UTF-8,Chinese
set termencoding=UTF-8

if has("syntax")
    " Enable syntax processing
    syntax enable
    syntax on
endif

set autoindent
set cindent
set smartindent
set ignorecase
set smartcase

call SetTabStopWidth(4)

" Visual autocomplete for command menu
set wildmenu
" Complete only up to the point of ambiguity
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*.bin,*.dll,*.exe

" Store temp files in a central spot
if g:tvim_os == 'win'
    let s:tempdir='~\AppData\Local\Temp'
else
    let s:tempdir='~/.vim_tmp,~/.tmp,~/tmp,/var/tmp,/tmp'
endif

execute 'set backupdir=' . s:tempdir
execute 'set directory=' . s:tempdir

" Do not scan included files in <C-P> completion
set complete-=i
set completeopt=menuone,preview

" Ask for confirmation when handling unsaved or read-only files
set confirm

set report=0

" Highlight matched parentheses
set showmatch
" Time for highlighting matched parentheses
set matchtime=5

" Disable auto wrapping of long lines
set textwidth=0
set wrapmargin=0

" Allow modified buffer to be hidden
set hidden

set formatoptions-=c formatoptions-=o formatoptions-=r

" Valid in terminal. Need to set it again after GUI enter.
set noerrorbells visualbell t_vb=

" Enable folding
set foldenable
" Column to show the hints for folding
" set foldcolumn=2
" Open most folds by default
set foldlevelstart=10
" 10 nested fold max
set foldnestmax=20
" Fold based on indent level
set foldmethod=indent

" Indicates a fast terminal connection
set ttyfast

set history=200

" Enable matchit plugin to enable % to jump between keyword like if/end
runtime macros/matchit.vim

" Let backspace behave well in insert mode
set backspace=indent,eol,start

let g:tvim_last_active_tab = 1

if has('autocmd')
    augroup other_group
        autocmd!
        " The ftplugin may set the option, so we need to set it again
        autocmd FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r

        " Jump to the last position when reopening a file
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

        " Remember the last-active tab
        autocmd TabLeave * let g:tvim_last_active_tab = tabpagenr()

        " Auto enable/disable input method when in/leave insert mode
        autocmd InsertLeave * set imdisable | set iminsert=0
        autocmd InsertEnter * set noimdisable | set iminsert=0
    augroup END
endif
