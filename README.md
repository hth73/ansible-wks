## Linux Mint/Ubuntu Grundkonfiguration mit Shell-Skripte und Ansible

#### Beschreibung
Hier eine kurze Anleitung wie man das Repository nutzen kann. Nachdem man sich eine Linux Maschine installiert hat. Kann man nach dem ersten Login folgenden Befehle ausführen. Dieser konfiguriert dann die Linux Maschine über ein Shell-Skript und Ansible fertig.

* Linux Ubuntu 20.04.1 LTS mit Unity Desktop
* Linux Mint 20 mit Cinnamon Desktop

<a href="images/ubuntu.jpg" target="_blank"><img src="images/ubuntu.jpg" alt="Linux Ubuntu" title="Linux Ubuntu" width="268" height="180" /></a>   <a href="images/mint.jpg" target="_blank"><img src="images/mint.jpg" alt="Linux Mint" title="Linux Mint" width="268" height="180" /></a>

<img src="images/information.jpg" width="15"> Der erste Lauf des Playbooks kann ein bisschen dauern, da auf Ubuntu Seite ca. 280 Pakete und auf Linux Mint Seite ca. 390 Pakete upgegradet werden.

#### Der erste Befehl bereitet das Linux System vor.
```console
hth@gao:~$ wget -O - https://raw.githubusercontent.com/helmutthurnhofer/ansible-wks/main/scripts/install_base.sh | bash
```

#### Der zweite Befehl installiert/deinstalliert und konfiguriert das Linux System.
```console
hth@gao:~$ ansible-pull -U https://github.com/helmutthurnhofer/ansible-wks.git playbooks/ansible_base.yml

## Um das Ansible Playbook bei euch Anwenden zu können, muss die "username" Variable mit euren Benutzernamen überschrieben werden.
##
myuser@myhost:~$ ansible-pull -U https://github.com/helmutthurnhofer/ansible-wks.git playbooks/ansible_base.yml --extra-vars="username='$USER'" --ask-become-pass 
```

#### scripts/install_base.sh
```bash
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
sudo apt install linux-headers-$(uname -r) build-essential apt-transport-https software-properties-common dkms ssh git python3 python3-pip python-apt ansible -y
sudo pip3 install bpytop --upgrade
```
#### playbooks/vars/Linux Mint.yml
```yaml
---
username: <USERNAME>
serviceuser: <SERVICEUSERNAME>
background_destination: /usr/share/backgrounds/linuxmint/background.jpg
```
#### playbooks/vars/Ubuntu.yml
```yaml
---
username: <USERNAME>
serviceuser: <SERVICEUSERNAME>
background_destination: /usr/share/backgrounds/background.jpg
```
#### playbooks/ansible_base.yml
```yaml
---
- hosts: localhost
  connection: local
  become: true

  vars_files: vars/{{ ansible_distribution }}.yml

  tasks:
  - name: "update and upgrade apt repo"
    apt:
      upgrade: 'safe'
      update_cache: yes 
      force_apt_get: yes 
      cache_valid_time: '43200'

  - name: "install packages"
    package: 
      name:
        - chromium-browser
        - cifs-utils
        - code
        - curl
        - fdupes
        - figlet
        - htop
        - ipcalc
        - manpages-de
        - members
        - mmv
        - ncdu
        - net-tools
        - pwgen
        - tmux
        - tree
        - unzip
        - vim
      state: latest

  - name: "uninstall packages Linux Mint"
    package: 
      name:
        - firefox
        - thunderbird
        - rhythmbox
        - pix
        - drawing
        - hexchat
        - transmission-common
        - transmission-gtk
        - celluloid
      state: absent
    when: ansible_distribution == "Linux Mint"

  - name: "uninstall packages ubuntu"
    package: 
      name:
        - firefox
        - thunderbird
        - rhythmbox
        - gnome-mahjongg
        - gnome-mines
        - gnome-sudoku
        - aisleriot
        - shotwell
      state: absent
    when: ansible_distribution == "Ubuntu"

  - name: "bash-it Git Clone"
    git:
      repo: https://github.com/Bash-it/bash-it.git
      dest: /home/{{ username }}/.bash.it

  - name: "copy Wallpaper File"
    copy:
      src: ../files/background.jpg
      dest: '{{ background_destination }}'
      owner: 'root'
      group: 'root'

  - name: "create scripts directory"
    file:
      path: /home/{{ username }}/scripts
      state: directory
      mode: '0755'

  - name: "copy config_base script"
    copy:
      src: ../files/config_base
      dest: /home/{{ username }}/scripts/config_base.sh
      owner: '{{ username }}'
      group: '{{ username }}'
      mode: '0755'

  - name: 'run local config script'
    become_user: '{{ username }}'
    script: /home/{{ username }}/scripts/config_base.sh

  - name: "copy some files to the USER Home Directory"
    copy: 
      src: '{{ item.src }}' 
      dest: '{{ item.dest }}'
      owner: '{{ username }}'
      group: '{{ username }}'
    with_items:
      - { src: '../files/bashrc', dest: '/home/{{ username }}/.bashrc' }
      - { src: '../files/vimrc', dest: '/home/{{ username }}/.vimrc' }
      - { src: '../files/gitconfig', dest: '/home/{{ username }}/.gitconfig' }
      - { src: '../files/bpytop', dest: '/home/{{ username }}/.config/bpytop/bpytop.conf' }

  - name: "add ansible service user for cron job"
    user:
      name: '{{ serviceuser }}'
      system: yes

  - name: "set up sudo for ansible service user"
    copy:
      src: ../files/sudoer_{{ serviceuser }}
      dest: /etc/sudoers.d/{{ serviceuser }}
      owner: 'root'
      group: 'root'
      mode: '0440'

  - name: "add ansible-pull cron job"
    cron:
      name: ansible auto-provision
      user: '{{ serviceuser }}'
      hour: "*/3"
      job: ansible-pull -o -U https://github.com/helmutthurnhofer/ansible-wks.git playbooks/ansible_base.yml
```

#### files/config_base.sh
```bash
#!/usr/bin/env bash
set -e

# ======================================================================
#   Bash script to set desktop and nemo/nautilus settings
# ======================================================================

source /etc/os-release

if [[ "$NAME" = "Ubuntu" ]]; 
then
  gsettings set org.gnome.desktop.background picture-uri 'file:///usr/share/backgrounds/background.jpg'
  gsettings set org.gnome.desktop.background picture-options 'zoom'
  gsettings set org.gnome.desktop.screensaver picture-uri 'file:///usr/share/backgrounds/background.jpg'
  gsettings set org.gnome.desktop.screensaver picture-options 'zoom'

  gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
  gsettings set org.gnome.nautilus.preferences always-use-location-entry true
  gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'
  gsettings set org.gtk.Settings.FileChooser show-hidden true

  gsettings set org.gnome.shell.extensions.desktop-icons show-home false
  gsettings set org.gnome.shell.extensions.desktop-icons show-trash false
  gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size '28'
  gsettings set org.gnome.shell.extensions.dash-to-dock show-trash true

  gsettings set org.gnome.desktop.screensaver lock-enabled false

elif [[ "$NAME" = "Linux Mint" ]]
then
  gsettings set org.cinnamon.desktop.background picture-uri 'file:///usr/share/backgrounds/linuxmint/background.jpg'
  gsettings set org.cinnamon.desktop.background picture-options 'zoom'
  gsettings set org.mate.background picture-filename 'file:///usr/share/backgrounds/linuxmint/background.jpg'
  gsettings set org.mate.background picture-options 'zoom'

  gsettings set org.nemo.preferences show-computer-icon-toolbar true
  gsettings set org.nemo.preferences show-open-in-terminal-toolbar true
  gsettings set org.nemo.preferences show-new-folder-icon-toolbar true
  gsettings set org.nemo.preferences show-edit-icon-toolbar true
  gsettings set org.nemo.preferences show-home-icon-toolbar true
  gsettings set org.nemo.preferences show-hidden-files true
  gsettings set org.nemo.preferences default-folder-viewer 'list-view'
  gsettings set org.nemo.preferences inherit-folder-viewer true
  gsettings set org.nemo.preferences show-location-entry true

  gsettings set org.nemo.desktop computer-icon-visible false
  gsettings set org.nemo.desktop home-icon-visible false
  gsettings set org.nemo.desktop volumes-visible false
  gsettings set org.nemo.desktop show-orphaned-desktop-icons false

  gsettings set org.cinnamon.desktop.screensaver lock-enabled false

  gsettings set org.cinnamon panels-height "['1:28']" 

else
  echo "Das Betriebssystem ist weder ein Ubuntu noch ein Linux Mint, das Script wird abgebrochen"

fi
```
#### files/sudoer_sansible
```bash
sansible ALL=(ALL) NOPASSWD: ALL
```

### License and Authors
Author: Helmut Thurnhofer