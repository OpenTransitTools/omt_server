DIR=`dirname $0`
$DIR/git_update.sh
cd $DIR/../openmaptiles/
mkdir ./data/

if [ -f data/*.pbf ]; then
  echo import data
else
  # 2nd attempt ... if osm.pdf data exists in top dir, we'll use that
  if [ -f ../../*.osm.pbf ]; then
    cp ../../*.osm.pbf ./data/
    echo importing ../../*.osm.pbf
  else
    echo not loading ... move an OSM .pbf file into $PWD/data/
  fi
fi

# steps to import data
make refresh-docker-images
make destroy-db
make init-dirs
make clean
make all
make start-db
make import-data
make import-osm
make import-borders
make import-wikidata
make import-sql
make analyze-db
make test-perf-null
make generate-dc-config
make generate-tiles

