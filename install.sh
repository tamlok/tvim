#!/bin/sh
# Vim's Setup Utils on Linux
# Le Tan (tamlokveer at gmail.com)
# https://github.com/tamlok/tvim

list_action() {
    echo 'Actions:'
    echo '1. Setup Vim'
    echo '2. Setup Neovim'
    echo '3. Exit'
}

check_detorte() {
    local vim_files_folder=$1
    echo "Check detorte in $vim_files_folder"
    cp -r -f ./detorte/colors "$vim_files_folder/"
}

check_plug() {
    local plug_folder="$1/autoload"
    mkdir -p "$plug_folder" 2> /dev/null
    echo "Check Plug in $plug_folder"
    cp -f ./utils/plug.vim "$plug_folder/"
}

check_markdowntoctags() {
    local vim_files_folder=$1
    echo "Check markdown2ctags.py in $vim_files_folder"
    cp -f ./utils/markdown2ctags.py "$vim_files_folder/"
}

check_coc_settings() {
    local vim_files_folder=$1
    echo "Check coc-settings.json in $vim_files_folder"
    cp -f ./utils/coc-settings.json "$vim_files_folder/"
}

check_vimrc() {
    local home_folder=$HOME
    echo "Check .vimrc in $home_folder"
    cp -f ./vimrc "$home_folder/.vimrc"
}

check_scripts() {
    local vim_files_folder=$1
    echo "Check scripts in $vim_files_folder"
    rm -rf "$vim_files_folder/scripts" 2> /dev/null
    cp -r -f ./scripts "$vim_files_folder/"
}

setup_vim() {
    echo '==Setup Vim=='
    local vim_files_folder="$HOME/.vim"

    mkdir "$vim_files_folder" 2> /dev/null

    check_detorte $vim_files_folder
    check_plug $vim_files_folder
    check_markdowntoctags $vim_files_folder
    check_coc_settings $vim_files_folder
    check_vimrc
    check_scripts $vim_files_folder
}

setup_neovim() {
    echo '==Setup Neovim=='
    local vim_files_folder="$HOME/.config/nvim"
    echo 'Not implemented yet!'
}

echo 'Welcome! Let me help you setup Vim on Linux'

list_action

read -p 'Action: ' action

case $action in
    '1')
        setup_vim
        ;;

    '2')
        setup_neovim
        ;;

    *)
        echo 'Exit'
        ;;
esac

exit $?
