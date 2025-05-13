#
# load.sh
#
# script does the following:
#  1. download the OSM meta file (stats) and compare it against a cached version from the last time the tiles were built
#  2. if the OSM meta (stats) data is are different, then will:
#   - download new OSM data 
#   - call import.sh  -- sub-process to rebuild *.mbtiles here in test, and validate that it's good
#
LDIR=`dirname $0`
. $LDIR/base.sh


function update_osm_data() {

  # step 0: make sure we have a data dir
  if [ ! -d $OMT_DATA_DIR ]; then
    mkdir -p $OMT_DATA_DIR
  fi

  # step 1: move old OSM data aside
  mv $OMT_DATA_DIR/$OSM_META_FILE /tmp/
  mv $OMT_DATA_DIR/$OSM_FILE /tmp/ 
  mv $OMT_DATA_DIR/*mbtiles /tmp/

  # step 2: grab new data
  curl $OSM_META_URL > $OMT_DATA_DIR/$OSM_META_FILE
  curl $OSM_DATA_URL > $OMT_DATA_DIR/$OSM_FILE

  # step 3: check new OSM data for size, etc... if not valid, revert back to old stuff
  size=`ls -ltr $OMT_DATA_DIR/$OSM_FILE | awk -F" " '{ print $5 }'`
  if [[ $size -lt $OSM_PBF_SIZE ]]
  then
    echo "$OMT_DATA_DIR/$OSM_FILE is wayyy too small at $size"
    exit
  fi
}

# main: update data
NOW=$( date '+%F @ %H:%M:%S' ) 
echo "tile reload is starting ($NOW)" 

check_osm_meta_data
new=$?
if [ $new == 1 ]; then
  echo "step A: blow away existing GL / OMT Docker and data, including build + cache dirs"
  # $LDIR/nuke.sh NALL - will shut down other running containers, ala geoserver
  cd $OMT_DIR
  docker-compose down
  rm -rf /tmp/*
  rm -rf $OMT_DIR/build $OMT_DIR/cache

  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step B: load and create *.mbtiles in openmaptiles/data dir ($NOW)"
  update_osm_data

  NOW=$( date '+%F @ %H:%M:%S' ) 
  echo "step C: build new *mbtiles file $($NOW)"
  quickstart.sh or-wa

  NOW=$( date '+%F @ %H:%M:%S' ) 
  NSECS=60
  echo "step D: restart tileserver-gl and test some URLs ($NOW) ... will sleep for $NSECS"
  $OMT_DIR/scripts/start_gl_nohup.sh
  sleep $NSECS

  echo "step E: test... ($NOW)"
  $OMT_DIR/scripts/test_gl_images.sh
  cd -
fi

NOW=$( date '+%F @ %H:%M:%S' ) 
echo "tile reload is DONE ($NOW)"
