---
layout: post
title: NodeMCU ESP8266 mit MicroPython und SSD1306 OLED Display
categories: [digital]
excerpt: NodeMCU - auch als ESP8266 bekannt - verträgt sich wunderbar mit einem 0,96 Zoll OLED-Display via SPI - wenn man weiß, wie es geht.
---

Heute verbinden wir ein OLED Display mit einem ESP8266 und zeigen "Hello, World!" an.

## Der ESP8266 aka NodeMCU v3

{% include lightbox.html src="nodemcu_hallowelt.jpg" data="group" title="NodeMCU mit SSD1306 OLED Display" %}{: style="float: right; margin-left: 1em; max-width: 350px;"}

Microcomputer gibt es zuhauf. Von Arduino über ESP32 bis hin zum NodeMCU, der unter anderem im [Airrohr](https://sensor.community/de/sensors/airrohr/) zum Einsatz kommt. Daher hatte ich auch noch einen übrig, den ich gerne für ein paar Experimente nutzen würde.

Mit vollem Namen als "NodeMCU Lua Lolin V3 Module ESP8266 ESP-12F Wifi Development Board mit CH340" (bisweilen auch als NodeMCU v3) bezeichnet ist die Platine äußerst einfach zu verbinden, da USB und WLAN direkt an Bord sind. Außerdem müssen keine Steckerleisten gelötet werden, es kann sofort losgehen. Wer noch keinen NodeMCU hat, kann sich für deutlich unter 10 Euro (bei AliExpress noch günster, dafür mit Wartezeiten) ausstatten. Wenn es um einfache Sensorwerte geht, einfach top!

## MicroPython statt C

Grundsätzlich ist die Programmierung von Arduino-artigen Geräten nicht sonderlich kompliziert. Habe ich mir sagen lassen. Da ich aber eh etwas tiefer in Python einsteigen will, greife ich direkt zu [MicroPython](https://micropython.org), da hoffe ich auf ein paar mögliche Synergien.

{% include lightbox.html src="mu_flasher.png" data="group" title="Mu Editor kann Firmware deutlich komfortabler flashen" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

Um MicroPython nutzen zu können, benötigt der ESP8266 [eine angepasste Firmware, die auf der Micropython.org-Webseite heruntergeladen werden kann](https://micropython.org/download/esp8266/). Wichtig ist, auf die 2MiB+ Flash Variante zu achten. 

Ganz simpel geht das Flashen der Firmware auch mit [Mu](https://codewith.mu), allerdings habe ich das bisher nicht ausprobiert, sondern habe `esptool` genutzt.

### esptool für Firmware-Updates

Ein Flash ist mittels Kommandozeile auch unter macOS auf einem ARM-MacBook (M1 oder M2) möglich. Erst `esptool` installieren und das NodeMCU mit dem Rechner via USB verbinden (geht auch via USB-Hub problemlos). 

Erst gilt er herauszufinden, wie die genaue Adresse des NodeMCU ist. Ich habe dazu die [Arduino-IDE](https://www.arduino.cc/en/software) genutzt, weil sie eh vorhanden war. Zu finden ist die Hardware in meinem Fall unter `/dev/cu.usbserial-340`. Auch hier - Mu erledigt das direkt mit.

Um die Firmware zu aktualisieren löschen wir zunächst das Flash und spielen dann die aktuelle Firmware - in diesem Fall `esp8266-20220618-v1.19.1.bin` - auf.

Im Terminal sieht das dann in etwa so aus:

```bash
$ pip install esptool
$ esptool.py --port /dev/cu.usbserial-340 erase_flash
$ esptool.py --port /dev/cu.usbserial-340 --baud 460800 write_flash --flash_size=detect 0 esp8266-20220618-v1.19.1.bin
```


## Verkabelung NodeMCU und OLED Display

{% include lightbox.html src="nodemcu_display_kabel.jpg" data="group" title="Verkabelung am NodeMCU" %}{: style="float: left; margin-right: 1em; max-width: 150px;"}

Sobald der NodeMCU Python sprechen kann, verbinden wir das Display. In meinem Fall ist es ein SSD1306-kompatibles OLED Display mit 0,96 Zoll und einer Auflösung von 128x64 Zeichen. Insgesamt hat es 7 Pins, es gibt aber auch Displays mit nur 4 Pins. Letztere können nur via I<sup>2</sup>C angeschlossen werden. 

Wir nutzen die Verbindung via SPI und dank der Steckerleisten können wir Jumperkabel verwenden anstatt zu löten.

Die folgende Tabelle zeigt, welche Stecker miteinander verbunden werden sollen. Mehr Details liefern die Bilder.

{% include lightbox.html src="nodemcu_ssd1306.jpg" data="group" title="SSD1306 Kabel" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

| ESP8266 NodeMCU | OLED Display | Farbe |
| --- | --- | --- |
| GND | GND | weiß |
| 3.3V | VCC | schwarz |
| GPIO 14 (D5) | D0 (SCK / CLK) | braun |
| GPIO 13 (D7) | D1 (MOSI) | rot |
| GPIO 4 (D2) | RES | orange |
| GPIO 5 (D1) | DC | gelb |
| GPIO 15 (D8) | CS | grün |

Weitere Dokumentation findet sich in der [offiziellen Dokumentation](https://docs.micropython.org/en/latest/esp8266/tutorial/ssd1306.html) unter dem Punkt _Software SPI interface_.  

Wir haben jetzt das SSD1306 OLED mit dem NodeMCU verbunden. Die Pins `DC`, `RST` und `CS` sind mit `GPIO5`, `GPIO4` und `GPIO15` verbunden. Achtung:

Die Pins `D0` und `D1` Pins sind mit `GPIO14` und `GPIO13` verbunden. `VCC` und `GND` liegen am `3V out` und `GND` an.

> **Achtung!** In zahlreichen anderen Anleitungen im Netz sind Pin 4 und 5 vertauscht, aufgepasst, dass eure Belegung exakt dieser entspricht - sonst läuft der Code später nicht!

## Das Bord programmieren

Die Arduino IDE eignet sich leider nicht, um MicroPython zu nutzen, daher habe ich zu [Mu](https://codewith.mu) als Programmierumgebung gegriffen.

Sämtliche Treiber sind in der NodeMCU-Firmware enthalten, also reicht es nun aus, eine einzelne Datei zu schreiben, die das Display anspricht.

Der Code kommt in eine Datei `main.py` und sieht wie folgt aus:

```python
from machine import Pin, SoftSPI
import ssd1306

spi = SoftSPI(
    baudrate=500000, polarity=1, phase=0, sck=Pin(14), mosi=Pin(13), miso=Pin(12)
)

dc  = Pin(5)   # data/command
rst = Pin(4)   # reset
cs  = Pin(15)  # chip select
display = ssd1306.SSD1306_SPI(128, 64, spi, dc, rst, cs)

display.text("Hello, World!", 0, 0)
display.show()
```

### Datei auf ESP8266 kopieren

Mittels Mu muss diese Datei auf den ESP8266 kopiert werden und kann ausgeführt werden.

![Kopieren von Dateien in Mu](/images/upload_mainpy.gif)