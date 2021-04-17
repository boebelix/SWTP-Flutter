# Get started

## Voraussetzungen
Docker ist installiert (https://www.docker.com/products/docker-desktop).

## Registry Adresse zulassen
Es muss die Adresse der Docker Registry bei `insecure-registries` hinzugefügt werden. Hierzu folgenden Eintrag in der `daemon.json` von Docker hinzufügen:
```
"insecure-registries": [
    "10.0.3.47:5000"
]
```

Mit Docker Desktop kann die `daemon.json` unter `Einstellungen > Docker Engine` konfiguriert werden. Sie sieht dann ungefähr so aus:
```
{
  "registry-mirrors": [],
  "insecure-registries": [
    "10.0.3.47:5000"
  ],
  "debug": true,
  "experimental": false
}
```

## Services starten

Beim ersten Mal muss man sich im VPN befinden, damit die Images heruntergeladen werden können. Mithilfe der docker-compose.yaml kann die DB, App und ein Admin
UI für die DB gestartet werden. Hierzu in diesem Ordner die Konsole öffnen und den Befehl `docker-compose up -d` ausführen. Es kann ein wenig dauern bis die
Datenbank verfügbar ist.

Die App ist unter http://localhost:9080/ bzw. https://localhost:9443/ erreichbar.

Das Admin UI für die DB ist unter http://localhost:8080/ erreichbar.

Folgende Benutzer sind bereits in der Datenbank (Passwort ist bei allen "test"):

- test
- ania
- nicolina
- hamlen
- audi
- cammy
- dore
- damara
- neda
- barrett

Die letzten 5 Benutzer besitzen noch keine eigene Gruppe.




