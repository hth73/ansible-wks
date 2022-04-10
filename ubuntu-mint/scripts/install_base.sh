#!/usr/bin/env bash
set -e

# ======================================================================
#   Bash script to Install Base Packages on a Linux Mint/Ubuntu System
# ======================================================================

# Add Microsoft gpg Key to Keyring
echo '# === Add Microsoft gpg Key to Keyring === #'
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'

# System Update
echo '# === System Update === #'
sudo apt update

# Install Base Packages
echo '# === Install base packages === #'
sudo apt install linux-headers-$(uname -r) build-essential apt-transport-https software-properties-common powerline dkms ssh git python3 python3-pip ansible -y
sudo pip3 install bpytop --upgrade

# Install Ansible Base Packages
echo '# === Install Ansible Base Packages === #'
ansible-pull -U https://github.com/hth73/ansible-wks.git playbooks/ansible_base.yml
