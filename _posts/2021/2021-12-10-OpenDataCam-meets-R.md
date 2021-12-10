---
layout: post
title:  OpenDataCam meets R
categories: [digital]
excerpt: Nachdem ich OpenDataCam mit OpenDataCam mehr als 20.000 Vehikel gezählt habe, probiere ich, die Daten auszuwerten.
---

{% include lightbox.html src="opendatacamcounters.png" data="group" title="Einige Tausend Fahrzeuge hat OpenDataCam in den letzten Tagen gezählt" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

[OpenDataCam auf meinem Jetson]({% post_url 2021/2021-12-05-OpenDataCam-auf-Jetson %}) habe ich jetzt einige Tage lang Daten sammeln lassen, doch die Auswertung im Webinterface ist sehr spartanisch (wie im Screenshot zu sehen). Die Daten selbst werden ja in eine Mongo-Datenbank geschrieben und können so beliebig ausgewertet werden, alternativ lassen sich die Zähldaten als `json` oder `csv` herunterladen.

Seit einiger Zeit suche ich schon nach einem Vorwand, mich endlich einmal mit [R](https://www.r-project.org) zu beschäftigen, was läge also näher, als beide Themen miteinander zu verbinden?

**tl;dr** Im [Repository opendatacam-statistics auf github](https://github.com/yauh/opendatacam-statistics) findest du alle wesentlichen Informationen - PRs welcome :-)

## Rohdaten aus OpenDataCam

Unter dem Data-Tab im Webinterface lassen sich die Rohdaten eines Zählvorgangs herunterladen. Für unsere Zwecke ist das `csv`-Format ideal. Durch Komma getrennt finden sich alle wesentlichen Informationen für einfache Auswertungen in der Datei:

- Eine Zählung hat stattgefunden (das Vorhandensein einer Zeile)
- Was gezählt wurde (z.B. ein Auto oder ein Bus)
- Wann es gezählt wurde (in Form eines Timestamps)

Wer möchte, kann dies schnell und einfach in Excel einlesen und dort im Handumdrehen Charts erzeugen. In diesem Fall muss jedoch jeder Anwender quasi "das Rad für sich neu erfinden". Einfacher wäre es, wenn es eine automatisierte Möglichkeit gebe, Daten zusammenzufügen, ggf. zu transformieren und daraus brauchbare Charts zu erstellen.

## Interpretation der Daten

Die `csv`-Dateien sind nicht annotiert, haben keine Kopfzeilen, man muss also verstehen, welcher Wert welche Bedeutung hat. Glücklicherweise ist das nicht sonderlich kompliziert.

Der erste Wert is die **frameId**, als der eindeutige Identifier, welches Bild zur Zählung ausgewertet wurde. Wenn ich nicht total irre, ist dieser eindeutig. Auch über mehrer Zählvorgänge hinweg. In der Konsequenz gibt es zwei gezählte Objekte, die dieselbe `frameId` aufweisen. Aber Achtung: Wer Daten von mehr als einer OpenDataCam auswerten will, wird natürlich auch Duplikate bei **frameID** haben.

 **timestamp** ist der zweite Wert und lehnt sich an [ISO 8601](https://www.w3.org/TR/NOTE-datetime) an, lässt sich also leicht weiterverarbeiten.

 Pro Kamera lassen sich mehrere Counter definieren, die dritte Spalte gibt den **counterId** an. In meiner Installation hat er die Default-Bezeichnung "grenze".

{% include lightbox.html src="opendatacamcounterid.jpg" data="group" title="Ein klick auf die Counter-Linie offenbart die Bezeichnung" %}{: style="max-width: 750px;"}

Es folgen **objectClass** (Auto, Fußgänger, Fahrrad, etc.), eine **objectId** (das wievielte gezählte Objekt innerhalb dieser Zählsession). Diese sind nicht eindeutig, wenn man mehrere Events verarbeitet.

Die letzten drei Werte **bearing** (Ausrichtung des Objekts in Grad), **direction** und **angleWithCountingLine** spielen für die reine Zählung erstmal keine Rolle.

## Auftritt R(Studio)

R ist eine Programmiersprache für statistische Anwendungen. Wie alle anderen Programmiersprachen auch, hat sie erstmal keine graphische Oberfläche, dafür gibt es [RStudio](https://www.rstudio.com). Um loszulegen reicht es, RStudio auf dem eigenen Rechner (alle gängigen Systeme werden unterstützt: Windows, Linux, macOS - mit oder oder Apple Silicon) zu installieren. Die Befehle lassen sich dann entweder manuell eintragen oder man lässt direkt ein Script laufen.

{% include lightbox.html src="rstudio_plain.png" data="group" title="RStudio nach dem Start" %}{: style="max-width: 750px;"}

R nutzt - ähnlich wie meine Jugendliebe Perl - ein Package-System, um den Funktionsumfang zu erweitern. Für die Bearbeitung der Daten sollte `tidyverse` installiert sein, `plyr` erlaubt ein einfaches Einlesen mehrerer `csv`-Dateien und sollte ebenso vorhanden sein. Dazu reicht es, folgende Befehle einmal (muss also nicht jedesmal bei Verwendung von RStudio erneut erfolgen) in die Console in der linken Fensterhälfte einzugeben:

```r
install.packages("tidyverse")
install.packages("plyr")
```

Hierdurch sind die Packages zwar installiert, sie müssen jedoch in jeder Sitzung explizit geladen werden. Aus dem `tidyverse` brauchen wir eigentlich nur ein Package: `lubridate`, somit kommt als nächstes in die Console:

```r
library(plyr)
library(lubridate)
```

### Daten einlesen

Mittels `setwd` (_set working directory_) wird das Arbeitsverzeichnis definiert, aus welchem die csv-Dateien einzulesen sind. Liegen diese zum Beispiel auf dem Desktop des Benutzers `stephan` im Verzeichnis `opendatacam`, so würde folgender Befehl den Pfad setzen:

```r
setwd("/Users/stephan/Desktop/opendatacam")
```

Innerhalb von R werden Daten als _Dataframe_ repräsentiert. Alle aus dem Webinterface geladenen `csv`-Dateien sollen in einen einzigen Dataframe namens `odcCounts` importiert werden. Dank des `plyr`-Packages geht dies mit folgendem simplen Befehl:

```r
odcCounts <- ldply(list.files(), read.csv, header=FALSE)
```

### Daten aufbereiten

Innerhalb des Dataframes ist jede Spalte (column) eine _variable_. Zum Beispiel _timestamp_ oder _objectClass_. Jede Zeile (row) ist eine _observation_. Somit sind alle Daten jetzt vorhanden, allerdings etwas sperrig, denn ohne Header brauchen die Daten fehlt eine semantische Unterstützung. _Variable #4_ ist weniger bequem zu benutzen als _objectClass_. Mit folgendem Befehl weisen wir den Spalten aussagekräftige Namen zu:

```r
colnames(odcCounts) <- c("frameId",
  "timestamp",
  "counterId",
  "objectClass",
  "objectId",
  "bearing",
  "direction",
  "angleWithCountingLine")
```

Für spätere Auswertungen fügen wir dem Dataframe weitere Variablen hinzu. Obwohl sämtliche Informationen bereits im Timestamp vorhanden sind, macht es etwaige Auswertungen leichter, wenn wir eine eigene Spalte/Variable für den Wochentag, die Stunde am Tag, den Monat, usw. haben. Hier kommt das Package `lubridate` zum Einsatz, das Funktionen bereitstellt, die notwendigen Informationen aus einem Timestamp zu extrahieren. Mittels `mutate()` lassen sich weitere Spalten anlegen, die ihrerseits durch Funktionen, die andere Spalten referenzieren, erweitert werden können. So weit so kompliziert. Das Ergebnis der `mutate()`-Funktion schreiben wir mittels des `<-` Operators wieder zurück in den ursprünglichen Dataframe und erweitern ihn so:

```r
odcCounts <- mutate(odcCounts,
  dayOfWeek = wday(timestamp),
  ymdhms = ymd_hms(timestamp),
  month = month(timestamp),
  week = week(timestamp),
  quarter = quarter(timestamp),
  hourOfDay = hour(ymdhms))
```

Für `hourOfDay` gehen wir einen Umweg über `ymdhms`, da der direkte Zugriff auf den Timestamp aus irgendwelchen Gründen nicht funktioniert hat. Eine auswührlichere Erklärung der Funktionen findet sich [in der Lubridate-Doku](https://lubridate.tidyverse.org).

### Daten prüfen

{% include lightbox.html src="truck_or_car.jpg" data="group" title="Trefferwahrscheinlichkeiten bei der Objekterkennung variieren stark" %}{: style="max-width: 750px;"}

Auch wenn OpenDataCam gute Ergebnisse bei der Erkennung von Objekten liefert, sind diese Daten nicht immer korrekt. Bei dem Jeep oben ist sich das System zu 59% sicher, dass es sich um einen Truck handelt. Ein parkendes Auto hinten rechts erkennt es mit 30% Wahrscheinlichkeit. Allerdings sieht es eher nach dem Vorderteil eines Autos mit dem Hinterteil eines anderen Autos aus.

Ein genauerer Blick in die Daten zeigt kurioserweise, dass auch ein Objekt namens `traffic-light` über die Zählgrenze manövriert ist. Auch andere irrelevante Objekttypen tauchen dort auf, so dass eine explizite Verengung auf die eigentlich sinnvollen Daten notwendig ist. Es sollen lediglich Vehikel gezählt werden, also

- Autos
- Busse
- Fahrräder
- LKW
- Motorräder

Hierzu filtern wir den Dataframe mittels `subset` und mittels logischem _oder_ verknüpften Konditionen. Doch Vorsicht: wir erzeugen einen neuen Dataframe namens `odcCountsOnlyVehicles`:

```r
odcCountsOnlyVehicles <- subset(odcCounts,
  objectClass == "bicycle" |
  objectClass == "bus" |
  objectClass == "car" |
  objectClass == "motorbike" |
  objectClass == "truck" )
```

### Der erste Plot

Auf Basis des Dataframes `odcCountsOnlyVehicles` lassen sich jetzt Plots erstellen. Die Grundlage für einen Plot ist eine Tabelle, die wir hier `countsByHour` nennen. In dieser Tabelle gruppieren wir die Anzahl der gezählten Objekte nach der Variable `hourOfDay`. In der Console von RStudio sieht das so aus:

```r
countsByHour <- table(odcCountsOnlyVehicles$hourOfDay)
```

{% include lightbox.html src="plot_countsByHour.png" data="group" title="Ein simples Balkendiagram zur Auswertung nach Stunden" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

`barplot` erzeugt daraus ein einfaches Balkendiagramm:

```r
barplot(countsByHour,
  names.arg=rownames(countsByHour),
  xlab="Day of week",
  ylab="Count")
```

Im nächsten Schritt lassen sich beispielsweise die jeweiligen Vehikel-Typen zusammenfassen und auswerten.

In `countsByClass` sind die Objektklassen nach Tageszeit gruppiert:

```r
countsByClass <- with(odcCountsOnlyVehicles,table(objectClass,hourOfDay))
```

Der Befehl für den Plot unterscheidet sich nur unwesentlich, Legende und Farbkonfiguration kommen neu hinzu:

{% include lightbox.html src="plot_countsByClass.png" data="group" title="Das Balkendiagram erweitert zur Unterscheidung von Vehikel-Typen" %}{: style="float: right; margin-left: 1em; max-width: 250px;"}

```r
barplot(countsByClass,
  beside=TRUE,
  col=c("green","orange","blue","black","red"),
  xlab="Hour of Day",
  ylab="Count",
  legend.text=rownames(countsByClass),
  args.legend=list(x="topleft"))
```

Beide Plots erscheinen in RStudio auf der rechten Seite und lassen sich mit dem _Export_-Button direkt als `png` oder `pdf` zur Weitergabe abspeichern.

## Dies ist nur der Anfang

Wie man sieht, sind die Plots sehr rudimentär. Wie bereits erwähnt, dienten sie mir mehr als Vorwand, mich mit R zu beschäftigen und bieten eigentlich noch Potential nach oben.

Wie üblich, finden sich der gesamte Code auf [auf github im Repository yauh/opendatacam-statistics](https://github.com/yauh/opendatacam-statistics). Neben dem Code finden sich dort auch Beispieldaten aus OpenDataCam, für diejenigen, die zwar keine eigene Zählung durchführen, aber dennoch gerne mit den Daten spielen möchten.

Ich freue mich über Anmerkungen, Verbesserungsvorschläge und natürlich Pull-Requests.
