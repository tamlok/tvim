# Vim's Setup Utils on Windows
# Le Tan (tamlokveer at gmail.com)
# https://github.com/tamlok/tvim

param([switch]$Force=$false, [string]$WorkingDirectory='')

function Main
{
    Write-Host 'Welcome! Let me help you setup Vim on Windows'

    if ($WorkingDirectory -ne '') {
        Set-Location -Path "$WorkingDirectory"
    }

    Write-Host "Working directory is" (Get-Location).Path

    Check-Admin

    Print-Usage

    . '.\install_font.ps1'

    $action = Get-Action

    switch ($action) {
        1 { Install-Neovim }
        2 { Setup-Neovim }
        3 { Setup-Vim }
        4 { Pack-Neovim }
        5 { Pack-Vim }
        6 { Install-Fonts }
        9 { Write-Host 'Bye!'; exit 0 }
        default {Write-Error 'Invalid action'; exit -1}
    }
}

function Print-Usage
{
    Write-Host "Usage:"
    Write-Host "-Force: force to update configurations"
    Write-Host ""
}

function Get-Action
{
    Write-Host ''
    Write-Host 'Actions:'
    Write-Host '1. Install Neovim'
    Write-Host '2. Setup Neovim'
    Write-Host '3. Setup Vim'
    Write-Host '4. Pack Neovim'
    Write-Host '5. Pack Vim'
    Write-Host '6. Install fonts'
    Write-Host '9. Exit'
    Write-Host ''

    $action = Read-Host -Prompt 'Please choose the right action to perform'

    return $action
}

function Install-Neovim
{
    Write-Host ''
    Write-Host '==Install Neovim=='
    $targetLocation = Read-Host -Prompt 'Enter the location you want to put Neovim'
    if ($targetLocation -eq "" -or !(Test-Path -Path $targetLocation)) {
        Write-Error "Target location does not exist $targetLocation"
        exit -1
    }


    $release = Get-Neovim-Latest-Release
    Write-Host 'Downloading latest Neovim' $release.Tag '...'

    $targetZipFile = $env:TEMP + '\tvim_' + $release.File
    Invoke-WebRequest -Uri $release.Url -OutFile $targetZipFile

    $targetFolder = $targetLocation + '\Neovim'
    if (Test-Path -Path $targetFolder) {
        Write-Host "Target folder $targetFolder exists and will be removed"

        Remove-Directory-Recursively $targetFolder
    }

    if (!(Unzip-Neovim $targetZipFile $targetLocation)) {
        Remove-Item $targetZipFile -Force
        Write-Error "Fail to unzip $targetZipFile to $targetFolder"
        exit -1
    }

    Remove-Item $targetZipFile -Force

    Add-Nvim-Qt-Bat $targetFolder

    Add-Neovim-To-Path $targetFolder

    Add-Neovim-To-Context-Menu $targetFolder
}

function Get-Neovim-Latest-Release
{
    $file = 'nvim-win64.zip'
    $regularExp = '"browser_download_url":"(https://github.com/neovim/neovim/releases/download/(v\d\.\d\.\d)/' + $file + ')"'
    $url = 'https://api.github.com/repos/neovim/neovim/releases/latest'
    $content = Invoke-WebRequest -Uri $url
    $match = $content -match $regularExp
    if (!$match) {
        Write-Error "Fail to fetch information of Neovim releases"
        exit -1
    }

    $release = New-Object PSObject | Select-Object Url, Tag, File
    $release.Url = $Matches[1]
    $release.Tag = $Matches[2]
    $release.File = $file

    return $release
}

function Unzip-Neovim
{
    Param([string]$zipFile, [string]$outputFolder)
    $ret = Expand-Archive $zipFile -DestinationPath $outputFolder
    return $true
}

function Add-Nvim-Qt-Bat
{
    Param([string]$nvimFolder)

    $cmd = '@start nvim-qt.exe %*'
    $destinationFile = "$nvimFolder\bin\qvim.bat"

    Out-File -Encoding ascii -LiteralPath $destinationFile -InputObject $cmd
}

function Add-Neovim-To-Path
{
    Param([string]$nvimFolder)

    $oldPath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path

    $binFolder = "$nvimFolder\bin"
    if (!$oldPath.contains($binFolder)) {
        if ($oldPath.EndsWith(';')) {
            $newPath = "$oldPath$binFolder"
        } else {
            $newPath = "$oldPath;$binFolder"
        }

        Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value "$newPath"
    }
}

function Add-Neovim-To-Context-Menu
{
    Param([string]$nvimFolder)

    $neovimKeyStr = 'Registry::HKEY_CLASSES_ROOT\*\shell\Neovim'
    if ((Get-Item -LiteralPath "$neovimKeyStr") -eq $null) {
        Write-Host "Create registry key $neovimKeyStr"
        New-Item "$neovimKeyStr" > $null
    }

    $displayName = 'Edit with Neovim'
    Set-ItemProperty -LiteralPath "$neovimKeyStr" -Name '(Default)' -Value "$displayName"
    $icon = "`"$nvimFolder\bin\nvim-qt.exe`""
    Set-ItemProperty -LiteralPath "$neovimKeyStr" -Name 'Icon' -Value "$icon"

    $commandKeyStr = "$neovimKeyStr\command"
    if ((Get-Item -LiteralPath "$commandKeyStr") -eq $null) {
        Write-Host "Create registry key $commandKeyStr"
        New-Item "$commandKeyStr" > $null
    }

    $command = "`"$nvimFolder\bin\nvim-qt.exe`" `"%1`""
    Set-ItemProperty -LiteralPath "$commandKeyStr" -Name '(Default)' -Value "$command"
}

function Remove-Directory-Recursively
{
    Param([string]$directory)

    if (!(Test-Path -Path "$directory")) {
        return
    }

    Get-ChildItem -Path "$directory" -Recurse | Remove-Item -Recurse
    Remove-Item "$directory" -Recurse
}

function Run-As-Admin
{
    Param([string]$command)

    $myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
    $myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

    if ($myWindowsPrincipal.IsInRole($adminRole)) {
        Invoke-Expression $command
    } else {
        $cmd = "& '$command'"
        Start-Process "$PSHome\powershell.exe" -Wait -Verb RunAs -WorkingDirectory (Get-Location).Path -ArgumentList $cmd
    }
}

function Setup-Neovim
{
    Write-Host ''
    Write-Host '==Setup Neovim=='

    # Check-Git

    $vimBinFolder = Get-Neovim-Folder
    $vimFilesFolder = $env:USERPROFILE + '\AppData\Local\nvim'
    $vimUtilsFolder = (Get-Item "$vimBinFolder").Parent.FullName + '\share\nvim\runtime\tvim_utils'

    Do-Setup-Neovim $vimBinFolder $vimFilesFolder $vimUtilsFolder
}

function Setup-Vim
{
    Write-Host ''
    Write-Host '==Setup Vim=='

    # Check-Git

    $vimBinFolder = Get-GVim-Folder
    $vimFilesFolder = $env:USERPROFILE + '\vimfiles'
    $vimUtilsFolder = "$vimBinFolder\tvim_utils"

    Do-Setup-Vim $vimBinFolder $vimFilesFolder $vimUtilsFolder
}

function Check-Git
{
    if ((Get-Command 'git' -ErrorAction SilentlyContinue) -eq $null) {
        Write-Error 'Fail to locate Git in your PATH'
        exit -1
    }

    Write-Host 'Git is found.'
}

function Get-GVim-Folder
{
    $gvim = Get-Command 'gvim' -ErrorAction SilentlyContinue
    if ($gvim -eq $null) {
        Write-Host "Fail to locate GVim"
        exit -1
    }

    if ($gvim.Path.EndsWith('.bat')) {
        $reg = 'set VIM_EXE_DIR=(.+)'
        $bat = Get-Content $gvim.Path
        $firstMatchLine = ($bat -match $reg)[0]
        $match = $firstMatchLine -match $reg
        if (!$match) {
            Write-Error 'Fail to locate GVim in your PATH'
            exit -1
        }

        $gvimFolder = $Matches[1]
    } else {
        $gvimFolder = (Get-Item $gvim.Path).Directory.FullName
    }

    Write-Host "GVim is found in $gvimFolder"
    return $gvimFolder
}

function Get-Neovim-Folder
{
    $nvim = Get-Command 'nvim' -ErrorAction SilentlyContinue
    if ($nvim -eq $null) {
        Write-Host "Fail to locate Neovim"
        exit -1
    }

    $nvimFolder = (Get-Item $nvim.Path).Directory.FullName

    Write-Host "Neovim is found in $nvimFolder"
    return $nvimFolder
}

function Do-Setup-Vim
{
    param([string]$binFolder, [string]$filesFolder, [string]$utilsFolder)

    Check-TVim-Utils $utilsFolder

    Check-Detorte $filesFolder

    Check-Plug $filesFolder

    Check-Markdown2Ctags $filesFolder

    Check-Vimrc
}

function Do-Setup-Neovim
{
    param([string]$binFolder, [string]$filesFolder, [string]$utilsFolder)

    Check-TVim-Utils $utilsFolder

    Check-Detorte $filesFolder

    Check-Plug $filesFolder

    Check-Markdown2Ctags $filesFolder

    Check-Init_Vim $filesFolder
}

function Check-TVim-Utils
{
    param([string]$utilsFolder)

    Write-Host "Check tvim_utils in $utilsFolder"

    if (Test-Path -Path "$utilsFolder") {
        if (!$Force) {
            return
        } else {
            Remove-Directory-Recursively $utilsFolder
        }
    }

    $tempFolder = '.\tmp'
    New-Item -ItemType 'directory' -Path "$tempFolder" -Force > $null

    $tempUtilsFolder = Get-TVim-Utils "$tempFolder"
    robocopy "$tempUtilsFolder" "$utilsFolder" /E /MT /XD .git > $null

    Remove-Directory-Recursively $tempFolder
}

function Get-TVim-Utils
{
    param([string]$tempFolder)

    $url = "https://github.com/tamlok/vim-win-utils/archive/master.zip"
    Write-Host "Downloading $url"

    $targetName = 'vim-win-utils-master'
    $targetZipFile = "$tempFolder\$targetName.zip"
    Invoke-WebRequest -Uri $url -OutFile $targetZipFile

    Expand-Archive $targetZipFile -DestinationPath $tempFolder

    Remove-Item $targetZipFile -Force

    $outputFolder = (Get-Item "$tempFolder\$targetName").FullName
    Write-Host "Utils downloaded in $outputFolder"

    return $outputFolder
}

function Check-Detorte
{
    param([string]$filesFolder)

    $colorFolder = "$filesFolder\colors"
    Write-Host "Check detorte in $colorFolder"
    xcopy /Y /i /e .\detorte\colors "$colorFolder\" > $null 2> $null
}

function Check-Plug
{
    param([string]$filesFolder)

    $plugFolder = "$filesFolder\autoload"
    Write-Host "Check Plug in $plugFolder"
    xcopy /Y /i .\plug.vim "$plugFolder\" > $null 2> $null
}

function Check-Markdown2Ctags
{
    param([string]$filesFolder)

    Write-Host "Check markdown2ctags.py in $filesFolder"
    xcopy /Y /i .\markdown2ctags.py "$filesFolder\" > $null 2> $null
}

function Check-Vimrc
{
    $userFolder = $env:USERPROFILE
    Write-Host "Check _vimrc and .vimrc in $userFolder"
    xcopy /Y /i .\.vimrc "$userFolder\" > $null 2> $null
    copy .\.vimrc "$userFolder\_vimrc" > $null 2> $null
}

function Check-Init_Vim
{
    param([string]$filesFolder)

    Write-Host "Check init.vim and ginit.vim in $filesFolder"
    copy .\.vimrc "$filesFolder\init.vim" > $null 2> $null
    copy .\ginit.vim "$filesFolder\ginit.vim" > $null 2> $null
}

function Pack-Neovim
{
    Write-Host ''
    Write-Host '==Pack-Neovim=='

    $vimBinFolder = Get-Neovim-Folder
    $vimFilesFolder = $env:USERPROFILE + '\AppData\Local\nvim'

    Do-Pack-Neovim $vimBinFolder $vimFilesFolder
}

function Pack-Vim
{
    Write-Host ''
    Write-Host '==Pack-Vim=='

    $vimBinFolder = Get-GVim-Folder
    $vimFilesFolder = $env:USERPROFILE + '\vimfiles'

    Do-Pack-Vim $vimBinFolder $vimFilesFolder
}

function Do-Pack-Vim
{
    param([string]$binFolder, [string]$filesFolder)

    $portableZipFile = 'vim_portable.zip'
    Write-Host "Packing Vim into $portableZipFile"

    $portableFolder = '.\vim_portable'
    Remove-Directory-Recursively $portableFolder

    if (Test-Path -Path $portableZipFile) {
        Remove-Item $portableZipFile
    }

    New-Item -ItemType 'directory' -Path "$portableFolder" > $null

    $userFolder = $env:USERPROFILE
    copy "$userFolder\_vimrc" "$portableFolder\_vimrc" > $null 2> $null

    copy .\README.md "$portableFolder\README.md" > $null 2> $null

    $binFolderName = (Get-Item "$binFolder").Name
    xcopy /Y /i /e "$binFolder" "$portableFolder\$binFolderName\" > $null

    $binParentFolder = (Get-Item "$binFolder").Parent.FullName
    xcopy /Y /i /e "$binParentFolder\vimfiles" "$portableFolder\vimfiles\" > $null
    xcopy /Y /i /e "$filesFolder" "$portableFolder\vimfiles\" > $null

    Write-Vim-Init_BAT $portableFolder

    Compress-Archive -CompressionLevel Fastest -Path $portableFolder -DestinationPath ".\$portableZipFile"
    Remove-Directory-Recursively $portableFolder

    Write-Host "Vim is packed as" (Get-Item $portableZipFile).FullName
}

function Do-Pack-Neovim
{
    param([string]$binFolder, [string]$filesFolder)

    $portableZipFile = 'nvim_portable.zip'
    Write-Host "Packing Neovim into $portableZipFile"

    $portableFolder = '.\nvim_portable'
    Remove-Directory-Recursively $portableFolder

    if (Test-Path -Path $portableZipFile) {
        Remove-Item $portableZipFile
    }

    New-Item -ItemType 'directory' -Path "$portableFolder" > $null

    copy .\README.md "$portableFolder\README.md" > $null 2> $null

    $binFolderName = (Get-Item "$binFolder").Name
    xcopy /Y /i /e "$binFolder" "$portableFolder\$binFolderName\" > $null

    $binParentFolder = (Get-Item "$binFolder").Parent.FullName
    xcopy /Y /i /e "$binParentFolder\share" "$portableFolder\share\" > $null

    $destFilesFolder = "$portableFolder\share\nvim\vimfiles\"
    xcopy /Y /i /e "$filesFolder" "$destFilesFolder"  > $null

    Write-Neovim-Init_BAT $portableFolder

    Compress-Archive -CompressionLevel Fastest -Path $portableFolder -DestinationPath ".\$portableZipFile"
    Remove-Directory-Recursively $portableFolder

    Write-Host "Neovim is packed as" (Get-Item $portableZipFile).FullName
}

function Check-Admin
{
    $myWindowsID = [System.Security.Principal.WindowsIdentity]::GetCurrent();
    $myWindowsPrincipal = New-Object System.Security.Principal.WindowsPrincipal($myWindowsID);
    $adminRole = [System.Security.Principal.WindowsBuiltInRole]::Administrator;

    if ($myWindowsPrincipal.IsInRole($adminRole)) {
        return
    } else {
        Write-Host "Continue as Administrator"

        $arguments = "-NoExit -ExecutionPolicy Bypass -File `"$PSCommandPath`""
        if ($Force) {
            $arguments += ' -Force'
        }
        $arguments += " -WorkingDirectory `"" + (Get-Location).Path + '"'

        Start-Process powershell.exe -Verb RunAs -ArgumentList $arguments
        exit 0
    }
}

function Write-Neovim-Init_BAT
{
    param([string]$destFolder)

    $batFile = "$destFolder\init.bat"

    $content = "@echo off`r`n"
    $content += "echo Vim configurations by Le Tan (https://github.com/tamlok/tvim)`r`n"
    $content += "set cur_dir=%~dp0`r`n"
    $content += 'if /I "%cur_dir:~-1%" EQU "\" set cur_dir=%cur_dir:~0,-1%' + "`r`n"
    $content += 'set vimfiles=%cur_dir%\share\nvim\vimfiles' + "`r`n"
    $content += 'set userVimFiles=%USERPROFILE%\AppData\Local\nvim' + "`r`n"
    $content += '@echo on' + "`r`n"
    $content += 'mkdir "%userVimFiles%"' + "`r`n"
    $content += 'copy "%vimfiles%\init.vim" "%userVimFiles%\init.vim"' + "`r`n"
    $content += 'copy "%vimfiles%\ginit.vim" "%userVimFiles%\ginit.vim"' + "`r`n"
    $content += '@echo off' + "`r`n"
    $content += "pause"

    Out-File -Encoding ascii -LiteralPath $batFile -InputObject $content
}

function Write-Vim-Init_BAT
{
    param([string]$destFolder)

    $batFile = "$destFolder\init.bat"

    $content = "@echo off`r`n"
    $content += "echo Vim configurations by Le Tan (https://github.com/tamlok/tvim)`r`n"
    $content += "set cur_dir=%~dp0`r`n"
    $content += 'if /I "%cur_dir:~-1%" EQU "\" set cur_dir=%cur_dir:~0,-1%' + "`r`n"
    $content += 'set vimrc=%cur_dir%\_vimrc' + "`r`n"
    $content += 'set userFolder=%USERPROFILE%' + "`r`n"
    $content += '@echo on' + "`r`n"
    $content += 'copy "%vimrc%" "%userFolder%\_vimrc"' + "`r`n"
    $content += 'copy "%vimrc%" "%userFolder%\.vimrc"' + "`r`n"
    $content += '@echo off' + "`r`n"
    $content += "pause"

    Out-File -Encoding ascii -LiteralPath $batFile -InputObject $content
}

function Install-Fonts
{
    $fontFolder = (Get-Item '.\fonts').FullName
    Install-Font "$fontFolder"
}

Main
