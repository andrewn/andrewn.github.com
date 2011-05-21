---

title: Olympic and Paralympic Heroes Parade live map
tech: [ Flash, Perl, Modest Maps ]
link: ["View the map", "http://news.bbc.co.uk/sport1/hi/olympic_games/7669416.stm"]

---

An interactive live map tracking the Beijing Olympics 'heroes parade' integrating geo-located Twitter and Flickr content.

A Perl service was used to poll the journalist's Twitter messages and extracted geo-tagged content. The augmented feed was then published to BBC infrastructure. This ensured that there was reslience in case Twitter failed.

The Flickr geo API was used to fetch photos around the parade route.

The map was created using the Modest Maps Flash library.