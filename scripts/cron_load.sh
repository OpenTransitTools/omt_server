#
# cron_load.sh
#
# script does the following:
#  1. download the OSM meta file (stats) and compare it against a cached version from the last time the tiles were built
#  2. if the OSM meta (stats) data is are different, then will:
#   - download new OSM data 
#   - call import.sh  -- sub-process to rebuild *.mbtiles here in test, and validate that it's good
#   - bolt_reload.sh  -- sub-process to deploy new *.mbtiles server to remote (staging / production) servers via 'bolt'
#   - bolt_restart.sh -- sub-process to restart remote servers after new *.mbtiles are deployed there
#   - bolt_clear.sh   -- test that tileserver-gl is up and responding on remote servers, then clear file (tile) cache
#
DIR=`dirname $0`
. $DIR/base.sh


function update_osm_data() {

  # step 1: move old OSM data aside
  if [ ! -d $OMT_DATA_DIR ]; then
    mkdir -p $OMT_DATA_DIR
  else
    old_osm_dir="$OMT_DIR/old/"

    rm -rf /tmp/old
    mv $old_osm_dir /tmp/
    rm -rf $old_osm_dir
    mkdir -p $old_osm_dir
    mv $OMT_DATA_DIR/$OSM_META_FILE $old_osm_dir
    mv $OMT_DATA_DIR/$OSM_FILE $old_osm_dir
    mv $OMT_DATA_DIR/*mbtiles $old_osm_dir
  fi

  # step 2: grab new data
  curl $OSM_META_URL > $OMT_DATA_DIR/$OSM_META_FILE
  curl $OSM_DATA_URL > $OMT_DATA_DIR/$OSM_FILE

  # step 3: check new OSM data for size, etc... if not valid, revert back to old stuff
  size=`ls -ltr $OMT_DATA_DIR/$OSM_FILE | awk -F" " '{ print $5 }'`
  if [[ $size -lt 10000000 ]]
  then
    echo "$OMT_DATA_DIR/$OSM_FILE is wayyy too small at $size"
    exit
  fi
}


# main: update data
NOW=$( date '+%F @ %H:%M:%S' ) 
echo "tile reload is starting ($NOW)" 
rm -rf /tmp/*

cd $OMT_DIR
./scripts/git_update.sh

check_osm_meta_data
new=$?
if [ $new == 1 ]; then
  echo "step A: blow away existing GL / OMT Docker and data"
  $DIR/nuke.sh ALL

  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step B: load and create *.mbtiles in openmaptiles/data dir ($NOW)"
  update_osm_data

  cd $OMT_DIR
  ./scripts/import.sh

  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step C: restart and test GL with this new *.mbtiles file ($NOW)"
  cd $OMT_DIR
  ./scripts/mbtiles/copy.sh
  ./scripts/mbtiles/restart.sh
 
  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step D: deploy this *.mbtiles into the GREEN/BLUE system not in production ($NOW)"
  cd $OMT_DIR
  ./scripts/bolt/deploy.sh

  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step E: test... ($NOW)"
  cd $OMT_DIR
  ./scripts/test_gl_images.sh
fi

NOW=$( date '+%F @ %H:%M:%S' ) 
echo "tile reload is DONE ($NOW)"
