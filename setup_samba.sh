#!/bin/bash

# Samba-Passwort abfragen
read -sp "Bitte geben Sie das Passwort für den Benutzer kevin ein: " user_password
echo

# Pfad für das Samba-Share abfragen
default_path="/srv/samba/data"
read -p "Bitte geben Sie den Pfad für das Samba-Share an (Standard: $default_path): " share_path
share_path=${share_path:-$default_path}

# Share-Namen abfragen
read -p "Bitte geben Sie den Namen des Shares an: " share_name

# Schritt 1: Update und Installation von Samba
sudo apt update
sudo apt install samba -y

# Schritt 2: Benutzer erstellen
sudo useradd kevin -s /sbin/nologin

# Schritt 3: Passwort setzen
echo "kevin:$user_password" | sudo chpasswd

# Schritt 4: Samba Passwort setzen
echo -e "$user_password\n$user_password" | sudo smbpasswd -a kevin

# Schritt 5: Verzeichnis erstellen, falls es nicht existiert
if [ ! -d "$share_path" ]; then
    sudo mkdir -p "$share_path"
fi

sudo chown -R kevin:kevin "$share_path"
sudo chmod -R 0755 "$share_path"

# Schritt 6: smb.conf bearbeiten
sudo bash -c "cat >> /etc/samba/smb.conf <<EOL

[$share_name]
path = $share_path
browsable = yes
read only = no
valid users = kevin
EOL"

# Schritt 7: Samba-Dienste neu starten
sudo systemctl restart smbd
sudo systemctl restart nmbd

# Bildschirm leeren
clear

# IP-Adresse des Systems herausfinden
ip_address=$(hostname -I | awk '{print $1}')

# Ausgabe der IP-Adresse und des Mountpunkts
echo "Samba-Setup abgeschlossen! Die IP-Adresse des Systems ist: $ip_address"
echo "Sie können das Share in Windows mit \\\\$ip_address\\$share_name einbinden."
