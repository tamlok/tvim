" ==Commands==
command! -nargs=1 TTab call SetTabStopWidth(<f-args>)
command! -nargs=0 TKeys call ShowKeyBindings()
command! -nargs=0 TAbbrs call ShowCommandAbbrs()
command! -nargs=1 TCmd call BufferCmd(<f-args>)
command! -nargs=0 TSaveMode call ToggleSaveMode()

" ==Key bindings==
call AddKeyBinding('map <space> <leader>', 'Use <space> as leader key')
" nvim and macvim do not map <c-6> automatically
call AddKeyBinding('nnoremap <C-6> <C-^>', 'Map <C-6> to alternate between buffers')

" Buffer
call AddKeyBinding('nnoremap [b :bprevious<CR>', 'Previous buffer')
call AddKeyBinding('nnoremap ]b :bnext<CR>', 'Next buffer')
call AddKeyBinding('nnoremap [B :bfirst<CR>', 'First buffer')
call AddKeyBinding('nnoremap ]B :blast<CR>', 'Last buffer')

" Quickfix
call AddKeyBinding('nnoremap [c :cprevious<CR>', 'Previous quickfix error')
call AddKeyBinding('nnoremap ]c :cnext<CR>', 'Next quickfix error')
call AddKeyBinding('nnoremap [C :cfirst<CR>', 'First quickfix error')
call AddKeyBinding('nnoremap ]C :clast<CR>', 'Last quickfix error')
" [w]
call AddKeyBinding('nnoremap <leader>wcc :cclose<CR>', 'Close quickfix window')
call AddKeyBinding('nnoremap <leader>wco :copen<CR>', 'Open quickfix window')
call AddKeyBinding('nnoremap <leader>wcl :clist<CR>', 'List all quickfix error')

" Tag
call AddKeyBinding('nnoremap [t :tprevious<CR>', 'Previous tag')
call AddKeyBinding('nnoremap ]t :tnext<CR>', 'Next tag')
call AddKeyBinding('nnoremap [T :tfirst<CR>', 'First tag')
call AddKeyBinding('nnoremap ]T :tlast<CR>', 'Last tag')

" Preview tag
call AddKeyBinding('nnoremap [r :ptprevious<CR>', 'Preview previous tag')
call AddKeyBinding('nnoremap ]r :ptnext<CR>', 'Preview next tag')
call AddKeyBinding('nnoremap [R :ptfirst<CR>', 'Preview first tag')
call AddKeyBinding('nnoremap ]R :ptlast<CR>', 'Preview last tag')

" Location
call AddKeyBinding('nnoremap [l :lprevious<CR>', 'Previous location')
call AddKeyBinding('nnoremap ]l :lnext<CR>', 'Next location')
call AddKeyBinding('nnoremap [L :lfirst<CR>', 'First location')
call AddKeyBinding('nnoremap ]L :llast<CR>', 'Last location')
" [w]
call AddKeyBinding('nnoremap <leader>wlc :lclose<CR>', 'Close location window')
call AddKeyBinding('nnoremap <leader>wlo :lopen<CR>', 'Open location window')
call AddKeyBinding('nnoremap <leader>wll :llist<CR>', 'List all locations')

" [w]
call AddKeyBinding('nnoremap <leader>ww :w<CR>', 'Save current buffer')
call AddKeyBinding('nnoremap <leader>wq :q<CR>', 'Quit current window')
call AddKeyBinding('nnoremap <leader>we :e<CR>', 'Reload current buffer')
call AddKeyBinding('nnoremap <leader>wr :redraw<CR>', 'Redraw screen')
call AddKeyBinding('nnoremap <leader>wt :tabedit<CR>', 'Open a new tab')
call AddKeyBinding('nnoremap <silent> <leader>wz :call ZoomRestoreCurrentWindow()<CR>',
                   \ 'Zoom/Restore current window')
call AddKeyBinding('nnoremap <silent> <leader>wh :call ToggleCursorHighlight()<CR>',
                   \ 'Toggle highlight of cursor line and column')

" Tab
call AddKeyBinding('nnoremap <leader>0 :exe "tabn " . g:tvim_last_active_tab<CR>',
                   \ 'Alternate between current and last active tab')
call AddKeyBinding('nnoremap <leader>1 1gt', 'Go to tab 1')
call AddKeyBinding('nnoremap <leader>2 2gt', 'Go to tab 2')
call AddKeyBinding('nnoremap <leader>3 3gt', 'Go to tab 3')
call AddKeyBinding('nnoremap <leader>4 4gt', 'Go to tab 4')
call AddKeyBinding('nnoremap <leader>5 5gt', 'Go to tab 5')
call AddKeyBinding('nnoremap <leader>6 6gt', 'Go to tab 6')
call AddKeyBinding('nnoremap <leader>7 7gt', 'Go to tab 7')
call AddKeyBinding('nnoremap <leader>8 8gt', 'Go to tab 8')
call AddKeyBinding('nnoremap <leader>9 9gt', 'Go to tab 9')

" Register
" [p]
call AddKeyBinding('nnoremap <leader>p "+', "Use selection register '+' (system clipboard)")
call AddKeyBinding('vnoremap <leader>p "+', "Use selection register '+' (system clipboard)")
" [o]
call AddKeyBinding('nnoremap <leader>o "_', "Use black hole register '_'")
call AddKeyBinding('vnoremap <leader>o "_', "Use black hole register '_'")

" [<space>]
call AddKeyBinding('nnoremap <leader><space> :nohlsearch<CR>', 'Clear search highlight')

" Select the text that was just pasted
" [v]
call AddKeyBinding('nnoremap <leader>v V`]', 'Select text just pasted')

" Navigate through window splits
call AddKeyBinding('nnoremap <C-h> <C-w>h', 'Move cursor one split window left')
call AddKeyBinding('nnoremap <C-j> <C-w>j', 'Move cursor one split window up')
call AddKeyBinding('nnoremap <C-k> <C-w>k', 'Move cursor one split window down')
call AddKeyBinding('nnoremap <C-l> <C-w>l', 'Move cursor one split window right')

" Map Ctrl+J and Ctrl+K to navigate down and up in popup menu.
" Ctrl+N and Ctrl+P may cause performance issue.
call AddKeyBinding('inoremap <expr> <C-J> pumvisible() ? "<Down>" : "<C-J>"',
                   \ 'Move down in popup menu without completion')
call AddKeyBinding('inoremap <expr> <C-K> pumvisible() ? "<Up>" : "<C-K>"',
                   \ 'Move up in popup menu without completion')

" Function keys
call AddKeyBinding('nmap <F2> :call DiffBufferWithDisk()<CR>',
                   \ 'Diff contents between buffer and disk file')
call AddKeyBinding('nmap <F3> :set paste!<CR>', 'Toggle paste mode')
call AddKeyBinding('nmap <F5> :call ChangeCwdToCurrentFile()<cr>',
                   \ 'Change CWD and path to current file')
call AddKeyBinding('nmap <F6> :syntax sync fromstart<cr>',
                   \ 'Always do syntax highlight from start')

" ==Key bindings defined outside==
" <C-Up>: Increase GUI font size
" <C-Down>: Decrease GUI font size
" <leader>fg: Grep all buffers
" [s] for cscope
" <C-F2>: Toggle GUI menu and toolbar
" <F4>: Toggle mouse mode
" [h] is assigned to vim-highlight

" ==Key bindings of plugins==
" {ALE}
" [a]
call AddKeyBinding('nnoremap [a :ALEPreviousWrap<CR>', '{ALE} Jump to previous lint error')
call AddKeyBinding('nnoremap ]a :ALENextWrap<CR>', '{ALE} Jump to next lint error')
call AddKeyBinding('nnoremap [A :ALEFirst<CR>', '{ALE} Jump to first lint error')
call AddKeyBinding('nnoremap ]A :ALELast<CR>', '{ALE} Jump to last lint error')
call AddKeyBinding('nnoremap <leader>al :ALEDetail<CR>', '{ALE} Show all lint details')
call AddKeyBinding('nnoremap <leader>ad :ALEGoToDefinition<CR>', '{ALE} Go to definition')
call AddKeyBinding('nnoremap <leader>ar :ALEFindReferences<CR>', '{ALE} Find references')
call AddKeyBinding('nnoremap <leader>as :ALESymbolSearch <C-R>=expand("<cword>")<CR><CR>', '{ALE} Search symbol using word under cursor')
call AddKeyBinding('nnoremap <leader>ai :ALEHover<CR>', '{ALE} Print brief information about the symbol under the cursor')

" {Coc}
" [c]
call AddKeyBinding('nnoremap [o :CocPrev<CR>', '{Coc} Previous item in Coc list')
call AddKeyBinding('nnoremap ]o :CocNext<CR>', '{Coc} Next item in Coc list')
call AddKeyBinding('nnoremap [d :call CocAction("diagnosticPrevious")<CR>',
                   \ '{Coc} Previous diagnostic information')
call AddKeyBinding('nnoremap ]d :call CocAction("diagnosticNext")<CR>',
                   \ '{Coc} Next diagnostic information')
" Do not use nnoremap
call AddKeyBinding('nmap <leader>cd <Plug>(coc-definition)', '{Coc} Goto definition')
call AddKeyBinding('nmap <leader>ct <Plug>(coc-type-definition)', '{Coc} Goto type definition')
call AddKeyBinding('nmap <leader>ci <Plug>(coc-implementation)', '{Coc} Goto implementation')
call AddKeyBinding('nmap <leader>cr <Plug>(coc-references)', '{Coc} Goto all references')
call AddKeyBinding('inoremap <silent><expr> <c-space> coc#refresh()', '{Coc} Trigger completion')

" {AsyncRun}
" [a]
" Trailing space is needed
call AddKeyBinding('nnoremap <leader>au :AsyncRun ', '{AsyncRun} Call AsyncRun to run a command')

" {CtrlP}
if g:tvim_plug_ctrlp_loaded == 1
    " [f]
    call AddKeyBinding('nnoremap <leader>fb :CtrlPBuffer<CR>', '{CtrlP} Search within buffers')
    call AddKeyBinding('nnoremap <leader>fc :CtrlP :pwd<CR>', '{CtrlP} Search in current working directory')
    call AddKeyBinding('nnoremap <leader>fm :CtrlPMixed<CR>', '{CtrlP} Search in files, buffers, and MRU files')
    call AddKeyBinding('nnoremap <leader>ft :CtrlPTag<CR>', '{CtrlP} Search for a tag within a tags file')
    call AddKeyBinding('nnoremap <leader>fu :CtrlPBufTag<CR>', '{CtrlP} Search for a tag within current buffer')
    call AddKeyBinding('nnoremap <leader>fa :CtrlPBufTagAll<CR>', '{CtrlP} Search for a tag within all listed buffers')
    " [fw]
    call AddKeyBinding('nnoremap <leader>fw :CtrlP expand("<cword>")<CR>', '{CtrlP} Search using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwb :CtrlPBuffer expand("<cword>")<CR>', '{CtrlP} Search within buffers using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwc :CtrlP :pwd expand("<cword>")<CR>', '{CtrlP} Search in current working directory using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwm :CtrlPMixed expand("<cword>")<CR>', '{CtrlP} Search in files, buffers, and MRU files using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwt :CtrlPTag expand("<cword>")<CR>', '{CtrlP} Search for a tag within a tags file using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwu :CtrlPBufTag expand("<cword>")<CR>', '{CtrlP} Search for a tag within current buffer using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwa :CtrlPBufTagAll expand("<cword>")<CR>', '{CtrlP} Search for a tag within all listed buffers using word under cursor')
endif

" {LeaderF}
if g:tvim_plug_leaderf_loaded == 1
    " [f]
    call AddKeyBinding('nnoremap <leader>fc :execute "LeaderfFile" getcwd()<CR>',
                       \ '{LeaderF} Search in current working directory')
    call AddKeyBinding('nnoremap <leader>fm :LeaderfMru<CR>', '{LeaderF} Search in MRU files')
    call AddKeyBinding('nnoremap <leader>ft :LeaderfTag<CR>', '{LeaderF} Search for a tag within a tags file')
    call AddKeyBinding('nnoremap <leader>fu :LeaderfBufTag<CR>',
                       \ '{LeaderF} Search for a tag within current buffer')
    call AddKeyBinding('nnoremap <leader>fa :LeaderfBufTagAll<CR>',
                       \ '{LeaderF} Search for a tag within all listed buffers')
    call AddKeyBinding('nnoremap <leader>ff :LeaderfFunction<CR>',
                       \ '{LeaderF} Search for a function within current buffer')
    call AddKeyBinding('nnoremap <leader>fe :LeaderfFunctionAll<CR>',
                       \ '{LeaderF} Search for a function within all listed buffers')
    " [fw]
    call AddKeyBinding('nnoremap <leader>fw :LeaderfFileCword<CR>',
                       \ '{LeaderF} Search using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwb :LeaderfBufferCword<CR>',
                       \ '{LeaderF} Search within buffers using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwc :execute "LeaderfFileCword" getcwd()<CR>',
                       \ '{LeaderF} Search in current working directory using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwm :LeaderfMruCword<CR>', '{LeaderF} Search in MRU files using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwt :LeaderfTagCword<CR>', '{LeaderF} Search for a tag within a tags file using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwu :LeaderfBufTagCword<CR>',
                       \ '{LeaderF} Search for a tag within current buffer using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwa :LeaderfBufTagAllCword<CR>',
                       \ '{LeaderF} Search for a tag within all listed buffers using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwf :LeaderfFunctionCword<CR>',
                       \ '{LeaderF} Search for a function within current buffer using word under cursor')
    call AddKeyBinding('nnoremap <leader>fwe :LeaderfFunctionAllCword<CR>',
                       \ '{LeaderF} Search for a function within all listed buffers using word under cursor')
    " [fl]
    call AddKeyBinding('nnoremap <leader>fl :LeaderfFile --recall<CR>', '{LeaderF} Recall last search')
    call AddKeyBinding('nnoremap <leader>flc :execute "LeaderfFile" getcwd()<CR>',
                       \ '{LeaderF} Recall last search in current working directory')
    call AddKeyBinding('nnoremap <leader>flm :LeaderfMru<CR>', '{LeaderF} Recall last search in MRU files')
    call AddKeyBinding('nnoremap <leader>flt :LeaderfTag<CR>', '{LeaderF} Recall last search for a tag within a tags file')
    call AddKeyBinding('nnoremap <leader>flu :LeaderfBufTag<CR>',
                       \ '{LeaderF} Recall last search for a tag within current buffer')
    call AddKeyBinding('nnoremap <leader>fla :LeaderfBufTagAll<CR>',
                       \ '{LeaderF} Recall last search for a tag within all listed buffers')
    call AddKeyBinding('nnoremap <leader>flf :LeaderfFunction<CR>',
                       \ '{LeaderF} Recall last search for a function within current buffer')
    call AddKeyBinding('nnoremap <leader>fle :LeaderfFunctionAll<CR>',
                       \ '{LeaderF} Recall last search for a function within all listed buffers')
endif

" {NERDTree}
" [t]
call AddKeyBinding('nnoremap <leader>tr :NERDTreeToggle<CR>', '{NERDTree} Toggle NERDTree')
call AddKeyBinding('nnoremap <leader>tf :NERDTreeFind<CR>', '{NERDTree} Open NERDTree and locate to current file')
" Trailing space needed
call AddKeyBinding('nnoremap <leader>tb :NERDTreeFromBookmark ', '{NERDTree} Open NERDTree from a given bookmark')

" {Tagbar}
" [t]
call AddKeyBinding('nnoremap <leader>tw :TagbarCurrentTag s<CR>', '{Tagbar} Display current tag')
call AddKeyBinding('nnoremap <leader>tt :TagbarToggle<CR>', '{Tagbar} Toggle Tagbar')
call AddKeyBinding('nnoremap <leader>ta :TagbarOpenAutoClose<CR>', '{Tagbar} Open Tagbar and auto close it')

" {EasyMotion}
" [m]
call AddKeyBinding('nmap <Leader>m <Plug>(easymotion-prefix)', '{EasyMotion} EasyMotion prefix')

" {FSwitch}
" [g]
call AddKeyBinding('nnoremap <silent> <Leader>gs :FSHere<CR>', '{FSWitch} Switch to header/implementation file')
call AddKeyBinding('nnoremap <silent> <Leader>gr :FSSplitRight<CR>', '{FSWitch} Switch to header/implementation file at a right split')
call AddKeyBinding('nnoremap <silent> <Leader>gt :FSSplitAbove<CR>', '{FSWitch} Switch to header/implementation file at a split above')

" {Vim-Preview}
" [t]
call AddKeyBinding('nnoremap <leader>tp :PreviewTag<CR>', '{Vim-Preview} Preview cusor tag circularly')
call AddKeyBinding('nnoremap <leader>tg :PreviewGoto edit<CR>', '{Vim-Preview} Open the previewed file in a normal window')
call AddKeyBinding('nnoremap <leader>ts :PreviewSignature!<CR>', '{Vim-Preview} Preview the function signature circularly at the command line')
call AddKeyBinding('nnoremap <leader>tc :PreviewQuickfix<CR>', '{Vim-Preview} Preview current file in quickfix window')

" {Ack}
" [fs]
call AddKeyBinding('nnoremap <leader>fs :Ack ', '{Ack} Ack search')
call AddKeyBinding('nnoremap <leader>fss :AckFromSearch<CR>', '{Ack} Ack search using previous search pattern')
call AddKeyBinding('nnoremap <leader>fsc :Ack --cpp ', '{Ack} Ack search C++ files')
call AddKeyBinding('nnoremap <leader>fsw :Ack <cword><CR>', '{Ack} Ack search using word under cursor')
call AddKeyBinding('nnoremap <leader>fswc :Ack --cpp <cword><CR>', '{Ack} Ack search C++ files using word under cursor')


" ==Abbreviations==
call AddCommandAbbr('tkey', 'TCmd TKeys', 'Show all key bindings in a buffer')
call AddCommandAbbr('tabbr', 'TCmd TAbbrs', 'Show all command abbreviations in a buffer')

call AddCommandAbbr('fms', 'set foldmethod=syntax', 'Use syntax folding method')
call AddCommandAbbr('ms', 'marks', 'Show all marks')
call AddCommandAbbr('cts', '%s/\s\+$//', 'Clean up trailing whitespaces')

" {CtrlP}
call AddCommandAbbr('cp', 'CtrlP', '{CtrlP} CtrlP')

" {GTags}
if g:tvim_plug_gtags_loaded == 1
    call AddCommandAbbr('gta', 'Gtags', '{GTags} Gtags')
    call AddCommandAbbr('gtr', 'Gtags -r', '{GTags} Gtags for references')
endif

" {cscope}
if has('cscope')
    call AddCommandAbbr('csf', 'cscope find', '{cscope} CScope find')
    call AddCommandAbbr('csv', 'vert scscope find', '{cscope} CScope find in a vertical split')
    call AddCommandAbbr('csp', 'scscope find', '{cscope} CScope find in a split')
endif
