@echo off
rem Require Administrator permission

setlocal EnableExtensions EnableDelayedExpansion
pushd %~dp0
mkdir tmp 2> NUL

set /A ret=0
set vimfiles_folder=%USERPROFILE%\vimfiles
set win_utils_folder=tmp\vim-win-utils.git

where gvim > NUL 2> NUL
if %ERRORLEVEL% NEQ 0 (
    echo GVim is needed >&2
    set /A ret=1
    goto :end
)
for /f "tokens=*" %%i in ('where gvim 2^> NUL') do set vim_folder=%%i
if /I "%vim_folder:~-3%" EQU "bat" (
    findstr /b /c:"set VIM_EXE_DIR=" "!vim_folder!" > tmp\vim_folder.txt 2> NUL
    set /p vim_folder=<tmp\vim_folder.txt
    set vim_folder=!vim_folder:~16!
) else (
    call :get_parent_dir "%vim_folder%" vim_folder
)
if not exist "%vim_folder%\gvim.exe" (
    echo Failed to locate GVim
    set /A ret=1
    goto :end
)
echo Found GVim in %vim_folder%

echo Check git
where git > NUL 2> NUL
if %ERRORLEVEL% NEQ 0 (
    echo Git support is needed >&2
    set /A ret=1
    goto :end
)

echo Update submodule
git submodule update --init > NUL 2> NUL
if %ERRORLEVEL% NEQ 0 (
    echo Failed to init submodule >&2
    set /A ret=1
    goto :end
)

echo Copy detorte colorscheme
set detorte_folder=%vimfiles_folder%\colors
xcopy /Y /i detorte\colors %detorte_folder% /s /e > NUL 2> NUL
if %ERRORLEVEL% NEQ 0 (
    echo Failed to copy detorte colorscheme, make sure you run this script as Administrator
    set /A ret=1
    goto :end
)

echo Check Vundle.vim
set vundle_repo=https://github.com/VundleVim/Vundle.vim.git
set vundle_folder=%vimfiles_folder%\bundle\Vundle.vim
if not exist %vundle_folder% (
    git clone %vundle_repo% %vundle_folder% > NUL 2> NUL
    if %ERRORLEVEL% NEQ 0 (
        echo Failed to clone Vundle.vim >&2
        set /A ret=1
        goto :end
    )
)

rem curl.exe is required by VundleSearch
echo Check curl
if not exist "%vim_folder%\curl.exe" (
if %ERRORLEVEL% NEQ 0 (
    call :clone_win_utils
    if !ERRORLEVEL! NEQ 0 (
        set /A ret=1
        goto :end
    )
    copy /Y %win_utils_folder%\curl.exe "%vim_folder%\" > NUL 2> NUL
    if !ERRORLEVEL! NEQ 0 (
        echo Failed to copy curl.exe, make sure you run this script as Administrator
        set /A ret=1
        goto :end
    )
)

echo Check ag
if not exist "%vim_folder%\ag.exe" (
    call :clone_win_utils
    if !ERRORLEVEL! NEQ 0 (
        set /A ret=1
        goto :end
    )
    copy /Y %win_utils_folder%\ag.exe "%vim_folder%\" > NUL 2> NUL
    if !ERRORLEVEL! NEQ 0 (
        echo Failed to copy ag.exe, make sure you run this script as Administrator
        set /A ret=1
        goto :end
    )
)

echo Check ctags
if not exist "%vim_folder%\ctags.exe" (
    call :clone_win_utils
    if !ERRORLEVEL! NEQ 0 (
        set /A ret=1
        goto :end
    )
    copy /Y %win_utils_folder%\ctags.exe "%vim_folder%\" > NUL 2> NUL
    if !ERRORLEVEL! NEQ 0 (
        echo Failed to copy ctags.exe, make sure you run this script as Administrator
        set /A ret=1
        goto :end
    )
)

echo Check GNU Global
if not exist "%vim_folder%\gtags.exe" (
    call :clone_win_utils
    if !ERRORLEVEL! NEQ 0 (
        set /A ret=1
        goto :end
    )
    copy /Y %win_utils_folder%\global\ "%vim_folder%\" > NUL 2> NUL
    if !ERRORLEVEL! NEQ 0 (
        echo Failed to copy GNU Global, make sure you run this script as Administrator
        set /A ret=1
        goto :end
    )
)

echo Copy markdown2ctags.py
copy /Y markdown2ctags.py %vimfiles_folder%\ > NUL 2> NUL
if %ERRORLEVEL% NEQ 0 (
    echo Failed to copy markdown2ctags.py, make sure you run this script as Administrator
    set /A ret=1
    goto :end
)

echo Copy vimrc
set vimrc_file=%USERPROFILE%\_vimrc
copy /Y .vimrc %vimrc_file% > NUL 2> NUL
if %ERRORLEVEL% NEQ 0 (
    echo Failed to copy .vimrc, make sure you run this script as Administrator
    set /A ret=1
    goto :end
)

rem Make a portable version in vim_portable
set vim_portable_folder=vim_portable
rmdir /s /q %vim_portable_folder% 2> NUL
set /A portable_ret=0
set init_cmd=%vim_portable_folder%\init.cmd
if "%1"=="portable" (
    echo Generate a portable version in directory vim_portable
    mkdir %vim_portable_folder% 2> NUL

    copy /Y .vimrc %vim_portable_folder%\_vimrc > NUL
    set /A portable_ret=!portable_ret!+!ERRORLEVEL!

    call :get_file_name "%vim_folder%" vim_exe_folder
    xcopy /Y /i "%vim_folder%" "%vim_portable_folder%\!vim_exe_folder!" /s /e > NUL
    set /A portable_ret=!portable_ret!+!ERRORLEVEL!

    call :get_parent_dir "%vim_folder%" vim_install_folder
    xcopy /Y /i "!vim_install_folder!\vimfiles" "%vim_portable_folder%\vimfiles" /s /e > NUL
    set /A portable_ret=!portable_ret!+!ERRORLEVEL!

    xcopy /Y /i "%vimfiles_folder%" "%vim_portable_folder%\vimfiles" /s /e > NUL
    set /A portable_ret=!portable_ret!+!ERRORLEVEL!

    (echo @echo off
     echo setlocal EnableExtensions
     echo set dest_gvim=C:\Windows\gvim.bat
     echo if exist "%%dest_gvim%%" EXIT /B 0
     echo set cur_dir=%%~dp0
     echo if /I "%%cur_dir:~-1%%" EQU "\" set cur_dir=%%cur_dir:~0,-1%%
     echo set exe_dir=%%cur_dir%%\!vim_exe_folder!
     echo echo @echo off ^> %%dest_gvim%%
     echo echo start "" "%%exe_dir%%\gvim.exe" %%%%* ^>^> %%dest_gvim%%
     echo pause
    ) >> "%init_cmd%"

    if !portable_ret! NEQ 0 (
        echo Failed to generate a portable version
    )
)

:end
rmdir /s /q tmp
popd
pause
EXIT /B %ret%

:clone_win_utils
set utils_repot=https://github.com/tamlok/vim-win-utils.git
if not exist %win_utils_folder% (
    echo Clone Vim-Win-Utils
    git clone %utils_repot% %win_utils_folder% > NUL 2> NUL
    if !ERRORLEVEL! NEQ 0 (
        echo Failed to clone Vim-Win-Utils >&2
        EXIT /B 1
    )
)
EXIT /B 0

rem Get parent directory of %1 and return the result through %2
:get_parent_dir
if "%2"=="" (
    echo get_parent_dir takes two arguments
    EXIT /B 1
)
set parent_tmp=%~dp1
if /I "%parent_tmp:~-1%" EQU "\" (
    set parent_tmp=!parent_tmp:~0,-1!
)
if /I "%parent_tmp:~-1%" EQU "/" (
    set parent_tmp=!parent_tmp:~0,-1!
)
set %2=%parent_tmp%
EXIT /B 0

rem Get file name of %1 and return the result through %2
:get_file_name
if "%2"=="" (
    echo get_file_name takes two arguments
    EXIT /B 1
)
set %2=%~nx1
EXIT /B 0

