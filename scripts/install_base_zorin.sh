#!/usr/bin/env bash
set -ex

# ======================================================================
#   Bash script to Install Base Packages on a Linux Zorin OS System
# ======================================================================

# System Update
echo '# === System Update === #'
sudo apt update

# Install Base Packages
echo '# === Install base packages === #'
sudo apt install linux-headers-$(uname -r) build-essential dkms ca-certificates apt-transport-https software-properties-common -y

# add packages repositories
echo '# === add packages repositories === #'
# ansible
sudo add-apt-repository --yes --update ppa:ansible/ansible
# nextcloud-client
sudo add-apt-repository --yes --update ppa:nextcloud-devs/client
#sublime-text
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository --yes --update "deb https://download.sublimetext.com/ apt/stable/"
# codium
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list

# Uninstall default zorin packages
echo '# === Uninstall default packages === #'
sudo apt remove --purge firefox firefox-locale-en aisleriot gnome-mahjongg gnome-mines quadrapassel gnome-sudoku gimp gimp-help-common gimp-help-en cheese pitivi gnome-sound-recorder gnome-tour zorin-gnome-tour-autostart zorin-os-tour-video -y

# Install ansible
echo '# === Install ansible packages === #'
sudo apt update
sudo apt install powerline python3 python3-pip ansible -y

# Install useful tools
echo '# === Install common tools packages === #'
sudo apt install ssh git dirmngr gnupg direnv zsh ssh vim git tree curl lsof net-tools pwgen ncdu tmux unzip ipcalc figlet manpages-de deepin-screenshot sublime-text nextcloud-client codium chromium-browser -y

# Install bpytop
echo '# === Install bpytop packages === #'
sudo pip3 install bpytop --upgrade

# upgrade all packages
echo '# === upgrade all packages === #'
sudo apt full-upgrade -y && sudo autoremove -y

# Install Ansible Base Packages
# echo '# === Install Ansible Base Packages === #'
# ansible-pull -U https://github.com/hth73/ansible-wks.git playbooks/ansible_base.yml
