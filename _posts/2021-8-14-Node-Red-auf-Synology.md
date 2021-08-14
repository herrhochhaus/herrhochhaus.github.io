---
layout: post
title:  Node-Red Container auf Synology
categories: [computer]
excerpt: Node-Red via Docker ist eigentlich eine Kleinigkeit. Auf einem Synology NAS gibt es allerdings etwas zu beachten.
---

[Node-Red](https://nodered.org) ist eine Engine für Flow-Based-Programming. Eine Reihe von Nodes wird logisch miteinander verknüpft, so dass anhand einer visuellen Oberfläche schnell und einfach Event-Folgen programmiert werden können. Natürlich bietet es sich an, diese Engine auf einem Docker-Host mitlaufen zu lassen.

Bei mir läuft ein Synology NAS 24/7 und unterstützt sogar Docker Container. Da bietet es sich an, auf dem NAS einen weiteren Node-Red Container laufen zu lassen. Simpel genug, gibt es eine grafische Oberfläche in Synology, die Zugriff auf den Dockerhub gewährt und Downloads von Images und das Erstellen von Container ermöglicht.

Wie bei Containern üblich, sollten die zu persistierenden Daten auf einem Laufwerk außerhalb des Containers gespeichert werden. In diesem Fall wird ein Verzeichnis des NAS auf das Verzeichnis `/data` des Containers gemappt.

Startet man dann eine aktuelle Version von Node-Red im Container (in meinem Fall v2.0.5), dann kommt es zu einer Fehlermeldung:

> Error: EACCES: permission denied, copyfile '/usr/src/node-red/node_modules/node-red/settings.js' -> '/data/settings.js'

Des Rätsels Lösung liegt in den Berechtigungen des Verzeichnisses auf dem NAS. `GUID` und `PUID` als Umgebungsvariablen funktionieren mit dem Node-Red-Container jedoch nicht. Eine denkbare Lösung wäre, den Container mit maximalen Privilegien (sprich: root) laufen zu lassen. Schlechte Idee.

Der Container erwartet Schreibberechtigungen für einen Nutzer mit der UID 1000 auf dem `/data`-Verzeichnis. Abhilfe schafft daher ein Zugriff auf das NAS via SSH und der Befehl (angenommen, das Mapping zeigt auf `/docker/nodered`)

> chown 1000 /volume1/docker/nodered
