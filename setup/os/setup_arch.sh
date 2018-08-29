#!/bin/sh

pacman -Syu --noconfirm
pacman -S --noconfirm base-devel

echo "Installing ZSH"
pacman -S --noconfirm zsh
usermod -s $(grep /zsh$ /etc/shells | tail -1) ${NEW_USER}

echo "Installing Git"
pacman -S --noconfirm git

echo "Installing OpenSSH"
pacman -S --noconfirm openssh

if [ ${INSTALL_X} = true ]
then
    echo "Installing X"
    pacman -S --noconfirm xorg xorg-xinit dex
fi

if [ ${INSTALL_VBOX} = true ]
then
    echo "Installing VirtualBox Guest Additions"
    pacman -S --noconfirm virtualbox-guest-utils
    sudo systemctl enable vboxservice
fi

echo "Installing yay"
echo "Enter the new user password again (twice)"
echo "Also this is interactive lmao"
git clone https://aur.archlinux.org/yay.git /home/${NEW_USER}/tmp-setup/yay
chown -R ${NEW_USER}:${NEW_USER} /home/${NEW_USER}/tmp-setup
OLD_PWD=$(pwd)
cd /home/${NEW_USER}/tmp-setup/yay
sudo -su ${NEW_USER} makepkg -si
cd ${OLD_PWD}

echo "Installing i3"
pacman -S --noconfirm libev libev-dev startup-notification xcb-util-cursor xcb-util-xrm libxkbcommon libxkbcommon-x11 yajl pango cairo
# clone the repository
git clone https://www.github.com/aidangoettsch/i3 /home/${NEW_USER}/tmp-setup/i3-gaps
chown -R ${NEW_USER}:${NEW_USER} /home/${NEW_USER}/tmp-setup
OLD_PWD=$(pwd)
cd /home/${NEW_USER}/tmp-setup/i3-gaps

# compile & install
autoreconf --force --install
rm -rf build/
mkdir -p build && cd build/

# Disabling sanitizers is important for release versions!
# The prefix and sysconfdir are, obviously, dependent on the distribution.
../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
make
make install

echo "Installing neofetch, ranger, unifont, pywal, feh"
pacman -S --noconfirm neofetch ranger bdf-unifont python-setuptools python-pywal feh

echo "Installing polybar, catimg"
echo "Enter the new user password again again (twice)"
sudo -su ${NEW_USER} yay -S --noconfirm polybar catimg

echo "Installing fonts"
pacman -S --noconfirm powerline powerline-fonts wget
mkdir /home/${NEW_USER}/.fonts
wget https://github.com/google/material-design-icons/raw/master/iconfont/MaterialIcons-Regular.ttf -O /home/${NEW_USER}/.fonts/MaterialIcons-Regular.ttf