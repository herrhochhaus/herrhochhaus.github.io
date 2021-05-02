---
layout: page
title: Kettlebells
permalink: /kettlebells/
---

Hier kommt demnächst mehr zu meinem Kettlebell-Training.

## Simple & Sinister

{% include lightbox.html src="kbtimelesscheatsheetthumb.jpg" data="group" title="Timeless Simple Cheat Sheet" %}{: style="float: right; margin-right: 1em; max-width: 250px;"}


Der Trainingsplan für [Simple and Sinister](https://www.amazon.de/Kettlebell-Simple-Sinister-Revised-Updated-ebook/dp/B07ZQKWMKR) ist genau das: leicht und schnell zu lernen. Nach einem kurzen Warm-Up besteht es nur aus 2 Übungen und kann in etwa einer halben Stunde gut absolviert werden. Inklusive Warm-Up und Stretching. Daher empfiehlt Pavel, der Vater des Trainingsplans, häufiges Training mit 6 Einheiten pro Woche.

- Swings (in der Regel one-handed, aber auch beidhändig an bestimmten Tagen)
- Turkish Get-Up

Der Plan ([lade dir hier das Cheat Sheet herunter](/files/kb_timeless_simple_cheat_sheet_v1.pdf)) sieht so aus:

<table>
  {% for row in site.data.kbtraining %}
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
