#!/bin/sh
echo 'Coping .vimrc'
cp .vimrc ~/

git submodule init
git submodule update --recursive
echo 'Coping detorte colorscheme'
cp -r detorte/colors ~/.vim/

# Git clone Vundle.vim for plugins management
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# Add support for markdown in Tagbar plugin
echo 'Coping markdown2ctags.py'
cp markdown2ctags.py ~/.vim/

echo 'Initialization Done. Please execute :VundleInstall in Vim for plugins.'
