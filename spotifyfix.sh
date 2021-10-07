#!/bin/bash

# self explanatory, check package function
function package_exists(){
    pacman -Qi "$1" &> /dev/null
    return $?
}

# checks if git package exists on system using pacman
if package_exists git; then
    printf 'git package found, continuing\n'
else
    sudo pacman -S git
fi

# checks if spotify is already installed, if not, replaces offending line with  
# something that doesn't cause an error
# and installs the spotify pkgbuild
if package_exists spotify; then
    printf 'spotify package is already installed. you should be able to update using an AUR helper, such as yay'
else
    git clone https://aur.archlinux.org/spotify.git 
    search='chmod -R go-w "${pkgdir}"'
    replace='find "${pkgdir}" ! -type l -exec chmod go-w {} +'
    sed -i "s/$search/$replace/" ./spotify/PKGBUILD
    cd ./spotify/
    makepkg -si
fi
