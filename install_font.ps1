# Install fonts from a given folder on Windows

function Install-Font
{
    param([string]$fontFolder)

    if (!(Test-Path $fontFolder)) {
        Write-Error "Fail to locate source font folder $fontFolder"
        return
    }

    $objShell = New-Object -ComObject Shell.Application
    $objFolder = $objShell.Namespace(0x14)

    $Fonts = Get-ChildItem -Path $fontFolder -Recurse -Include '*.ttf','*.ttc','*.otf'
    $Fonts | ForEach-Object {
        $destFile = "C:\Windows\Fonts\$($_.Name)"
        if ((Test-Path $destFile) -eq $false) {
            Write-Host "Installing font $($_.Name)"
            $objFolder.CopyHere($_.FullName, 4 + 16)
        }
    }
}
