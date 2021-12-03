---
layout: post
title:  Sonos über Elgato Stream Deck steuern
categories: [smarthome]
excerpt: Wer über Sonos Musik hört und ein Stream Deck von Elgato nutzt, kann beide einfach und schnell miteinander verbinden.
---

Das [Elgato Stream Deck](https://www.elgato.com/de/stream-deck) ist eine programmierbare Tastatur mit jeweils 72x72 Pixeln LCD Displays. Damit lässt sich schon eine ganze Menge anfangen, auch wenn die Standard-Plugins schon stark an Video-Streamer (daher auch der Name) ausgerichtet sind. Dank HTTP Requests lässt sich aber auch ein smartes Heimsystem wie [Sonos](https://www.sonos.com/) damit steuern.

## Eine API für Sonos

Offiziell existiert leider keine einfache API für ein Sonos-System, aber dank einer großen Nutzerbasis gibt es Projekte wie [node-sonos-http-api](https://github.com/jishi/node-sonos-http-api), die auch mit aktuellen Geräten einwandfrei funktionieren. Dank Docker reicht es, den Container auf einem Raspberry, dem eigenen Rechner oder auch einem NAS laufen zu lassen.

In meinem Fall habe ich den Container via `docker-compose` gestartet:

```yaml
version: '2'
services:
  sonos-api:
    image: jin2uir/sonos
    container_name: sonos-api
    privileged: false
    restart: always
    network_mode: host
```

Sämtliche Kommunikation erfolgt über Port 5005 und da Sonos in der Regel offen erreichbar sind, funktioniert alles, sobald der Container läuft. Unter `http://local-box:5005` findet sich eine kurze Beschreibung der API.

## Per Knopfdruck Radio hören

Um herauszufinden, wie man die Lautsprecher identifiziert, reicht ein Blick in die Sonos-App. Alternativ listet die API alle Lautsprecher bzw. `Zones` unter dem URL `http://local-box:5005/zones`.

In meinem Beispiel möchte ich auf `Flur` gerne Deutschlandfunk starten. Diesen habe ich bereits bei meinen Favoriten in Sonos gespeichert und kann ihn mittels des Namens aufrufen:

`http://local-box:5005/Flur/favorite/Deutschlandfunk`

Diesen Befehl legen wir auf eine Taste des Stream Decks. Hierzu wähle ich in der Konfiguration mein Profile aus, suche mir eine passende Taste aus und wähle aus der Kategorie `System` den Eintrag `Webseite` aus.

{% include lightbox.html src="streamdeck-sonos-flur.png" data="group" title="Konfiguration der DLF-Taste in Stream Deck" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

Für das hübschere Erscheinungsbild lade ich ein Icon des Senders als Tastenhintergrund auf das Deck. Um auch auf Tastendruck die Box im Flur zum Schweigen zu bringen, mappe ich eine weitere Taste mit dem URL `http://local-box:5005/Flur/pause`.

Wer jetzt genug Motivation hat, kann auch Lautstärkeregelung, Playlisten, Gruppierungen, Shuffle-Play und so weiter per Taste verfügbar machen.
