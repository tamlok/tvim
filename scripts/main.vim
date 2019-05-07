let s:scripts_folder = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let s:packageInstallScriptName = 'package.vim'
let s:packageConfigScriptName = 'config.vim'
let s:packageAfterFolderName = 'after'

let s:sep = '/'
if g:tvim_os == 'win'
    let s:sep = '\'
endif

" Import utils functions
let s:utilsScript = s:scripts_folder . s:sep . 'utils.vim'
if filereadable(s:utilsScript)
    execute 'source ' . s:utilsScript
endif

" Vim plug packages
" Detect plug.vim to identify plugged folder
let s:plug_folder = ''
let s:plug_vim_file = LocateFileInVimFilesFolder(ConcatenatePath('autoload', 'plug.vim'))
if s:plug_vim_file != ''
    let s:plug_folder = ConcatenatePath(ParentDir(ParentDir(s:plug_vim_file)), 'plugged')
endif

let s:packages = globpath(s:scripts_folder, '*', 0, 1)
let s:plug_loaded = 0
if s:plug_folder != ''
    execute "silent! call plug#begin('" . fnameescape(s:plug_folder) . "')"

    " For packages without extra configs in simple_packages.vim
    let s:simplePackageScript = ConcatenatePath(s:scripts_folder, 'simple_packages.vim')
    if filereadable(s:simplePackageScript)
        execute 'source ' . s:simplePackageScript
    endif

    " For packages with extra configs
    for pack in s:packages
        if !isdirectory(pack)
            continue
        endif

        let s:packageScirpt = ConcatenatePath(pack, s:packageInstallScriptName)
        if filereadable(s:packageScirpt)
            execute 'source ' . s:packageScirpt
        endif
    endfor

    call plug#end()

    let s:plug_loaded = 1
endif

" Load configs
for pack in s:packages
    if !isdirectory(pack)
        continue
    endif

    if s:plug_loaded == 0
        let s:packageScirpt = ConcatenatePath(pack, s:packageInstallScriptName)
        if filereadable(s:packageScirpt)
            " If packages are not loaded, skip its config
            continue
        endif
    endif

    " Check /after folder
    let s:afterFolder = ConcatenatePath(pack, s:packageAfterFolderName)
    if isdirectory(s:afterFolder)
        " let &runtimepath .= ',' . s:afterFolder
        execute 'set rtp+=' . s:afterFolder
    endif

    let s:configScript = ConcatenatePath(pack, s:packageConfigScriptName)
    if filereadable(s:configScript)
        execute 'source ' . s:configScript
    endif
endfor
