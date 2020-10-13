omt_server
==========

The omt_server project is:
  1. a build / run environment atop OpenMapTiles https://github.com/openmaptiles/openmaptiles
  1. it includes scripts to build tiles (mbtile file) from OSM data
  1. it also includes scripts to run a GL server based off a built .mbtiles file
  1. there are also a set of gl styles that GL can consume
  1. finally, there scripts to manage (nuke) docker, etc...

build tile *.mbtiles file from OSM:
  1. cd ~/
  1. 

run tile server:
  1. cd ~/omt_server/gl
  1. ls ./data -> borders or-wa.dc-config.yml  or-wa.mbtiles
  1. tmux new-session -d -s my_session 'run.sh >> out.txt 2>&1'
  1. http://localhost:8080

edit styles:
  1. mapnik
  1. Might have to understand underlying data: https://openmaptiles.org/schema/#poi
  1. Finally, the editor might muck with the data and font URLs.  So good to have an script to fix that...
     "glyphs": "http://localhost:8080/fonts/{fontstack}/{range}.pbf",
     "glyphs": "{fontstack}/{range}.pbf",
     "url": "http://localhost:8080/data/or-wa.json"
     "url": "mbtiles://or-wa.mbtiles"

install python scripts (not currently used):
  1. install python 3.7 (works with py versions >= 2.7), zc.buildout and git
  1. git clone https://github.com/OpenTransitTools/omt_server.git
  1. cd omt_server
  1. buildout

