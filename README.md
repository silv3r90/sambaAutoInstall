# Samba installieren und ein share anlegen
##
    sudo apt-get update && sudo apt-get install -y git && git clone https://github.com/silv3r90/sambaAutoInstall.git && cd sambaAutoInstall && chmod +x setup_samba.sh && ./setup_samba.sh

# Samba share hinzufügen
##
    sudo apt-get update && sudo apt-get install -y git && git clone https://github.com/silv3r90/sambaAutoInstall.git && cd sambaAutoInstall && chmod +x add_samba_share.sh && ./add_samba_share.sh

- [x] alle eingaben zu beginn

- [x] am ende clear screen und erst dann ip ausgabe

- [ ] benutzername ganz oben im code variabel machen

- [x] ein extra sh script für wenn schon ein samba share existiert und nur hinzugefügt werden soll.

- [x] im installationsstring hinzufügen das git installiert wird, wenn noch nicht vorhanden
