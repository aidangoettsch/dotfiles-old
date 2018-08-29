#!/bin/sh

pacman -Syu --noconfirm

echo "Installing ZSH"
pacman -S --noconfirm zsh
usermod -s $(grep /zsh$ /etc/shells | tail -1) ${NEW_USER}

echo "Installing Git"
pacman -S --noconfirm git

echo "Installing OpenSSH"
pacman -S --noconfirm openssh

if [INSTALL_X = true]
then
    echo "Installing X"
    pacman -S --noconfirm xorg dex
fi

if [INSTALL_VBOX = true]
then
    echo "Installing VirtualBox Guest Additions"
    pacman -S --noconfirm virtualbox-guest-utils
    sudo systemctl enable vboxservice
fi

echo "Installing yay"
echo "Enter the new user password again (twice)"
echo "Also this is interactive lmao"
git clone https://aur.archlinux.org/yay.git /home/${NEW_USER}/tmp-setup/yay
chown -R ${NEW_USER} /home/${NEW_USER}
OLD_PWD=$(pwd)
cd /home/${NEW_USER}/tmp-setup/yay
sudo -su ${NEW_USER} makepkg -si
cd ${OLD_PWD}

echo "Installing i3, neofetch, ranger, unifont, pywal, feh"
pacman -S --noconfirm i3-gaps neofetch ranger bdf-unifont python-setuptools python-pywal feh

echo "Installing polybar, catimg"
echo "Enter the new user password again again (twice)"
sudo -su ${NEW_USER} yay -S --noconfirm polybar catimg

echo "Installing fonts"
pacman -S --noconfirm powerline powerline-fonts
mkdir /home/${NEW_USER}/.fonts
wget https://github.com/google/material-design-icons/raw/master/iconfont/MaterialIcons-Regular.ttf -o /home/${NEW_USER}/.fonts/MaterialIcons-Regular.ttf