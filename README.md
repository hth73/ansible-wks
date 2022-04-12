## Linux Grundkonfiguration mit Shell-Skripte und Ansible
Hier eine kurze Anleitung wie man das Repository nutzen kann.

<img src="https://img.shields.io/badge/-Linux%20Clients-557C94?logo=linux&logoColor=black&style=flat" /> <img src="https://img.shields.io/badge/-Bash-4EAA25?logo=gnu-bash&logoColor=white&style=flat" /> <img src="https://img.shields.io/badge/-Ansible-EE0000?logo=ansible&logoColor=white&style=flat" />

---
## Beschreibung
Nachdem man sich eine Linux Maschine installiert hat. Nach dem ersten Login wird folgender Befehl ausführen. Diese konfiguriert dann die passende Linux Maschine über ein Shell-Skript und Ansible fertig.

* [Linux Ubuntu 20.04 LTS mit Unity Desktop](ubuntu-mint/README.md)
* [Linux Mint 20 mit Cinnamon Desktop](ubuntu-mint/README.md)
* [Linux Zorin OS 16 mit Gnome Desktop](zorin/README.md)

<img src="ubuntu-mint/images/information.jpg" width="15"> Der erste Lauf des Playbooks kann ein bisschen dauern.

### Linux System vorbereiten und Playbook ausführen
```bash
# Ubuntu und Linux Mint
hth@gao:~$ wget -O - https://raw.githubusercontent.com/hth73/ansible-wks/main/ubuntu-mint/scripts/install_base.sh | bash

# Zorin OS
hth@gao:~$ wget -O - https://raw.githubusercontent.com/hth73/ansible-wks/main/zorin/scripts/install_base.sh | bash
```

### Wenn man das Playbook ausprobieren möchte, dienen folgende Befehle
```bash
# Um das Ansible Playbook bei euch anwenden zu können, muss die "username" Variable mit euren Benutzernamen überschrieben werden.
myuser@myhost:~$ wget -O - https://raw.githubusercontent.com/hth73/ansible-wks/main/ubuntu-mint/scripts/install_base_username.sh | bash

myuser@myhost:~$ ansible-pull -U https://github.com/hth73/ansible-wks.git ubuntu-mint/playbooks/ansible_base.yml --extra-vars="username='$USER'" --ask-become-pass 
```

## License and Authors
Author: Helmut Thurnhofer