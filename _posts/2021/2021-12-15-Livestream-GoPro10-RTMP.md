---
layout: post
title:  Livestreams mit RTMP, RTSP und GoPro Hero 10
categories: [gadgets]
excerpt: Let's stream
---

Die GoPro Hero 10 ist eine Action-Cam, der es nicht wild genug zugehen kann. Aber zwischen den wilden Einsätzen könnte sie doch auch einen Day-Job verrichten, oder? Einen Livestream von der GoPro abzugreifen funktioniert leider nicht out-of-the-box und braucht ein paar kleine Handgriffe.

## Streaming Protokolle

Zunächst gilt es zu verstehen, dass Livestream nicht gleich Livestream ist. Im wesentlichen gibt es zwei Protokolle, die zum Einsatz kommen: `rtsp` und `rtmp`. Das [Real-Time Streaming Protocol RTSP](https://de.wikipedia.org/wiki/Real-Time_Streaming_Protocol) ähnelt HTTP, nutzt Port 554 (alternativ 8554) und kann via UDP oder TCP laufen. Das [Real-Time Messaging Protocl RTMP](https://de.wikipedia.org/wiki/Real_Time_Messaging_Protocol) ist ein proprietäres Protokoll von Adobe, um Audio- und Video-Streams über das Netz zu schicken. Für uns spielt vor allem die Variante über TCP/IP auf Port 1935 eine Rolle.

Die GoPro Hero 10 erwartet für ihren Livestream eine RTMP URL, demzufolge nutzt sie das proprietäre Protokoll. Mein aktuelles Lieblingsprojekt [OpenDataCam]({% post_url 2021/2021-12-05-OpenDataCam-auf-Jetson %}) nutzt RTSP, der [VLC Video Player](http://www.videolan.org) ebenso und auch [OBS Studio](https://obsproject.com/) spielt lieber mit RTSP-Streams.

## Die Zielarchitektur

Was wir brauchen, ist zunächst eine GoPro Hero Kamera, getestet habe ich es mit der aktuellen Hero 10, sollte aber auch mit früheren Varianten funktionieren (solange sie einen RTMP-Stream ausgeben). Ein RMTP-Server muss diesen Stream entgegen nehmen, dieser muss auch RTSP umgewandelt werden und ein dedizierter RTSP-Endpunkt sollte als Quelle dann in Programmen wie VLC oder OBS angegeben werden.

{% include lightbox.html src="rtmp-architektur.png" data="group" title="Der Stream von der GoPro zum Client im Überblick" %}{: style="max-width: 750px;"}

Um nicht zu viel Aufwand zu betreiben, nehmen wir einfach einen Docker-Host und lassen dort 2-3 Container laufen, die sämtliche Aufgaben übernehmen.

Credit where credit is due - die Details zur Umsetzung stammen [von Reddit](https://www.reddit.com/r/synology/comments/ilzygg/stream_gopro_rtmp_to_synology_surveillance_station/).

### RTMP Server

Als RTMP-Server kommt das Image [tiangolo-nginx-rtmp](https://hub.docker.com/r/tiangolo/nginx-rtmp/) zum Einsatz. Bis auf ein Mapping von Port 1935 (tcp) ist nichts weiter notwendig, eine Konfiguration oder gar ein Volume braucht es nicht.

Das entsprechende `docker-compose.yml`:

```yaml
version: "3"
services:
  rtmp-server:
    container_name: rtmp-server
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
      - NGINX_VERSION=nginx-1.18.0
      - NGINX_RTMP_MODULE_VERSION=1.2.1
    image: tiangolo/nginx-rtmp:latest
    network_mode: bridge
    ports:
      - 1935:1935/tcp
    restart: unless-stopped
```   

### GoPro streamen lassen

{% include lightbox.html src="quik-app-stream.png" data="group" title="In der Quik-App lässt sich ein RTMP-Livestream einrichten" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

Sobald das Gegenstück - der RTMP-Server - läuft, kann der Stream auf der GoPro gestartet werden. Hierzu muss mittels der Quik-App zunächst die Kamerasteuerung übernommen werden und als Plattform _RTMP_ ausgewählt werden. Als erstes lässt sich ein WLAN verbinden. Leider muss man hier das Passwort per Hand eintragen und kann es nicht aus iOS heraus teilen.

Sobald das Netz verbunden ist, kann in die Adresszeile der gerade gestartete RTMP-Server eingesetzt werden.

Ich nutze als Endpunkt für den GoPro-Stream die Adresse `rtmp://192.168.0.44:1935/live/gopro`. Der Teil nach `live` in der URL ist der _Stream Key_ und kann frei gewählt werden. Statt `gopro` könnte man auch `kamera1` oder `ipcamera` oder sonstige kreative Bezeichnungen wählen. Eine Angabe des Ports ist nicht zwingend nötig, da hier der Standardport 1935 verwendet wird.

### RTSP Server

[aler9-rtsp-simple-server](https://hub.docker.com/r/aler9/rtsp-simple-server) macht genau was wir brauchen für den RTSP Stream. Auch hier ist nicht viel Konfiguration notwendig, allerdings muss eine Umgebungsvariable `RTSP_PROTOCOLS` auf den Wert `tcp` gesetzt und die Ports auf dem Host geöffnet werden.

In `docker-compose.yml` sieht das in etwa so aus:

```yaml
version: "3"
services:
  rtsp-server:
    container_name: rtsp-server
    entrypoint:
      - /rtsp-simple-server
    environment:
      - RTSP_PROTOCOLS=tcp
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    image: aler9/rtsp-simple-server:latest
    network_mode: bridge
    ports:
      - 8554:8554/tcp
      - 8554:8554/udp
    restart: unless-stopped
```    

Somit stehen jetzt beide Streampunkte bereit, es fehlt nur noch die Konvertierung zwischen beiden. Dazu nutzen wir ffmpeg.

### Konvertierung mit ffmpeg

Sollte sich `ffmpeg` bereits auf deinem Rechner befinden, geht dieser Schritt auch ganz ohne Docker. Mittels des folgenden Befehls beginnt die Umwandlung. Für `rtmp-server` bzw. `rtsp-server` trägst du die Adresse des Docker-Hosts ein, der _Stream Key_ muss exakt derselbe sein, den du auch beim Einrichten des Livestreams für die GoPro eingerichtet hast.

```sh
ffmpeg -i rtmp://rtmp-server:1935/live/gopro  -f rtsp rtsp://rtsp-server:8554/gopro
```

Die Ausgabe in der Shell sollte folgender ähneln, wenn der Livestream der GoPro gestartet ist:

{% include lightbox.html src="ffmpeg-rtmp-2-rtsp.png" data="group" title="Der Output von ffmpeg während der Konvertierung des Live-Streams" %}{: style="max-width: 750px;"}

{% include lightbox.html src="rtsp-stream-in-vlc.png" data="group" title="Im Öffnen-Dialog von VLC lassen sich auch RTSP-Streams öffnen" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

Mit einem Programm wie [VLC Video Player](http://www.videolan.org) lässt sich schnell herausfinden, ob alles wie gewünscht funktioniert. "Netzwerk öffnen" präsentiert einen Dialog, wo lediglich die URL des RTSP-Servers eingetragen wird (natürlich mit Port, da dies der alternative und nicht der Standardport ist) und ein Klick auf "Öffnen" den Livestream präsentiert.

{% include lightbox.html src="rtsp-stream-in-vlc.jpg" data="group" title="VLC zeigt den RTSP-Stream direkt an" %}{: style="max-width: 750px;"}

### ffmpeg in Docker

Natürlich kann man ffmpeg über den eigenen Rechner laufen lassen, aber komfortabler ist es, wenn ffmpeg auch auf dem Docker-Host läuft. Wichtig ist natürlich, dass der Computer ausreichend CPU-Leistung hat. Ein Raspberry Pi beispielsweise wird vermutlich nicht ausreichen.

Um ffmpeg in Docker laufen zu lassen empfiehlt sich das Image [jrottenberg-ffmpeg](https://hub.docker.com/r/jrottenberg/ffmpeg/). In `docker-compose.yml` müssen die Options für das `ffmpeg`-Executable als `command` hinzugefügt werden:

```yaml
version: "3"
services:
  ffmpeg:
    command: -i rtmp://192.168.0.44/live/gopro -f rtsp rtsp://192.168.0.44:8554/gopro
    container_name: ffmpeg
    entrypoint:
      - ffmpeg
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
      - LD_LIBRARY_PATH=/usr/local/lib
    image: jrottenberg/ffmpeg:latest
    network_mode: bridge
```  

### Das Setup im Docker-Compose-Format

Wer eine "just-works"-Lösung braucht, wirft folgende docker-compose Konfiguration gegen einen Docker-Host und ist fertig. Eine Kleinigkeit

Alles zusammen sieht also jetzt so aus:

1. Den untenstehenden Code in eine `docker-compose.yml` kopieren und mit `docker-compose up` starten
1. Ggf. ffmpeg erneut starten, da dieser abbricht, falls der rmtp-server nicht erreichbar ist
1. GoPro in den LiveStream-Modus versetzen und den Stream starten
1. In VLC, OBS, OpenDataCam oder wo auch immer die RTSP-URL eintragen und fleißig streamen.

```yaml
version: "3"
services:
  rtmp-server:
    container_name: rtmp-server
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
      - NGINX_VERSION=nginx-1.18.0
      - NGINX_RTMP_MODULE_VERSION=1.2.1
    image: tiangolo/nginx-rtmp:latest
    network_mode: bridge
    ports:
      - 1935:1935/tcp
    restart: unless-stopped
  rtsp-server:
    container_name: rtsp-server
    entrypoint:
      - /rtsp-simple-server
    environment:
      - RTSP_PROTOCOLS=tcp
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
    image: aler9/rtsp-simple-server:latest
    network_mode: bridge
    ports:
      - 8554:8554/tcp
      - 8554:8554/udp
    restart: unless-stopped
  ffmpeg:
    command: -i rtmp://192.168.0.44/live/gopro -f rtsp rtsp://192.168.0.44:8554/gopro
    container_name: ffmpeg
    entrypoint:
      - ffmpeg
    environment:
      - PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
      - LD_LIBRARY_PATH=/usr/local/lib
    image: jrottenberg/ffmpeg:latest
    network_mode: bridge
```

Jetzt kann die GoPro auch in ruhigen Phasen zum Einsatz kommen, theoretisch kann man sie auf diese Art auch in [Überwachungszentralen](https://www.synology.com/de-de/surveillance) einbauen und sonstige Spielereien mit anstellen.

**Happy Streaming!**
