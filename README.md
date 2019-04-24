# [tvim](https://github.com/tamlok/tvim)
Configuration for Vim/Neovim from work and study.

## Download
```
git clone https://github.com/tamlok/tvim.git tvim.git
cd tvim.git
git submodule update --init
```

## Windows
There is a setup helper `win_setup.ps1` PowerShell script to help setup Vim for you.

Just run `win_setup.ps1` and you will be prompted for one of the following choices:

1. Install Neovim  
    - Download latest release of Neovim to a given location (such as `D:\software`);
    - Add `qvim.bat` to launch `nvim-qt.exe` at convenience;
    - Add Neovim to `PATH` environment variable;
    - Add `Edit with Neovim` to context menu;
2. Setup Neovim  
    - Copy `init.vim` and `ginit.vim` to user folder;
    - Copy `detorte` colorscheme;
    - Copy `vim-win-utils.git` tools to Neovim, including `ctags.exe`, `ag.exe`, `Python3`, and so on;
3. Setup Vim  
    - Copy `_vimrc` and `.vimrc` to user folder;
    - Copy `detorte` colorscheme;
    - Copy `vim-win-utils.git` tools to Vim, including `ctags.exe`, `ag.exe`, `Python3`, and so on;
4. Pack Neovim  
    - Pack currently installed Neovim to a portable ZIP file;
    - The ZIP file will contain all installed plugins, colorschemes, and utils;
    - There is one `init.bat` script file shipped with the ZIP file for initialization on target PC;
5. Pack Vim  
    - Pack currently installed Vim to a portable ZIP file;
    - The ZIP file will contain all installed plugins, colorschemes, and utils;

