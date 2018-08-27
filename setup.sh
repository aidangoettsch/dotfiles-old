#!/bin/sh

# Use colors, but only if connected to a terminal, and that terminal
# supports them.
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

# Only enable exit-on-error after the non-critical colorization stuff,
# which may fail on systems lacking tput or terminfo
set -e

echo "Creating a user"
read -p "Username: " NEW_USER
export NEW_USER=NEW_USER
useradd -mU ${NEW_USER}
passwd ${NEW_USER}
groupadd sudo
echo "%sudo ALL=(ALL) ALL" > /etc/sudoers.d/sudo_group
usermod -aG sudo ${NEW_USER}
mkdir /home/${NEW_USER}/tmp-setup

echo "Setting hostname"
read -p "Hostname: " NEW_HOSTNAME
export NEW_HOSTNAME=NEW_HOSTNAME
echo ${NEW_HOSTNAME} > /etc/hostname
echo "127.0.0.1	localhost" >> /etc/hosts
echo "::1	localhost" >> /etc/hosts
echo 127.0.1.1	${NEW_HOSTNAME}.localdomain ${NEW_HOSTNAME} >> /etc/hosts

echo "What platform is this?"
select platform in "Physical" "VirtualBox"; do
    case $REPLY in
        1 ) . setup/platform/setup_physical.sh;;
        2 ) . setup/platform/setup_virtualbox.sh;;
    esac
    break
done

echo "What OS is this?"
select os in "Arch Linux"; do
    case $REPLY in
        1 ) . setup/os/setup_arch.sh
    esac
    break
done

printf "${BLUE}Cloning Oh My Zsh...${NORMAL}\n"
# Prevent the cloned repository from having insecure permissions. Failing to do
# so causes compinit() calls to fail with "command not found: compdef" errors
# for users with insecure umasks (e.g., "002", allowing group writability).
umask g-w,o-w
ZSH=/home/${NEW_USER}/.oh-my-zsh
env git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git "$ZSH" || {
    printf "Error: git clone of oh-my-zsh repo failed\n"
    exit 1
}

. setup/copy.sh

sudo -u ${NEW_USER} wal -i /home/${NEW_USER}/Wallpaper/the_dark_mountain-wallpaper-5120x2880.jpg

rm -rf /home/${NEW_USER}/tmp-setup

