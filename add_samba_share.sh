#!/bin/bash

# Pfad für das neue Samba-Share abfragen
read -p "Bitte geben Sie den Pfad für das neue Samba-Share an: " share_path

# Share-Namen abfragen
read -p "Bitte geben Sie den Namen des neuen Shares an: " share_name

# Schritt 1: Verzeichnis erstellen, falls es nicht existiert
if [ ! -d "$share_path" ]; then
    sudo mkdir -p "$share_path"
fi

sudo chown -R kevin:kevin "$share_path"
sudo chmod -R 0755 "$share_path"

# Schritt 2: smb.conf bearbeiten
sudo bash -c "cat >> /etc/samba/smb.conf <<EOL

[$share_name]
path = $share_path
browsable = yes
read only = no
valid users = kevin
EOL"

# Schritt 3: Samba-Dienste neu starten
sudo systemctl restart smbd
sudo systemctl restart nmbd

# Bildschirm leeren
clear

# IP-Adresse des Systems herausfinden
ip_address=$(hostname -I | awk '{print $1}')

# Ausgabe der IP-Adresse und des Mountpunkts
echo "Neues Samba-Share hinzugefügt! Die IP-Adresse des Systems ist: $ip_address"
echo "Sie können das neue Share in Windows mit \\\\$ip_address\\$share_name einbinden."
