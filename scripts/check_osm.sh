#
# simple test script for up-to-date OSM data based on compare of cached geofabrik osm meta data file
#
DIR=`dirname $0`
. $DIR/base.sh

cd $OMT_DIR
./scripts/git_update.sh

check_osm_meta_data
new=$?
if [ $new == 1 ]; then
  echo "NEW: yes there is **NEW** osm data to load"
else
  echo "OLD: osm data is up-to-date"
fi
