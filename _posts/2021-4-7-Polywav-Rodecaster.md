---
layout: post
title:  Mein Podcast-Workflow mit dem Rodecaster Pro
categories: [podcast, technik]
excerpt: Das Rodecaster Pro nimmt Podcasts ganz ohne Computer auf. Allerdings gibt es ein paar Kniffe, die im Workflow etwas Handarbeit erfordern.
---

Das [Rodecaster Pro](https://de.rode.com/rodecasterpro) ist die eierlegende Wollmilchsau für Podcaster:innen. Bis zu vier Mikrofone lassen sich direkt an das Gerät anschließen. Via USB, Bluetooth oder Kabel lassen sich Computer und Telefon anschließen und acht farbige  Tasten dienen als Soundboard.

![Rodecaster Pro mit zwei Mikrofonen](/images/rodecasterpro.jpg)

Summa summarum schreibt das Rodecaster in die aufgenommenen WAV-Dateien 14 (in Worten: Vierzehn) Spuren:

1. Main links
1. Main rechts
1. Mikrofon 1
1. Mikrofon 2
1. Mikrofon 3
1. Mikrofon 4
1. USB links
1. USB rechts
1. TRRS links (Telefon per Klinkenkabel)
1. TRRS rechts
1. Bluetooth links
1. Bluetooth rechts
1. Soundboard links
1. Soundboard rechts

Für unseren Podcast [Die Psycho und der Geek](https://www.diepsychounddergeek.de) brauche ich eigentlich nur zwei Spuren, Mikrofon 1 + 2. Alles andere bearbeite ich in [Ultraschall](https://ultraschall.fm) bzw. Reaper.

Erschwerend hinzu kommt, dass das Rodecaster in die Polywav-Dateien nicht nur 14 Spuren produziert, sondern jene Dateien haben auch - historisch bedingt - eine **maximale Größe von 4 GB**. Mit 14 Spuren kommen da bei einer Stunde Podcast schonmal drei WAV-Dateien mit je 14 Spuren zusamen. Schwirrt der Kopf schon? Meiner auch!

## Vom Rodecaster in Ultraschall

Der Weg der fertigen Aufnahme aus dem Rodecaster bis in Ultraschall umfasst bei mir die folgenden Schritte:

1. Kopieren der Dateien von der SD-Karte
1. Strippen der nicht benötigten Spuren
1. Zusammenführen der einzelnen "Takes"
1. Import in Ultraschall

### Kopieren der Dateien

Das Rodecaster Pro ist so vielseitig, dass es auch als SD-Card-Reader im _Transfer-Modus_ funktioniert. Einfach ein USB-Kabel einstöpseln und das andere Ende ins MacBook. Allerdings ist die Übertragungsgeschwindigkeit - gelinde gesagt - eher am unteren Ende des Möglichen.

Alternativ den SD-Card-Adapter gesucht, Micro-SD-Karte reingeschoben, ab ins Dock mit integriertem Reader und Kopiervorgang starten. Ist um Längen schneller.

### Strippen und Zusammenführen

Die nächsten beiden Schritte lassen sich in einem Rutsch ausführen. Hierzu benötigt es das Kommandozeilen-Werkzeug [sox](http://sox.sourceforge.net). Auf dem Mac installiert man es schnell und simpel via [Homebrew](https://brew.sh) mittels

```bash
$ brew install sox
```

Ich habe ein Script geschrieben ([findet sich auch auf Github](https://gist.github.com/yauh/2afe3f6b6d05686d69efce363d9fa1cb)), was mittels sox zunächst alle Spuren der WAV-Datei separiert (_extractChannel_) und dann pro Spur alle Takes nimmt und miteinander verbindet (_concatTakes_).

```bash
#!/bin/bash

# Rødecaster Pro Extraction Tool
# This script assumes all recording files for a podcast episode to be in the same directory as the script
# It then extracts all 14 single channels from the wav file and concatenates them
# Regardless of how many (split) recording wav files you have it will always produce 14 flac files
# sox must be available on the system http://sox.sourceforge.net

# Rødecaster Pro channel config
# adjust this if you have a different channel setup for your polywav files
channelIds=("skip" "01_main_l" "02_main_r" "03_mic_1" "04_mic_2" "05_mic_3" "06_mic_4" "07_usb_l" "08_usb_r" "09_trrs_l" "10_trrs_r" "11_bluetooth_l" "12_bluetooth_r" "13_soundboard_l" "14_soundboard_r")
# if you wish to merge takes set this to
mergeTakes=true
# if you wish to delete the intermediary channel files after concatenating
removeIntermediaryChannelFiles=true

# function to extract a single channel using sox
function extractChannel() {
  filename=$1
  identifier=$2
  channel=$3

  filename_without_ext=`echo "${filename}"|sed "s/\(.*\)\.\(.*\)/\1/"`
  new_filename="${identifier}_${filename_without_ext}.flac"

  echo "extracting channel ${channel} from ${filename} to ${new_filename}"

  sox $filename $new_filename remix $channel
}

# function to concat multiple files using sox
function concatTakes() {
  channelId=$1
  channelFiles=(${channelId}*.flac)
  mergedFile="${channelId}.flac"

  echo "concatenating files ${channelFiles[@]} to $mergedFile"

  sox ${channelFiles[@]} $mergedFile

  # remove the intermediary files if configured
  if [ "$removeIntermediaryChannelFiles" = true ]; then
    echo "removing intermediary channel files"
    rm ${channelFiles[@]}
  fi
}

# let's go
echo "*** Extracting channels from polywav files ***"
echo "finding wav files"

# create an array with all the wav files inside the current directory
# expects all upper case filenames
wavFiles=(*.WAV)

echo "extracting channels"
# iterate through WAV files
for i in ${!wavFiles[*]}; do
  for j in ${!channelIds[@]};
  do
  # skip the array value with index 0
    if [[ "$j" == '0' ]]; then
        continue
    fi
    # extract each channel from the WAV file
    extractChannel ${wavFiles[i]} ${channelIds[$j]} $j
  done
done

if [ "$mergeTakes" = true ]; then
  echo "merging takes"
  # iterate through channels to merge takes
  for k in ${!channelIds[@]};
  do
    # skip the array value with index 0
    if [[ "$k" == '0' ]]; then
        continue
    fi
    # merge all takes into a single file
    concatTakes ${channelIds[$k]}
  done
fi
```

Script und WAV-Dateien kommen in dasselbe Verzeichnis.

![WAV-Dateien und Shell-Script](/images/rodecasterflow-1.png)

Im Terminal dann in das Verzeichnis wechseln und das Script ausführen.

```bash
$ cd Folge\ 42/
$ bash extract_rodecaster_polywav.sh

```
Das Script nimmt sich alle WAV-Dateien in alphabetischer Reihenfolge vor und erzeugt pro Datei 14 FLAC-Dateien.

![Das Shell-Script in Action](/images/rodecasterflow-2.png)

Wenn das Script durch ist, bleiben exakt 14 FLAC-Dateien übrig (das ist das Standardformat für Ultraschall 5, daher keine WAV-Dateien).

![WAV-Dateien und Shell-Script](/images/rodecasterflow-3.png)

### Import in Ulraschall

Wenn die Aufnahme mit drei Teilnehmern erfolgt ist, reicht es eigentlich aus, die Dateien 3, 4 und 5 (Mikrofon 1-3) in Ultraschall (oder jede andere [DAW](https://www.delamar.de/musiksoftware/podcast-software-51742/) zu importieren.

Im Grunde sollten sowohl das Script als auch die resultierenden Dateien ausreichend selbsterklärend sein.

Viel Spaß mit diesem Workflow!
