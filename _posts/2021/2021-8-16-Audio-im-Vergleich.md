---
layout: post
title:  Soundcheck - Klangvergleich für Video-Calls
categories: [gadgets]
excerpt: Nachdem Videocalls der neue Standard für geschäftliche Treffen geworden sind, spielt die Tonqualität des eigenen Equipments eine zentrale Rolle, um ermüdungsfreie Meetings zu ermöglichen. Doch wie klingt eigentlich das eigene Equipment?
---

Angeregt durch [Ralf](https://rottmann.net) und [Volker](https://vowe.net), [die Anfang 2021 Hunderte von Soundchecks auf Clubhouse durchgeführt haben](https://vowe.net/archives/018975.html), bin ich neugierig geworden, wie mein eigenes Equipment für die Gegenseite klingt.

Allerdings verbringe ich inzwischen eher wenig Zeit auf [Clubhouse](https://www.joinclubhouse.com), dafür umso mehr in [Microsoft Teams](https://www.microsoft.com/de-de/microsoft-teams/). Dabei höre ich regelmäßig, wie die Kolleg:innen in den verschiedensten Konstellationen klingen, aber nie, wie ich selbst klinge. Daher habe ich mich für ein kleines Experiment entschieden.

## Testszenario

Mein Standard-Equipment für Video-Calls umfasst inzwischen eine ziemliche Bandbreite, von Bluetooth über USB bis hin zum professionellen Mikrofon, welches eigentlich für Podcasts zum Einsatz kommt. Diese nutze ich nacheinander, um ein Klangbeispiel aufzunehmen. Um einigermaßen realistische Beispiele zu finden, sitze ich nicht nur statisch da, sondern bewege mich während der Aufnahme etwa so, wie ich es während eines Redebeitrags in einer Videokonferenz machen würde.

Ich nehme immer zwei Versionen auf: einmal in einer sehr ruhigen Umgebung wie zuhause und einmal mit [Hintergrundgeräuschen](https://www.youtube.com/watch?v=PHBJNN-M_Mo) über Lautsprecher, die an ein belebtes Großraumbüro erinnern.

Das Testsetup sieht vor, dass ich mich auf zwei MacBooks in einen Teams-Besprechungsraum bewege. Rechner 1 ist via Teams App eingewählt, der aufnehmende Rechner nutzt Google Chrome. Die Aufnahme erfolgt mittels [Audio Hijack](https://rogueamoeba.com/audiohijack/). Die Dateien wurden nicht bearbeitet oder komprimiert, sie liegen im FLAC-Format vor, um etwaige Kompressionsartefakte zu vermeiden.

### Die Testkandidaten

- [MacBook Pro 13 2019](https://support.apple.com/kb/SP795?locale=de_DE) (eingebautes Mikrofon)
- [Plantronics C275](https://www.poly.com/de/de/support/product/blackwire-725) (USB Headset)
- [Jabra Evolve2 65](https://www.jabra.com.de/business/office-headsets/jabra-evolve/jabra-evolve2-65) (Bluetooth Headset)
- [Jabra Elite 85](https://www.jabra.com.de/bluetooth-headsets/jabra-elite-85t) (Bluetooth In-Ears)
- [Shure SM7B Mikrofon](https://www.shure.com/de-DE/produkte/mikrofone/sm7b) + [SSL2+ USB Interface](https://www.solidstatelogic.com/products/ssl2-plus)

## Bordmittel: Das MacBook Pro Mikrofon

Das eingebaute Mikrofon und die Lautsprecher des eigenen Rechners sind die simpelste Möglichkeit, an einem Online-Meeting teilzunehmen. Allerdings ist hier die Abhängigkeit an die Position des Sprechers relativ hoch. Auch die Dämpfung von Umgebungsgeräuschen klappt - zumindest beim Modell von 2019 - nicht sonderlich gut. Dafür ist der Klang erstaunlich basslastig und "voll", leider wirkt es jedoch so, als stünde der Sprecher im gekachelten stillen Örtchen des Hauses.

Insgesamt ist es reichlich anstrengend, mit dieser Klangqualität lange konzentriert zuzuhören, vor allem mit Kopfhörern.

| Vorteile | Nachteile |
|-------|--------|---------|
| + "Eh da" | - Klangqualität ("WC-Effekt") |
| + hohe Bewegungsfreiheit für den Sprecher | - Bewegung beeinflusst den Klang stark  |
|  | - Hintergrundgeräusche werden kaum ausgeblendet |

#### MacBook Pro Mikrofon in stiller Umgebung
{% include embed-audio.html src="/assets/audio/teamstest/macbook_builtin_mic_teams_silent.flac" %}

#### MacBook Pro Mikrofon in Büroumgebung
{% include embed-audio.html src="/assets/audio/teamstest/macbook_builtin_mic_teams_noisy.flac" %}

## USB-Headset: Plantronics C275

Plantronics - heutzutage Poly - ist nicht nur in den Call-Centern dieser Welt weit verbreitet, haben sie doch eine ausgiebige Erfahrung mit Headsets. Allerdings stammen ihre Wurzeln aus der Telefonie, was ich bei dem Klangbeispiel deutlich wahrnehme. Im Gegensatz zum MacBook fehlen Frequenzen, was zunächst den Eindruck erweckt, dass die Qualität schlechter sein muss. Die Sprachverständlichkeit empfinde ich jedoch als deutlich besser, wenngleich die betonten Mitten gewöhnungsbedürftig sind.

Bei den Hintergrundgeräuschen muss man schon aufmerksam sein, um diese überhaupt wahrzunehmen. Hier zeigt sich die Erfahrung aus lauten Call-Centern.

| Vorteile | Nachteile |
|-------|--------|---------|
| + Klare Sprachverständlichkeit, aber | - eingeschränkte Frequenzen lassen die Stimme aggressiver klingen |
| + Kleine Bewegungen haben keinen Einfluß auf Klang | - Durch das Kabel eingeschränkter Bewegungsradius  |
| + Hervorragende Filterung von Hintergrundgeräuschen |   |

#### Plantronics C275 in stiller Umgebung
{% include embed-audio.html src="/assets/audio/teamstest/headset_c725_usb_teams_silent.flac" %}

#### Plantronics C275 in Büroumgebung
{% include embed-audio.html src="/assets/audio/teamstest/headset_c725_usb_teams_noisy.flac" %}

## Bluetooth Headset: Jabra Evolve2 65

Der erste Klangeindruck erinnert mich an 32kbit/s MP3s von 1999. Hier fehlt dank des Bluetooth-Codecs eine ganze Menge an Frequenzen, noch mehr als bei der USB-Variante des Plantronics. Ebenso wie das C275 versteht es das Jabra Evolve2 jedoch, die Hintergrundgeräusche ordentlich zu reduzieren. Von all meinen Bluetooth-Headsets hat dieses hier die höchste Reichweite, auch durch Wände. Die hohe Flexibilität und Bewegungsfreiheit von Bluetooth erkauft man sich mit spürbaren Einbußen beim Klang für die anderen Teilnehmer. Immerhin reicht der Akku für nahezu 40 Stunden und zur Not lässt sich das Headset auch mit angeschlossenem USB-Kabel betreiben.

| Vorteile | Nachteile |
|-------|--------|---------|
| + Hohe Flexibilität dank Bluetooth mit hoher Reichweite | - Stark komprimiert klingende Stimme |
| + Sehr gute Filterung von Hintergrundgeräuschen |   |
| + Sehr gute Akkulaufzeit |   |

#### Jabra Evolve2 65 in stiller Umgebung
{% include embed-audio.html src="/assets/audio/teamstest/headset_evolve265_bt_teams_silent.flac" %}

#### Jabra Evolve2 65 in Büroumgebung
{% include embed-audio.html src="/assets/audio/teamstest/headset_evolve265_bt_teams_noisy.flac" %}

## Bluetooth In-Ears: Jabra Elite 85t

Noch ein Kandidat aus dem Hause Jabra, hier gab es schon zu Beginn kleine Schwierigkeiten, die Stöpsel mit MS Teams zu verwenden. Bauartbedingt befindet sich das Mikrofon jetzt nicht mehr in der Nähe des Mundes, sondern in den Stöpseln selbst. Der Vorteil ist, dass sich somit die Entfernung zum Mund bei Bewegung nicht ändert und den Klang verfremdet, aber insgesamt klingt die Aufnahme ebenfalls nach dem gekachelten stillen Örtchen. Die Kompressionsartefakte sind deutlich zu hören. Dafür filtern die Mikrofone Umgebungsgeräusche erstaunlich gut. Mit Active-Noice-Cancellation schaffen die Inears gute 5 Stunden, ohne sogar 7. Dank des Lade-Etuis und hoffentlich ein paar Pausen könnte man somit auch einen langen Arbeitstag schaffen, man sollte aber zwingend eine Alternative zur Hand haben, da hier kein USB-Kabel hilfreich einspringen kann.

| Vorteile | Nachteile |
|-------|--------|---------|
| + Hohe Flexibilität dank Bluetooth mit guter Reichweite | - Stark komprimiert klingende Stimme |
| + Solide Filterung von Hintergrundgeräuschen | - Wenn Akku leer, dann ist Schluß  |

##### Jabra Elite 85t in stiller Umgebung
{% include embed-audio.html src="/assets/audio/teamstest/inear_elite85t_bt_teams_silent.flac" %}

##### Jabra Elite 85t in Büroumgebung
{% include embed-audio.html src="/assets/audio/teamstest/inear_elite85t_bt_teams_noisy.flac" %}

## Mikrofon und Interface: Shure SM7B + SSL2+

Als Referenz das Mikrofon am beweglichen Arm nebst Interface. Im Unterschied zu den anderen Lösungen lässt sich das Mikrofon hier nicht so leicht verbergen, es sei denn, man spricht immer etwas "ins off". Das SM7B ist kein hochempfindliches Kondensatormikrofon, sondern ein sehr hungriges dynamisches Mikrofon. Prinzipiell verhält es sich jedoch auch wie andere (USB-)Mikrofone für Streams auf YouTube & Co. Die Beweglichkeit des Sprechers ist absolut gegeben, jedoch verändert sich der Klang massiv, je nachdem, wie weit oder wie seitlich man vom Mikrofon positioniert ist. Man merkt, wie hart MS Teams die Frequenzen beschränkt, denn obwohl der Klang von allen Lösungen der vollste ist, bleibt die Kombination weit hinter den Möglichkeiten bei der Direktaufnahme zurück. Hintergrundgeräusche kann das Mikrofon ausreichend gut ausblenden, solange diese nicht aus derselben Richtung wie der Sprecher kommen.

| Vorteile | Nachteile |
|-------|--------|---------|
| + Höchste Klangqualität, aber | - erfordert Disziplin beim Sprechen ins Mikrofon |
| + Ausreichende Filterung von Hintergrundgeräuschen |   |
| + Hohe Bewegungsfreiheit des Sprechers und keine Akkulaufzeiten |   |

Shure SM7B + SSL2+ in stiller Umgebung
{% include embed-audio.html src="/assets/audio/teamstest/mic_sm7b_teams_silent.flac" %}

Shure SM7B + SSL2+ in Büroumgebung
{% include embed-audio.html src="/assets/audio/teamstest/mic_sm7b_teams_noisy.flac" %}

## Fazit

Keine der hier vorgestellten Lösungen ist die eierlegende Wollmilchsau. Zunächst sollte man seine Priorität klären: Will ich überwiegend zuhören oder überwiegend sprechen? Ist mir Bewegungsfreiheit wichtig? Soll mein Gegenüber ermüdungsfrei zuhören können?

Meine Lieblingskombination von **Mikrofon und Interface** sorgt leider dafür, dass ich mich zu sehr eingeschränkt fühle. Ich versuche immer, den optimalen Klang zu erreichen, indem ich diszipliniert in das Mikrofon spreche. Daher nutze ich das Setup nur in wenigen Fällen, wenn es eben auf einen entscheidenden Klang ankommt. Zum Beispiel bei Präsentationen, die bestenfalls noch aufgenommen werden. Für den überwiegenden Teil der Meetings kommt das **Jabra Evolve2 65** zum Einsatz, da es mir ermöglich, bei bestmöglicher Verständlichkeit auch mal aufzustehen und ein wenig von links nach rechts zu gehen, ohne dass der Ton beeinflusst wird. Das Kabel des **Plantronics** schränkt mich zu sehr ein, daher ist dieser nur noch in der Schublade. Das eingebaute **Mikrofon des MacBook Pro** geht aus so vielen Gründen nicht - höchstens zur Not im Home Office.

Für den Konsum - wenn ich gar nicht sprechen muss - von Meetings oder Aufzeichnungen erarbeiten sich die **Jabra Elite 85t** gerade den Spitzenplatz - so angenehm sind die anderen Hörer nicht auf den Ohren.

Macht euch selbst ein Bild davon, was ihr bevorzugt. Und nicht vergessen: Der Zwischenschritt von MS Teams (oder Zoom, Google Hangouts, BlueJeans, etc) verändert den Klang nochmal deutlich, so wie ihr am Rechner euch aufnehmt, so hören euch eure Gegenüber meist nicht.
