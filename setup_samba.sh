#!/bin/bash

# Standard-Samba-Verzeichnis
default_share_path="/srv/samba/data"

# Schritt 1: Update und Installation von Samba
sudo apt update
sudo apt install samba -y

# Schritt 2: Benutzer erstellen
sudo useradd kevin -s /sbin/nologin

# Schritt 3: Passwort abfragen
read -sp "Bitte geben Sie das Passwort für den Benutzer 'kevin' ein: " user_password
echo

# Schritt 4: Passwort setzen
echo "kevin:$user_password" | sudo chpasswd

# Schritt 5: Samba Passwort setzen (verwenden des gleichen Passworts)
echo -ne "$user_password\n$user_password\n" | sudo smbpasswd -a kevin

# Schritt 6: Pfad abfragen und Verzeichnis erstellen oder Standard verwenden
read -p "Bitte geben Sie den Pfad für das Samba-Share an (Leer lassen für Standardverzeichnis $default_share_path): " user_share_path

# Verwenden des Standardverzeichnisses, wenn keine Eingabe erfolgt
if [ -z "$user_share_path" ]; then
    share_path="$default_share_path"
else
    share_path="$user_share_path"
fi

if [ ! -d "$share_path" ]; then
    sudo mkdir -p "$share_path"
    echo "Verzeichnis $share_path erstellt."
else
    echo "Verzeichnis $share_path existiert bereits."
fi

sudo chown -R kevin:kevin "$share_path"
sudo chmod -R 0755 "$share_path"

# Schritt 7: Share-Namen abfragen und smb.conf bearbeiten
read -p "Bitte geben Sie den Namen des Shares an: " share_name

# Erstellen des Samba-Shares
sudo bash -c "cat >> /etc/samba/smb.conf <<EOL

[$share_name]
path = $share_path
browsable = yes
read only = no
valid users = kevin
EOL"

# Schritt 8: Samba-Dienste neu starten
sudo systemctl restart smbd
sudo systemctl restart nmbd

# Schritt 9: IP-Adresse ausgeben (nur die erste IP)
ip_address=$(hostname -I | awk '{print $1}')
echo "Samba-Setup abgeschlossen! Die IP-Adresse des Systems ist: $ip_address"

# Schritt 10: Ausgabe des Windows-Mount-Pfads
echo "Zum Mounten in Windows verwenden Sie: \\\\${ip_address}\\${share_name}"
