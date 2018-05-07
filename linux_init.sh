#!/bin/sh
echo 'Coping .vimrc'
cp -f .vimrc ~/.vimrc

echo 'Coping detorte colorscheme'
mkdir -p ~/.vim/colors
cp -fr detorte/colors ~/.vim/colors

echo 'Coping plug.vim'
mkdir -p ~/.vim/autoload
cp -f plug.vim ~/.vim/autoload/plug.vim

# Add support for markdown in Tagbar plugin
echo 'Coping markdown2ctags.py'
cp -f markdown2ctags.py ~/.vim/
