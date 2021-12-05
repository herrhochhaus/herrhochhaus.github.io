---
layout: post
title:  OpenDataCam auf Jetson Nano
categories: [digital]
excerpt: Das OpenDataCam-Projekt erlaubt es einfach und schnell, Dinge in der Welt zu erfassen und zu zählen. Besonders einfach ist dies mit einem Jetson Nano und einer Webcam.
---

Computer Vision fasziniert mich und ich habe schon diverse Projekte im Auge (haha, pun intended) gehabt, doch besonders leicht ist der Einstieg mit [OpenDataCam](https://github.com/opendatacam/opendatacam). Prinzipiell läuft die Software auf unterschiedlicher Hardware - und bei Bedarf sogar in der Cloud. In meinem Fall betreibe ich es auf einem Nvidia Jetson Nano und einer 64GB SD-Karte in Kombination mit einer Logitech C920 Webcam.

## Was ist OpenDataCam

OpenDataCam ist - simpel gesagt - eine Software, welche die Zählung von Objekten in der realen Welt ermöglicht. Mit einer Webcam wird ein Bild aufgenommen und in Echtzeit analysiert. Die Kernfunktionen umfassen das Identifizieren von Objekten (zum Beispiel Auto, Bus, Fußgänger, Radfahrer), Zählen und Tracking der zurückgelegten Pfade. Die gesammelten Daten lassen sich in einer MongoDB abspeichern und von dort auswerten und weiterverarbeiten.

## Hardware und Umgebung vorbereiten

Mein Nvidia Jetson Nano ist ein Developer Kit mit 4GB RAM und einem ARMv8 Prozessor. Der Tegra Tx1 Chip sorgt für ausreichend Power für GPU-Tasks. Ein Raspberry Pi wäre nicht leistungsstark genug, könnte aber theoretisch nur dazu genutzt werden, die Daten mittels einer Kamera an ein leistungsstärkeres (Cloud-)Backend weiterzugeben.

{% include lightbox.html src="flashjetpack46.png" data="group" title="Das Flashen dauert ein paar Minuten" %}{: style="float: left; margin-right: 1em; max-width: 250px;"}

Auch wenn das Projekt selbst aus Performancegründen noch JetPack 4.3 empfiehlt, lade ich [das neueste JetPack 4.6 Image](https://developer.nvidia.com/embedded/jetpack) herunter und schreibe es mit [Etcher](https://www.balena.io/etcher/) auf die SD-Karte. Sobald das Image fertig geschrieben ist, kann der erste Boot und die Installation des Jetson erfolgen.
WLAN einrichten, Keyboardlayout wählen und etwas abwarten, dann ist der Jetson auch schon einsatzbereit.

[`jetson_release`](https://github.com/rbonghi/jetson_stats) zeigt die aktuellen Versionen:

```bash
stephan@jetson:~$ jetson_release
 - NVIDIA Jetson Nano (Developer Kit Version)
   * Jetpack 4.6 [L4T 32.6.1]
   * NV Power Mode: MAXN - Type: 0
   * jetson_stats.service: activating
 - Libraries:
   * CUDA: 10.2.300
   * cuDNN: 8.2.1.32
   * TensorRT: 8.0.1.6
   * Visionworks: 1.6.0.501
   * OpenCV: 4.1.1 compiled CUDA: NO
   * VPI: ii libnvvpi1 1.1.12 arm64 NVIDIA Vision Programming Interface library
   * Vulkan: 1.2.70
```

Da `cuda` nicht im Pfad ist, müssen [in der `.bashrc` noch zwei Zeilen hinzugefügt werden](https://github.com/opendatacam/opendatacam/blob/master/documentation/jetson/FLASH_JETSON.md#Jetson-Nano):

```bash
export PATH=${PATH}:/usr/local/cuda/bin
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/local/cuda/lib64
```

Jetzt sollte `nvcc --version` folgende Informationen ausgeben:

```bash
stephan@jetson:~$ nvcc --version
nvcc: NVIDIA (R) Cuda compiler driver
Copyright (c) 2005-2021 NVIDIA Corporation
Built on Sun_Feb_28_22:34:44_PST_2021
Cuda compilation tools, release 10.2, V10.2.300
Build cuda_10.2_r440.TC440_70.29663091_0
```

Bevor OpenDataCam installiert werden kann, müssen einige Dependencies erfüllt werden:

```bash
sudo apt install python3-pip
sudo apt-get install -y libffi-dev python-openssl libssl-dev
sudo -H pip3 install --upgrade pip
sudo -H pip3 install docker-compose
```

### OpenDataCam installieren

Ab hier gilt es, [einfach der Anleitung zu folgen](https://github.com/opendatacam/opendatacam#2-install-and-start-opendatacam-):

```bash
wget -N https://raw.githubusercontent.com/opendatacam/opendatacam/v3.0.2/docker/install-opendatacam.sh
chmod 777 install-opendatacam.sh

./install-opendatacam.sh --platform nano
```

Je nachdem wie schnell das Internet angebunden ist, bleibt nun Zeit für eine Tasse Heißgetränk, dann ist alles fertig und unter Port 8080 bereit.

{% include lightbox.html src="opendatacamsim.png" data="group" title="Nach der Installation zeigt OpenDataCam eine Simulation im Browser" %}{: style="max-width: 750px;"}

## OpenDataCam konfigurieren

Auch wenn die Simulation schon sehr beeindruckend ist, wir müssen die Kamera noch konfigurieren und die Daten entsprechend speichern. Ich möchte sie nicht auf der SD-Karte ablegen, sondern eine lokale Mongo-Instanz angeben.

### USB-Webcam nutzen

Im Heimverzeichnis befindet sich eine Datei `config.json`, in welcher sämtliche relevanten Einstellungen vorgenommen werden. Da bei mir mehrere Video-Inputs vorhanden sind, muss ich die `VIDEO_INPUTS_PARAMS` auf `/dev/video1` anpassen ([siehe offizielle Doku](https://github.com/opendatacam/opendatacam/blob/master/documentation/CONFIG.md#video-input)) und natürlich `VIDEO_INPUT` auf `usbcam` setzen.

```json
{
  # snip
  "VIDEO_INPUT": "usbcam",
  # snip
  "VIDEO_INPUTS_PARAMS": {
    # snip
    "usbcam": "v4l2src device=/dev/video1 ! video/x-raw, framerate=30/1, width=640, height=360 ! videoconvert ! appsink",
    # snip
  }
}
```

### Externe Mongo-Instanz

Für `MONGODB_URL` in der `config.json` muss ein [gültiger Connect-String](https://docs.mongodb.com/manual/reference/connection-string/) eingetragen werden. In meinem Fall ist die Mongo-Instanz unter 192.168.0.44 erreichbar und nutzt die Datenbank `opendatacam` mit dem Nutzer `opendatacam` und Passwort `opendatapass`. Als String sieht es dann so aus:

```json
MONGODB_URL="mongodb://opendatacam:opendatapass@192.168.0.44:27017/?authSource=opendatacam"
```

Wenn das alles funktioniert, brauchen wir den zweiten Docker-Container mit Mongo nicht mehr und können den auskommentieren. Meine `docker-compose.yml` sieht dann so aus:

```yaml
version: "2.3"
services:
  opendatacam:
    restart: always
    image: opendatacam/opendatacam:v3.0.2-nano
    privileged: true
    volumes:
      - './config.json:/var/local/opendatacam/config.json'
    ports:
      - "8080:8080"
      - "8070:8070"
      - "8090:8090"
#  mongo:
#    image: mongo:4.4.8
#    restart: always
#    ports:
#      - "27017:27017"
#    volumes:
#      - mongodb_data_container:/data/db
#volumes:
#  mongodb_data_container:
```

Wenn alles einwandfrei läuft, können wir den nunmehr verwaisten Container loswerden:

```bash
sudo docker-compose down --remove-orphans
```

## Verkehrszählung mit OpenDataCam

Jetzt kann gezählt werden. Im Browser einen Counter einrichten und los geht es. Bei knapp unter 20fps zählt der Jetson fleißig Verkehrsteilnehmer.

{% include lightbox.html src="opendatacamcounter.png" data="group" title="OpenDataCam im Einsatz" %}{: style="max-width: 750px;"}

{% include lightbox.html src="opendatacamcounter2.png" data="group" title="Identifizierte Objekttypen werden statistisch erfasst und die Daten lassen sich herunterladen" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

Die gesamelten Daten lassen sich zum Beispiel im JSON-Format herunterladen ([siehe Beispieldaten hier](/assets/counter.json)).

**Achtung!** Wer eine Kamera in den öffentlichen Raum richtet, sollte sich vorher dringend informieren, ob der Datenschutz ausreichend gewährleistet ist. Der Vorteil von OpenDataCam liegt darin, dass keine Daten über die reine Anzahl und den Bewegungspfaden hinaus gespeichert werden. Auch ist die Auflösung nicht so hoch, dass sich individuelle Personen oder Kennzeichen erkennen lassen. Theoretisch lässt sich das Projekt natürlich anpassen, dass es zum Beispiel die Anzahl der Ameisen auf dem eigenen Balkon zählt.
