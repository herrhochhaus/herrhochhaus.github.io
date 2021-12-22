---
layout: post
title: Alles liest sich besser mit Comic Sans
categories: [digital]
excerpt: Eine meiner Lieblingsschriftarten ist tatsächlich Comic Sans. Mit diesem Bookmarklet kann man jede Webseite auf Knopfdruck in Comic Sans lesen.
---

Bookmarklets sind ein unterschätztes Stück Technik. Jeder kennt klassische Bookmarks, mit denen man sich im Browser eine lesenswerte Seite in die Favoritenleiste legt (oder in den Untiefen des Lesezeichen-Menüs für immer vergräbt). Meine bevorzugte Anwendung neben Linkablagen ist die Nutzung kleiner Funktionen im Alltag. Fun with websites.

Viele Programme bieten Bookmarklets an, so kann man zum Beispiel Inhalte von Webseiten markieren und mittels Bookmarklet an eine App wie [DevonThink]() zur Ablage schicken. Oder, und das ist mein persönlicher Liebling, man kopiert etwas Javascript Code in ein Lesezeichen in der Favoritenleiste. Erzeug dir ein Lesenzeichen (einer beliebigen Webseite) und dann ersetz den Linktext mit folgendem Inhalt:

```javascript
javascript:(function()%7Bvar%20s%3D(document.getElementsByTagName(%27head%27)%5B0%5D%7C%7Cdocument.body).appendChild(document.createElement(%27style%27))%3Bvar%20t%3Ddocument.createTextNode(%27*%7Bfont-family:Comic%20Sans%20MS,Comic%20Sans,sans-serif%20!important%3B%7D%27)%3Bs.appendChild(t)%3B%7D)()%3B
```

Ich nenne dieses Bookmarklet: _Happy It!_

Was passiert in diesem Snippet? Alle Texte auf einer Webseite (aber natürlich nicht auf Bildern) werden auf Knopfruck in Comic Sans verwandelt. Magisch. Besonders eignet sich diese Technik für Seiten mit nervigem Inhalt wie Corona-Informationen oder Webauftritte von Schlangenöl-Beratern. Zumindest ich kann mir ein Schmunzeln nicht verkneifen, wenn Inhalte in Comic Sans dargestellt werden. Probier es mal selbst auf [Spiegel Online](https://www.spiegel.de), der [Tagesschau](https://www.tagesschau.de) oder auch [Github](https://github.com) aus.
