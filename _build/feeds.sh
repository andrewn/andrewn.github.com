#!/bin/sh

ruby _bin/flickr.rb > _site/includes/flickr.html
ruby _bin/pinboard.rb > _site/includes/pinboard.html
