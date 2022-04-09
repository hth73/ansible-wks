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
sudo apt install linux-headers-$(uname -r) build-essential dkms ca-certificates apt-transport-https software-properties-common ssh git -y

# Install ansible packages
echo '# === Install ansible packages === #'
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install powerline python3 python3-pip ansible -y

# Uninstall default packages
echo '# === Uninstall default packages === #'
sudo apt remove --purge firefox firefox-locale-en aisleriot gnome-mahjongg gnome-mines quadrapassel gnome-sudoku gimp gimp-help-common gimp-help-en cheese pitivi gnome-sound-recorder gnome-tour zorin-gnome-tour-autostart zorin-os-tour-video -y

# Install common tools
echo '# === Install common tools packages === #'
sudo apt install dirmngr gnupg direnv zsh ssh vim git tree curl lsof net-tools pwgen ncdu tmux unzip ipcalc figlet manpages-de deepin-screenshot chromium-browser -y

# Install bpytop
echo '# === Install bpytop packages === #'
sudo pip3 install bpytop --upgrade

# Install Sublime Text
echo '# === Install sublime-text packages === #'
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository --yes --update "deb https://download.sublimetext.com/ apt/stable/"
sudo apt install sublime-text -y

# Install nextcloud client
echo '# === Install nextcloud client packages === #'
sudo add-apt-repository --yes --update ppa:nextcloud-devs/client
sudo apt install nextcloud-client -y

# Codium installieren
echo '# === Install codium packages === #'
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | gpg --dearmor | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg
echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' | sudo tee /etc/apt/sources.list.d/vscodium.list
sudo apt update && sudo apt install codium -y

# Install Ansible Base Packages
# echo '# === Install Ansible Base Packages === #'
# ansible-pull -U https://github.com/hth73/ansible-wks.git playbooks/ansible_base.yml
