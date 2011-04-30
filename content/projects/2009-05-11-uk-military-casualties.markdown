---

title: UK Military Casualties statistics
tech: [ Flash, Perl, Template Toolkit, Modest Maps ]
link: ["View the map", "http://news.bbc.co.uk/1/hi/uk/7780497.stm"]

---

A BBC News project collating all the teenage homicides in the UK for a year.

## Templates

I wrote several templates including:

* HTML table of all victims
* JSON feeds to support interactive map and charts

## Infographic map

A simple infographic-style map that plots all the homicides in the UK geographically. The map uses the [Modest Maps](http://modestmaps.com/) Flash library with a custom background image of the UK. 

The map exposes a javascript API allowing the page to control which points are displayed. This enables the map to be changes as the data is filtered on the page. 

## Charts

Flash is used to draw the bar chart on the page. 

The templates mentioned above initially generate the simple breakdown bar charts as static HTML and CSS. Javascript on the page then adds the ability to filter the data.

## Table filter

Simple, re-usable class to allow the table to be filtered. [View the code](http://news.bbc.co.uk/nol/shared/spl/hi/in_depth/teen_homicide/js/thdb_table_searcher.js).