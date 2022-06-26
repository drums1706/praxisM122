# Betriebsdokumentation
[[_TOC_]]
## Einführungstext 

Unser Auftrag war es zwei verschiedene Scripte zu erstellen, die verschiedene Funktionen haben. Das erste Script soll verschiedene User kreieren mit bestimmten angaben und das zweite Script soll die verschiedenen Gruppen backupen.

## Installationsanleitung für Administratoren

### Vorinstallation
* Ubuntu 20.04.4 LTS

### Installation

1. Das Repository Clonen
````
git clone https://github.com/drums1706/praxisM122
````

2. Konfigurationen anpassen

### Konfiguration

Das konfigurationsfile in `etc/` umbennen
````
groups.config.example > groups.confg
````

Die Gruppen wie im vorgegebenen Beispiel (groups.config.example) setzen. Eine Gruppe pro Line.

## Bediensanleitung Benutzer

### User Input File

Für das Script createuser.sh muss man nun die verschiedenen im folgenden Format eingeben:

````
<username> <groupname> <vorname> <nachname>
````

### Das Script createuser.sh aufrufen
Mit Folgendem Befehl kann man einen User generieren.
```
sudo ./createuser.sh -p [user password] [path to userfile]
```

### Das Script backup.sh aufrufen
Mit Folgendem Befehl kann man einen Backup ausführen.
````
sudo ./backup.sh -p [prefix] [path to backupfolder]
````
