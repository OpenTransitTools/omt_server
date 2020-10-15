# prep the openmaptiles (remote repo) directory
DIR=`dirname $0`
$DIR/git_update.sh

# make the output directory
cd $DIR/../openmaptiles/
mkdir ./data/
rm ./data/*yml

# check data directory (maybe use in omt_server/../*pbf) for a .pbf file to import
if [ -f data/*.pbf ]; then
  echo import data
else
  # 2nd attempt ... if osm.pdf data exists in parent dir (omt_server/../*pbf), use that
  if [ -f ../../*.osm.pbf ]; then
    cp ../../*.osm.pbf ./data/
    echo importing ../../*.osm.pbf
  else
    echo not loading ... move an OSM .pbf file into $PWD/data/
  fi
fi


# steps to import data
echo "step 1 of 3: clean"
make refresh-docker-images
make destroy-db
make init-dirs
make clean
make all

echo "step 2 of 3: import boarders, wiki and OSM into PG (silently takes time...)"
make start-db
make import-data
make import-osm
make import-borders
make import-wikidata
make import-sql
make analyze-db
make test-perf-null

echo "step 3 of 3: generate .mbtiles file"
make generate-dc-config
../scripts/yml_updates.sh
make generate-tiles
