---
layout: page
title: Kettlebells
permalink: /kettlebells/
---

Dank der Corona-Lockdowns habe ich das Training mit Kettlebells für mich entdeckt. Es gibt zahlreiche Trainingspläne, hier eine Auswahl derer, mit denen ich gute Erfahrungen gemacht habe.

## Simple & Sinister

{% include lightbox.html src="kbtimelesscheatsheetthumb.jpg" data="group" title="Timeless Simple Cheat Sheet" %}{: style="float: right; margin-right: 1em; max-width: 250px;"}


Der Trainingsplan für [Simple and Sinister](https://www.amazon.de/Kettlebell-Simple-Sinister-Revised-Updated-ebook/dp/B07ZQKWMKR) ist genau das: leicht und schnell zu lernen. Nach einem kurzen Warm-Up besteht es nur aus 2 Übungen und kann in etwa einer halben Stunde gut absolviert werden. Inklusive Warm-Up und Stretching. Daher empfiehlt Pavel, der Vater des Trainingsplans, häufiges Training mit 6 Einheiten pro Woche.

- Swings (in der Regel one-handed, aber auch beidhändig an bestimmten Tagen)
- Turkish Get-Up

Der Plan ([lade dir hier das Cheat Sheet herunter](/files/kb_timeless_simple_cheat_sheet_v1.pdf)) sieht so aus:

<table>
  {% for row in site.data.simplesinister %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}

    {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %}
  {% endfor %}
</table>

## Dry Fighting Weight (DFF) by Geoff Neupert

Geoff Neupert ist ein Coach bei StrongFirst und hat das berühmte DFW-Programm entwickelt. (Details dazu in diesem Blogpost)[https://www.strongfirst.com/dry-fighting-weight/].

Ähnlich wie beim Simple & Sinister gibt es im wesentlichen nur zwei Übungen:

- Clean & Press
- Front Squad

Allerdings werden die Übungen idealerweise mit zwei gleichen Kettlebells durchgeführt. Zunächst gilt es, das eigene RM (Repetition Max) herauszufinden. Nimm hierzu das Gewicht, welches du fünfmal pressen kannst, nicht weniger (und bestenfalls nicht sonderlich viel mehr).

Das Training umfasst fünf Wochen und besteht entweder aus Ladders (erst Set mit 1 Wiederholung, dann 2, dann 3, dann 2, dann 1 - Repeat!) oder Sets (jeweils 1, 2 oder 3 Wiederholungen pro Set). Führe zunächste ein Set Clean & Press aus, dann Front Squads. Pause. Wie lange soll die Pause sein? Nicht zu kurz und nicht zu lang, Geoff empfiehlt so viele Wiederholungen wie möglich und gleichzeitig so "frisch" wie möglich zu bleiben. Nach 30 Minuten ist das Training vorbei.

Die Wochen gliedern sich wie folgt:

<table>
  {% for row in site.data.dfw %}
    {% if forloop.first %}
    <tr>
      {% for pair in row %}
        <th>{{ pair[0] }}</th>
      {% endfor %}
    </tr>
    {% endif %}

    {% tablerow pair in row %}
      {{ pair[1] }}
    {% endtablerow %}
  {% endfor %}
</table>
