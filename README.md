omt_server
==========

The omt_server project contains:
  1. [blah](README.md) ...

install:
  1. install python 3.7 (works with py versions >= 2.7), zc.buildout and git
  1. git clone https://github.com/OpenTransitTools/omt_server.git
  1. cd omt_server
  1. buildout

run:
  1. bin/test
  1. ...

edit styles:
  1. mapnik
  1. Might have to understand underlying data: https://openmaptiles.org/schema/#poi
  1. Finally, the editor might muck with the data and font URLs.  So good to have an script to fix that...
     "glyphs": "http://localhost:8080/fonts/{fontstack}/{range}.pbf",
     "glyphs": "{fontstack}/{range}.pbf",
     "url": "http://localhost:8080/data/or-wa.json"
     "url": "mbtiles://or-wa.mbtiles"