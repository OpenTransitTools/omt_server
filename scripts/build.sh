POSTGIS_IMAGE=openmaptiles/postgis-preloaded \
 docker-compose pull --ignore-pull-failures --quiet openmaptiles-tools generate-vectortiles postgres

docker-compose down -v --remove-orphans
docker-compose rm -fv
docker-compose run --rm --user=10041:10041 openmaptiles-tools bash -c 'generate-imposm3 openmaptiles.yaml > build/mapping.yaml'
docker-compose run --rm --user=10041:10041 openmaptiles-tools bash -c \
  'generate-sql openmaptiles.yaml --dir ./build/sql \
  && generate-sqltomvt openmaptiles.yaml \
  --key --gzip --postgis-ver 3.3.4 \
  --function --fname=getmvt >> ./build/sql/run_last.sql'

docker-compose run --rm --user=10041:10041 openmaptiles-tools pgwait
docker-compose run --rm --user=10041:10041 openmaptiles-tools sh -c 'pgwait && import-osm data/or-wa.osm.pbf'
docker-compose run --rm --user=10041:10041 openmaptiles-tools import-wikidata --cache /cache/wikidata-cache.json openmaptiles.yaml

docker-compose run --rm --user=10041:10041 openmaptiles-tools sh -c 'pgwait && import-sql' | \
 awk -v s=": WARNING:" '1{print; fflush()} $0~s{print "\n*** WARNING detected, aborting"; exit(1)}' | \
 awk '1{print; fflush()} $0~".*ERROR" {txt=$0} END{ if(txt){print "\n*** ERROR detected, aborting:"; print txt; exit(1)} }'

docker-compose run --rm --user=10041:10041 openmaptiles-tools psql.sh -v ON_ERROR_STOP=1 -P pager=off -c 'ANALYZE VERBOSE;'
docker-compose run --rm --user=10041:10041 openmaptiles-tools test-perf openmaptiles.yaml --test null --no-color
docker-compose run --rm --user=10041:10041 openmaptiles-tools pgwait
docker-compose run -T --rm --user=10041:10041 openmaptiles-tools generate-tiles
